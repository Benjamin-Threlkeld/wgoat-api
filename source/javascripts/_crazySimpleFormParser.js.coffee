html = ""
crazySimpleParse = (obj) ->
	crazySimpleParse.recurse(obj)
	console.log html
	return html

crazySimpleParse.recurse = (obj, parentName) ->
	if parentName?
			# create group
			html += """<div data-parent-name="#{parentName}">\n"""
			# rerecurse
			@recursing obj
			html += """</div>"""
	
	else @recursing obj
crazySimpleParse.recursing = (obj) ->
	for prop of obj
		# if prop repersents an element
		if obj[prop] instanceof Array
			# if element is a select
			if obj[prop][0] is 'select'
				html += """<select name="#{prop}">\n"""
				# this is a select element the options are
				for i in [2..obj[prop].length - 1] by 2
					selected = ""
					if obj[prop][i] is obj[prop][1]
						selected = " selected"
					html += """  <option value="#{obj[prop][i + 1]}"#{selected}>#{obj[prop][i]}</option>\n"""
				html += """</select>\n"""
			# if element is a slect
			else if obj[prop][0] is 'input'
				attributes = ""
				# for attributes
				for i in [2..obj[prop].length - 1] by 2
					attributes += " #{obj[prop][i]}=\"#{obj[prop][i + 1]}\""
				html += """  <input name="#{prop}" value="#{obj[prop][1]}"#{attributes}>\n"""
		# if element is a sub group
		else if obj[prop] instanceof Object
			@recurse obj[prop], prop

window.crazySimpleParse = crazySimpleParse