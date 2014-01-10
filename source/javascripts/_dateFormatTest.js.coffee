wgoat = new WGOAT()

wgoat.attachToOnload ->
	result = document.getElementById "result" || null
	if result?
		date = new Date 2014, 0, 1

		dateFormats = [
			# need more
			'%F %j, %Y' # January 1, 2014
			'%D, %d %M %Y' # Jan, 01 01 2014
		]

		for dateFormat in dateFormats
			
			result.innerHTML = wgoat.formatDate date, "<p>#{dateFormat}</p>#{result.innerHTML}"