#Instantiate


# only the returned result will be used, so this must retun a string of HTML. 
# The date object is avilable through the first argument
preEvents = ->
	"<h1>Town's Events</h1>"

preEvent = (d) ->
	dString = wgoat.formatDate(d, '%F, %j')
	"<h3>#{dString}</h3>"

eachEvent = (event, t) ->
	"""
	<div class="event">
	  <p class="description">#{event.description}</p>
	</div>
	"""

noEvents = () ->
	"""
	<h1>NO EVENTS!<span class="sad">:_(</span>
	<p>Within the criteria, change the filter in settings, I don't know where it is either. :P</p>"""

wgoat = new WGOAT
	dateRange:
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

wgoat.run()
