class WGOAT
	constructor: (params) ->
		# default options
		@options =
			calendarElement: null
			get: 
				from: [1,1,14]
				to: 5 # days after
			dir: 'events/'
			links: true
			tags: true
			images: true
			sortBy: 'most-recent'
			# thats good for now

		# add params to options if any
		if typeof params is 'object'
			@options[option] = value for option, value of params
	
	### Green light... Go Go Go! ###
	run: ->
		console.log @options.dir

		filename = 'test.json'
		ajax = new @Ajax
			url: window.location + @options.dir + filename,
			contentType: 'application/json'
			callback: (res) ->
				if res.status == 200 || 304
					console.log(JSON.parse(res.responseText))
				else
					console.log(JSON.parse(res.responseText))

		ajax.doGet()

	### Abstract Ajax ###
	Ajax: (options2) ->

		xhr = new XMLHttpRequest()

		xhr.onload = @processRequest

		processRequest: ->
			if options2.callback then options2.callback xhr

		@doGet = ->
			xhr.open "GET", options2.url, true
			xhr.overrideMimeType options2.contentType
			xhr.send null
		something = "to stop function return"

root = window
root.WGOAT = WGOAT