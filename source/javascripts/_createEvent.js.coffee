if document.title is "Create Event"
	options = {
		# first is the index second is the value third is placeholder
		title: ["input", "title test", "Title"]
		# if it is a select then the first index the element second is the selected option and then every other is the option text the next one is the value for that option
		category: ["select", "opt2", "opt1", "val1", "opt2", "val2", "opt3", "val3"]
		location:
			lat: ["input", "", "Lat"]
			lon: ["input", "", "Lon"]
	}

	html = crazySimpleParse options

	window.onload = ->
		resultElement = document.getElementById("result")
		lastUpdate = ""
		callback = ->
			thisUpdate = JSON.stringify(options, null, " ")
			if lastUpdate isnt thisUpdate
				resultElement.value = thisUpdate
				lastUpdate = thisUpdate
		app = document.getElementById "app"
		app.innerHTML = html

		LiveHTML_Object("app", options, "result", 200, callback)
