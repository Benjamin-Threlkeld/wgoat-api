#Instantiate

wgoat = new WGOAT
	calendarElement: document.querySelector 'section.calendar'
	dateRange: 
		from: [1,1,14]
		to: 0
	dir: 'events/'
	sortBy: 'most-recent'

wgoat.run();