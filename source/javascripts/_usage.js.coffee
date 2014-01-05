#Instantiate

wgoat = new WGOAT
	calendarElement: 'section.calendar'
	dateRange: 
		from: [1,1,14]
		to: 4
	dir: 'events/'
	sortBy: 'soonest'

wgoat.run()