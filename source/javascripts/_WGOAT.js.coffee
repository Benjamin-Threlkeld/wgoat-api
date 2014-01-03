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


		@eachRecursive(params, @options
			(k, test) ->
				console.log test[k]
				#@options[k] = params[k]
				return
				#@options[option] = value for option, value of params
		)
		console.log @options
	### for each, but recursive ###
	eachRecursive: (object, test, callback) ->
		if !callback?
			throw new Error "eachRecursive: requires a callback. Use an argument for the key"

		for k of object
			console.log("run")
			if object[k]? and typeof object[k] is 'object'
				@eachRecursive(object[k], test, callback)
			else
				callback(k, test)
	
	### Green light... Go Go Go! ###
	run: ->
		d = @figureDateRange @options.dateRange
		console.log(d.start.getDate())

	### abstracting dateRange ###
	figureDateRange: (d) ->
		# basic functionality
		start = new Date()
		to = d.to

		if Object.prototype.toString.call d.from is '[object Array]' && d.from.length < 4
			start.setMonth d.from[0], d.from[1]
			start.setFullYear(if d.from[2] > 99 then d.from[2] else 2000 + d.from[2])
		else 
			throw new Error "DateRange: must have three indexed in the array eg: [d,m,yy]"
		
		console.log d.to
		if ((parseInt d.to || 0))
			console.log "pass " + to
		else
			console.log "fail " + to
		{start: start, to: to}

	### get files, add to object ###
	get: (fileDate) ->
		ajax = new @Ajax
			url: window.location + @options.dir + filename,
			contentType: 'application/json'
			callback: (res) ->
				if res.status is 200 || res.status is 304
					console.log "got it"
				else
					console.log "error"

		ajax.doGet()

	### Abstract Ajax ###
	Ajax: (options) ->
		console.log "running ajax"
		xhr = new XMLHttpRequest()

		xhr.onload = @processRequest

		processRequest: ->
			if options.callback then options.callback xhr

		@doGet = ->
			xhr.open "GET", options.url, true
			xhr.overrideMimeType options.contentType
			xhr.send null
		return

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