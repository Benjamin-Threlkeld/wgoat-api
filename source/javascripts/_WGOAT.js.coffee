class WGOAT

	constructor: (params) ->
		# default options
		@options =
			calendarElement: '.calendar'
			dateRange: #day,month,two digit year
				from: [1,1,1]
				to: 5 # days after
			dir: 'events/'
			links: true
			tags: true
			images: true
			sortBy: 'soonest' # most-recent
			parsing:
				preEvents: @preEvents
				preEvent: @preEvent
				eachEvent: @eachEvent
			# thats good for now

		# add params to options if any
		@objectMergeRecursive @options, params;

	### Green light... Go Go Go! ###
	run: ->
		@activeAjaxConnections = 0
		@events = {events: {},keys: []}
		@eventsDates = @cantThinkOfName()


	### populateEventsObject ###
	parseObject: (fileDate, object) ->
		# this could be where it formats the dates and times, validate strings and stuff
		# loop over the file of events
		for event in [0..object.length - 1]
			# insert props to object
			object[event]['time'] = {}
			if object[event].startTime? then object[event].time['startTime'] = @timeFromString(object[event].startTime).getTime()
			if object[event].endTime? then object[event].time['endTime'] = @timeFromString(object[event].endTime).getTime()
			# will be usefull when sorting most-recent
			object[event].date = @eventsDates.dates[fileDate]
			object[event].fromFile = fileDate

		@events.events[fileDate] = object
		@events.keys.push fileDate
		return
	### Default event parse setup ###
	preEvents: ->
		"<h1>Town's Events</h1>"

	preEvent: (d) ->
		"<h3>#{d.getDate},#{d.getMonth},#{d.getFullYear}</h3>"
	
	eachEvent: (event, t) ->
		"""<p>event starts at #{t.start12Hour.getHours}:#{t.start12Hour.getMinutes+t.start12Hour.getPeriod}</p>"""
	
	### parseEvents ###
	parseEvents: ->
		# Day/Month arrays
		weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
		weekdays_abb = ["Sun","Mon","Tues","Weds","Thurs","Fri","Sat"]
		months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
		months_abb = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
		
		@sort @options.sortBy
		# do something on each event
		eventsHTML = @options.parsing.preEvent()
		# ready to do awesome
		for _day in [0..@events.keys.length - 1]
			# run whatever function is set for
			eventsHTML += @options.parsing.preEvent(new Date(@events.events[@events.keys[_day]])) + "\n"
			# for custom html before the events are listed, so the category. pass the date for easy use
			#@preEvent events.keys[_day]
			### Do stuff for each day ###
			for _event in [0..@events.events[@events.keys[_day]].length - 1]
				event = @events.events[@events.keys[_day]][_event]
				# set up time variables
				start24Hour = new Date(event.time.startTime)
				end24Hour = new Date(event.time.endTime)
				start12Hour = @timeTo12Hour start24Hour, "0M" 
				end12Hour = @timeTo12Hour end24Hour, "0M" 
				# time object
				T = 
					start24Hour: start24Hour
					end24Hour: end24Hour
					start12Hour: start12Hour
					end12Hour: end12Hour

				### Do stuff for day ###

				eventsHTML += @options.parsing.eachEvent event, T
				#console.log(@utils.timeFromString(event.startTime).getHours())
		
		@updateCalendar eventsHTML
	
	### sort ###
	sort: (method) ->
		switch method
			when "most-recent" then @sort_mostRecent()
			when "soonest" then @sort_soonest()
			else throw new Error "Sort: no sort method of that sort :)"
	
	### sorting methods ###
	sort_soonest: ->
		@events.keys.sort();
		for _day in [0..@events.keys.length - 1]
			for _event in [0..@events.events[@events.keys[_day]].length - 1]
				@events.events[@events.keys[_day]].sort (a,b) ->
					a.time.startTime - b.time.startTime
	
	sort_mostRecent: ->
		return

	### cantThinkOfName ###
	cantThinkOfName: () ->
		d = @figureDateRange @options.dateRange
		datesForFiles = {dates: {}, keys: []}
		# for every day from date until end date
		for day in [0..d.to]
			dateOffset = new Date(d.from.getTime())
			# add a day to the date
			dateOffset.setDate d.from.getDate() + day
			# format date
			name = "#{dateOffset.getDate()}.#{dateOffset.getMonth()}.#{dateOffset.getFullYear() - 2000}.json"
			# add formatted date and date time to object
			datesForFiles.dates[name] = dateOffset.getTime()
			# add formatted date as keys to array
			datesForFiles.keys.push name
			#get the file
			@get name
		
		# `for(var i = datesForFiles.keys.length - 1; i > -1; i--) {
		# 	thisDate = new Date(datesForFiles.dates[datesForFiles.keys[i]]);
		# 	console.log(thisDate.getDate());
		# }`
		datesForFiles
	
	### abstracting dateRange ###
	figureDateRange: (d) ->
		# basic functionality. Not sure how much error checking should be done
		# new date from array
		from = new Date((if d.from[2] > 99 then d.from[2] else 2000 + d.from[2]), d.from[1], d.from[0])
		to = d.to

		#if Object.prototype.toString.call d.from is '[object Array]' && d.from.length < 4
			# if to is a number and not empty
		if ((parseInt d.to, 10 || 0))
			to = d.to
		{from: from, to: to}

		#else 
		#	throw new Error "DateRange: must have three indexed in the array eg: [d,m,yy]"

	### get files, add to object ###
	get: (filename) ->
		@activeAjaxConnections++ # add an open connection
		ajax = new @Ajax
			scope: @
			#requestHeaders: [["filename", filename]]
			uri: window.location + @options.dir + filename,
			responseType: 'json'
			callback: (res) ->
				if res.readyState is 2
					@activeAjaxConnections-- # connection has returned headers
					if res.status is 404 then res.abort() # if error page then abort loading
				if res.readyState is 4 # if loading is done
					if res.status is 200 || res.status is 304 # if OK or Not Modified
						@parseObject filename, res.response # add the object to another
					if @activeAjaxConnections is 0 # if all the requests have been returned and are done loading
						@parseEvents()

		ajax.doGet()

	### Abstract Ajax ###
	Ajax: (options) ->
		processRequest = ->
			if !options.scope? then options.scope = this

			options.callback.call(options.scope, xhr) if options.callback?

		xhr = new XMLHttpRequest()
		xhr.onreadystatechange = processRequest

		@doGet = ->
			xhr.open "GET", options.uri, true
			if typeof options.requestHeaders is 'object'
				for r,i in options.requestHeaders
					xhr.setRequestHeader(options.requestHeaders[i][0],options.requestHeaders[i][1])
			xhr.responseType = options.responseType
			xhr.send null
		return
	
	realUpdateCalendar: (element, html) ->
		if typeof element is 'undefined'
			element = document.querySelector(@options.calendarElement) || null
		if element isnt null
			element.innerHTML = html
		else
			throw new ReferenceError "Calendar Element was not found using selector #{@options.calendarElement}"

	### updateCalendar ###
	updateCalendar: (html)->
		element = document.querySelector(@options.calendarElement) || null
		if element?
			@realUpdateCalendar(element, html)
		else
			@attachToOnload @realUpdateCalendar(element, html)
	
	###            ###
	###  Utilities ###
	###            ###

	### attachToOnload ###
	attachToOnload: (newFunction) ->
		oldOnLoad = undefined
		console.log "attaching"
		if typeof window.onload isnt "function"
			window.onload = newFunction
		else
			oldOnLoad = window.onload
			window.onload = ->
				oldOnLoad() if oldOnLoad
				newFunction()

	### Time From String ###
	timeFromString: (timeString) ->
		# This eats a string argument that is in some form of legible time and poops out a Date Object
		# Examples of valid times
		# `2pm` `2Am` `1403` `2:03p`

		# match |`digit`|`Passive`:|`digit``digit`|`whitespace`|`a` or `p`|case insensitive
		timeParsed = timeString.match(/(\d+)(?::(\d\d))?\s*([ap]?)/i)
		
		#timeParsed[0] is the first group
		#timeParsed[1] is the hour. if it is a 24hour time minute is null
		#timeParsed[2] is the minute
		#timeParsed[3] is "" if p does not exist else is "p" or "P"
		
		timeParsed[1] = parseInt(timeParsed[1], 10)
		timeParsed[2] = parseInt(timeParsed[2], 10)
		
		# time Hour, length of string
		timeParsedString = timeParsed[1] + ""
		timeParsedLen = timeParsedString.length
		addHours = 0
		tHours = timeParsed[1]
		tMinutes = timeParsed[2]
		
		#console.log(timeParsed);
		d = new Date() # set new date object
		# if 12 hour time
		if timeParsed[3].toUpperCase() is "P" and timeParsed[1] isnt 12
			addHours = 12
		# if 24 hour time
		else if timeParsed[3] is "" and isNaN(timeParsed[2])
			tHours = timeParsedString.substr(0, timeParsedLen - 2)
			tMinutes = timeParsedString.substr(timeParsedLen - 2)
		
			d.setHours parseInt(tHours, 10)
			d.setMinutes parseInt(tMinutes, 10)
		d.setHours parseInt(tHours, 10) + addHours
		d.setMinutes parseInt(tMinutes, 10) or 0
		d
	
	### Time To 12 Hour ###
	timeTo12Hour: (dObj, arg1, arg2, arg3) ->
		hours = dObj.getHours()
		minutes = dObj.getMinutes()
		h = undefined
		m = undefined
		p = undefined
		if hours is 12
			h = hours; m = minutes; p = "pm"
		else if hours > 12
			h = hours - 12; m = minutes; p = "pm"
		else
			h = hours; m = minutes; p = "am"

		if arg1 is "0M" || arg2 is "0M" || arg3 is "0M"
			if m < 10
				m = "0" + m

		if arg1 is "0H" || arg2 is "0H" || arg3 is "0H"
			if h < 10
				h = "0" + h

		getHours: h
		getMinutes: m
		getPeriod: p

	### Merge/Overwrite Object/Array ###
	objectMergeRecursive: (obj1, obj2) ->
		if Object.prototype.toString.call(obj1) is '[object Array]' &&
		   Object.prototype.toString.call(obj2) is '[object Array]'
			for row, i in obj2
				obj1[i] = obj2[i]
		else
			for k of obj2
				if typeof obj1[k] is 'object' and typeof obj2[k] is 'object'
					@objectMergeRecursive obj1[k], obj2[k]
				else
					obj1[k] = obj2[k]
	
	formatDate: (d, format) ->
		# match |`digit`|`Passive`:|`digit``digit`|`whitespace`|`a` or `p`|case insensitive
		#timeParsed = timeString.match(/(\d+)(?::(\d\d))?\s*([ap]?)/i)
		dateParsed = format.match(/\%/)
		#console.log format
		#console.log dateParsed

root = window
root.WGOAT = WGOAT