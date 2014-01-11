				
Interval = (obj, obj2) ->
	for prop of obj
		if obj[prop][0]?
			obj[prop][1] = obj2[prop].value
		else
			Interval obj[prop], obj2[prop]

LiveHTML_Object = (scope, liveObject, resultElement, interval, callback) ->
	inputs = {}
	@interval = interval
	scope = document.getElementById scope
	elements = scope.querySelectorAll("input, select, textarea")

	for element in [0..elements.length - 1]
		parentNode = elements[element].parentNode.dataset.parentName || null
		if parentNode is null
			inputs[elements[element].name] = elements[element]
		else
			# fix nested elements later
			if typeof inputs[parentNode] is 'undefined'
				inputs[parentNode] = {}
				inputs[parentNode][elements[element].name] = elements[element]
			else
				inputs[parentNode][elements[element].name] = elements[element]

	resultElement = document.getElementById resultElement

	lastUpdate = ""
	setInterval(->
		Interval liveObject, inputs
		callback()
	, @interval)


window.LiveHTML_Object = LiveHTML_Object