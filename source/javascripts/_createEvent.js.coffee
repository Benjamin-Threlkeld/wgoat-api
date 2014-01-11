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
		app = document.getElementById("app")
		app.innerHTML = html
		inputs = {}
		elements = app.querySelectorAll("input, select, textarea")
		for element in [0..elements.length - 1]
			pNode = elements[element].parentNode.dataset.parentName || null
			if pNode is null
				inputs[elements[element].name] = elements[element]
			else
				# fix nested elements later
				if typeof inputs[pNode] is 'undefined'
					inputs[pNode] = {}
					inputs[pNode][elements[element].name] = elements[element]
				else
					inputs[pNode][elements[element].name] = elements[element]

		resultEle = document.getElementById "result"
		
		inter = (obj, obj2) ->
			for prop of obj
				if obj[prop][0]?
					obj[prop][1] = obj2[prop].value
				else
					inter obj[prop], obj2[prop]
						
		lastUpdate = ""
		setInterval(->
			#console.log options
			inter options, inputs
			thisUpdate = JSON.stringify(options,null," ")
			if lastUpdate isnt thisUpdate
				resultEle.value = thisUpdate
				lastUpdate = thisUpdate
		, 200)

