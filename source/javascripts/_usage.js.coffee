#Instantiate

if document.title is "WGOAT API"
	# only the returned result will be used, so this must retun a string of HTML. 
	# The date object is avilable through the first argument
	preEvents = ->
		"<h1>Town's Events</h1>"

	preEvent = (d) ->
		"<h3>#{wgoat.formatDate(d, '%F %j, %Y')}</h3>"

	eachEvent = (event, t) ->
		"""
		<div class="event">
		  <p class="description">#{event.description}</p>
		</div>
		"""

	noEvents = () ->
		"""
		<h1>NO EVENTS!<span class="sad">:_(</span>
		<p>Within the criteria, change the filter in settings, I don't know where it is either. :P</p>
		"""

	wgoat = new WGOAT
		dateRange:
			from: [1,1,14]
			to: 4
		dir: 'events/'
		sortBy: 'soonest'
		parsing:
			preEvent: (d) ->
				preEvent(d)
			preEvents: ->
				preEvents()
			eachEvent: (event, t) ->
				eachEvent(event, t)
			noEvents: ->
				noEvents()
	wgoat.run()
	window.w = wgoat





	### extra advanced toys ###
	class setOptions
		from: ->
			res = @.value.split(',', 3).map(Number)
			wgoat.options.dateRange.from = res
		to: ->
			res = parseInt(@.value, 10)
			wgoat.options.dateRange.to = res

	# if element does not exsist then run function when loaded else run function
	settingsPannel = ->
		setOption = new setOptions()
		element = document.getElementById "settings"
		if element?
			inputEle = element.querySelectorAll "input"
			inputs = {}
			# abstract elements and add listeners
			for ele in [0..inputEle.length - 1]
				inputs[inputEle[ele].name] = inputEle[ele]
			console.log inputs
			inputs.from.addEventListener "keyup", setOption.from, false
			inputs.to.addEventListener "keyup", setOption.to, false
			inputs.update.addEventListener "click", wgoat.run, false

			

	if document.readyState is "interactive"
		settingsPannel()
		console.log "ran"
	else
		wgoat.attachToOnload(settingsPannel)
		console.log "attached"

