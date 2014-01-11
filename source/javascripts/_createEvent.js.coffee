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
				address: ["input", "", "type", "text", "placeholder", "Address"]
				Egeocode: ["input", "geocode", "type", "button", "onclick", "geocode(this);"]
				lat: ["input", "", "type", "text", "placeholder", "Lat"]
				lon: ["input", "", "type", "text", "placeholder", "Lon"]
				Ergeocode: ["input", "geocode", "type", "button", "onclick", "reversegeocode(this);"]
			clearStorage: ["input", "ClearStorage", "type", "button", "onclick", "localStorage.clear();"]
			submit: ["input", "generate", "type", "submit"]
		}

	html = crazySimpleParse options
	@resultElement
	
	reversegeocode = (e) ->
		console.log "revers geocoding"
		e.disabled = true
		setTimeout(->
			e.disabled = false
			console.log "ready"
		, 5000)

	geocode = (e) ->

		console.log "GeoCoding"
		e.disabled = true
		setTimeout(->
			e.disabled = false
			console.log "ready"
		, 5000)

	generate = ->
		@resultElement.value = JSON.stringify(options, null, " ");

		return false

	window.generate = generate
	window.geocode = geocode
	window.reversegeocode = reversegeocode
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
