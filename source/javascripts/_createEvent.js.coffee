if document.title is "Create Event"
	# Only God and I know what I was thinking when I wrote this
	crazySimpleParse = (obj) ->
		crazySimpleParse.recurse(obj)
	
	crazySimpleParse.recurse = (obj, parentName) ->
		if parentName?
				# create group
				html += """<div data-parentname="#{parentName}">\n"""
				@recursing obj
				html += """</div>"""
		
		else @recursing obj
	crazySimpleParse.recursing = (obj) ->
		for prop of obj
			if obj[prop] instanceof Array
				
				if obj[prop][0] is 'select'
					html += """<select name="#{prop}">\n"""
					# this is a select element the options are
					for i in [2..obj[prop].length - 1] by 2
						selected = ""
						if obj[prop][i] is obj[prop][1]
							selected = " selected"
						html += """  <option value="#{obj[prop][i + 1]}"#{selected}>#{obj[prop][i]}</option>\n"""
					html += """</select>\n"""
				
				else if obj[prop][0] is 'input'
					html += """  <input type="text" name="#{prop}" value="#{obj[prop][1]}" placeholder="#{obj[prop][2]}">\n"""
		
			else if obj[prop] instanceof Object
				@recurse obj[prop], prop
	options = {
		# first is the index second is the value third is placeholder
		title: ["input", "title test", "Title"]
		# if it is a select then the first index the element second is the selected option and then every other is the option text the next one is the value for that option
		category: ["select", "opt2", "opt1", "val1", "opt2", "val2", "opt3", "val3"]
		location:
			lat: ["input", "", "Lat"]
			lon: ["input", "", "Lon"]
	}

	html = ""
	crazySimpleParse options

	window.onload = ->
		console.log html
		document.getElementById("app").innerHTML = html