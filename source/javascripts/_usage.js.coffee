#Instantiate


# only the returned result will be used, so this must retun a string of HTML. 
# The date object is avilable through the first argument
preEvents = ->
	"<h1>Town's Events</h1>"

preEvent = (d) ->
	dString = wgoat.formatDate(d, '%D, %j')
	"<h3>#{dString}</h3>"

eachEvent = (event, t) ->


wgoat = new WGOAT
	dateRange: 
		from: [1,1,14]
		to: 4
	dir: 'events/'
	sortBy: 'soonest'
	parsing:
		preEvent: ->
			preEvent()
		preEvents: ->
			preEvents()
		eachEvent: ->
			eachEvent()

wgoat.run()
