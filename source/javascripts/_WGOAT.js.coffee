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
			sortBy: 'most-recent'
			# thats good for now

		# add params to options if any
		@objectMergeRecursive @options, params;

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

	### Green light... Go Go Go! ###
	run: ->
		@activeAjaxConnections = 0
		@events = {events: {},keys: []}
		@eventsDates = @cantThinkOfName()

	### populateEventsObject ###
	parseObject: (filename, obj) ->
		console.log(filename)
		# this could be where it formats the dates, validate strings and stuff
		@events.events[filename] = obj
		@events.keys.push filename
		return

	### parseEvents ###
	parseEvents: ->
		eachEvent = (event)->
			# do something on each event
			console.log(event.startTime)

		eventsHTML = ""
		# ready to do awesome
		for _day in [0..@events.keys.length - 1]
			### Do stuff for each day ###
			for _event in [0..@events.events[@events.keys[_day]].length - 1]
				### Do stuff for day ###
				eachEvent @events.events[@events.keys[_day]][_event]
		

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

	### updateCalendar ###
	updateCalendar: ->
		attachToOnload ->
			cal = document.querySelector(@options.calendarElement)
			if not cal?
				throw new Error "updateCalendar: Calendar Element was not found using selector #{@options.calendarElement}"
				
	### attachToOnload ###
	attachToOnLoad: (newFunction) ->
		console.log("running attachToOnLoad")
		if typeof window.onload isnt 'function'
			window.onload = newFunction
		else
			oldOnLoad = window.onload
			window.onload = ->
				oldOnLoad()
				newFunction()


root = window
root.WGOAT = WGOAT