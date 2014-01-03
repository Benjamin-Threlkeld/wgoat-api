#Instantiate

wgoat = new WGOAT
	calendarElement: document.querySelector 'section.calendar'
	get: 
		from: [1,1,14]
		to: 5
	dir: 'events/'
	sortBy: 'most-recent'

wgoat.run();