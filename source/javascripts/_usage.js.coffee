#Instantiate

wgoat = new WGOAT
	calendarElement: document.querySelector 'section.calendar'
	dateRange: 
		from: [1,1,14]
		to: 10
	dir: 'eventssss/'
	sortBy: 'most-recent'

wgoat.run();