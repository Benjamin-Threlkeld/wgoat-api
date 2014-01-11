if document.title is "Create Event"
	stored = localStorage.getItem('options') || null
	if stored?
		options = JSON.parse(stored)
		console.log("from storage")
	else
		options = {
			# index 0 is the element tag, index 1 is the value, from index 2 every other index is an attribute
			title: ["input", "title test", "type", "text", "placeholder", "Title"]
			# if it is a select then index 0 is the element, index 1 is the selected option and then every other (index 2) is the option text the next one is the value for that option
			category: ["select", "opt2", "opt1", "val1", "opt2", "val2", "opt3", "val3"]
			location:
				lat: ["input", "", "type", "text", "placeholder", "Lat"]
				lon: ["input", "", "type", "text", "placeholder", "Lon"]
			submit: ["input", "generate", "type", "submit"]
		}

	html = crazySimpleParse options
	@resultElement
	generate = ->
		@resultElement.value = JSON.stringify(options, null, " ");

		return false

	window.generate = generate

	window.onload = ->
		@resultElement = document.getElementById("result")
		lastUpdate = ""
		callback = ->
			thisUpdate = JSON.stringify(options)
			if lastUpdate isnt thisUpdate
				console.log "update"
				localStorage.setItem 'options', thisUpdate
				lastUpdate = thisUpdate
		app = document.getElementById "app"
		app.innerHTML = html

		LiveHTML_Object("app", options, "result", 200, callback)
