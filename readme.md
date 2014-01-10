Welcome to the WGOAT API
========================

WGOAT is an "API" for [Super-calendar](https://github.com/justinthrelkeld/community-calendar).

I know what it does but not how to advertise it to you :)

Now that it kinda works the docs can now be written.

- [Installation](#Installation)
	- [Setup](#Setup)
	- [Configure](#Configure)
		- [Set Calendar Element](#setCalendarElement)
		- [Set Events Folder](#setEventsFolder)
		- [Set Date Range](#setDateRange)
		- [Set the template](#HTMLTemplate)
		- [Set Sorting Method](#setSortingMethod)
		- [Parsing the events](#parseEvents)
- [Useful built-in utilities](#UsefulUtilities)
	- [Attach to on load](#AttachToOnLoad)
	- [Time from string](#TimeFromString)
	- [Format date](#FormatDate)
	- [Object Merge Recursive](#ObjectMergeRecursive)



## <a name="Installation"></a>Installation

Just load up WGOAT as a script. You may need to compile, rename or both


### <a name="Setup"></a>Setup
Just add this to the head

	<script type="text/javascript" src="./path/to/_WGOAT.js">
	
	<script type"text/javascript">
	
		wgoatInit = function() {
			wgoat = new WGOAT()
		};

		window.onload = wgoatInit

	</script>

All you really need now is an element with a `calender` class, and a folder named `events` and some events!
checkout [Configure](#Configure) for the awesomeness

## <a name="Configure"></a>Configure
WGOAT has many configurable options, more coming. Pass the parameters in an object:
	
	var wgoat = new WGOAT({
		calendarElement: "section.calendar", // a css selector to the events element
		dateRange: { //day,month,two/four digit year
			from: [1,1,14], // if from is null from will start from now
			to: 5 // days later
		},
		dir: "events/",
		links: true, // not implemented
		tags: true, // not implemented 
		images: true, // not implemented 
		sortBy: "soonest", // most-recent
		parsing: {
			preEvents: function() {
					return "I come before all event";
				},
			preEvent: function() {
					return "I come before each group/day of events";
				},
			eachEvent: function() {
					return "I come for every event that passes through";
				},
			postEvent: function() {
					return "I come to close your tags if you nested";
				},
			noEvents: function() {
				return '<p>And I come if no one else is around</p>' +
					'<img src="http://static3.wikia.nocookie.net/__cb20071019155932/uncyclopedia/images/7/7b/Dancing_banana.gif"></img>';
				}
			}
	});

##### <a name="setCalendarElement"></a>set calendarElement
	
	{ 
		calendarElement: "css.selector" 
	}

##### <a name="setDateRange"></a>Set Date Range
dateRange currently supports two properties: from and to, `from` can be an array [day,month,year] two or four digit year. Or (eventually) a string containing words like `tomorrow or yesterday` or somethings, maybe it's just a bad idea. `to` is an integer representing how many more days of events to retrieve

	{ 
		dateRange: {
			from: [1,1,14]
			to: 4
		}
	}

##### <a name="parseEvents"></a>Parse Events
To parse events simply use 

	wgoat.run()


## <a name="UsefulUtilities"></a>Useful built-in utilities
	
These can be accessed from the instance of WGOAT e.g.

		// new instance of WGOAT
		var wgoat = new WGOAT();

		// Accessing methods
		wgoat.theMethod(your, arguments);

### <a name="AttachToOnLoad"></a>Attach to on load

This method takes a function as an argument, the function will be set as the window.onload method call, if the widow already has a function set to it this method takes it a and throws it into an anonymous function with the new function, and they are self executing. 

	wgoat.attachToOnLoad(function(){
		alert("Document is loaded")
	});

Advanced usage:
	
	myFunction = function() {
		alert("Document is loaded");
	}

	if (document.readyState === "loading") {
		wgoat.attachToOnLoad(myFunction);
	} else {
		myFunction()
	}

### <a name="TimeFromString"></a>Time from string

This method takes a string, anything from 1p to 13:00 or even 1300, and returns a Date object

	var myDate = wgoat.timeFromString("1:30pm");

### Time to 12 hour
the method timeTo12Hour takes a date object converts it into a fake date object (an object with keys like the real date object). This method accepts 3 parameters.

`.timeTo12Hour(dateObject, ['0M','0H'], ['0M','0H'])`

`0M` means leading zeros for the minutes, `0H` means leading zeros for the hours
	
	// myDate was passed from the timeFromString method (not necessary)
	var my12HourTime = wgoat.timeTo12Hour(myDate, "0M");

	// notice how the properties are not functions
	var myFormattedTime = my12HourTime.getHours + ":" + my12HourTime.getMinutes;

### <a name="FormatDate"></a>Format date
This method is based on the [PHP date function][phpDate] with a splash of ruby's `%` sign. I'm thinking (I know scary, right?) that I may make the percent sign not required. unsupported characters/combos will not be changed.
	
`.formatDate(dateObject, "format")`

	var currentDate = new Date()
	var myFormattedDate = wgoat.formatDate(currentDate, "%F %j, %Y")



### <a name="ObjectMergeRecursive"></a>Object Merge Recursive
This method takes two objects as parameters and merges, overwrites or adds the properties from object2 to object1

`.objectMergeRecursive(object1, object2)`

	var currentPlaceForMyGoat = {
		yard: {
			grass: "green", 
			fence: false, 
			wolves: false, 
			ProtectedByHumans: true, 
			wonderfulPlace: true
		},
		price: '200/mo'
	}

	var newPlaceForMyGoat = {
		yard: {
			grass: "dead", 
			fence: true, 
			wolves: true, 
			ProtectedByHumans: false, 
			deepHoles: true
		},
		price: '20/mo',
		goatKiller: true
	}
	
	wgoat.objectMergeRecursive(currentPlaceForMyGoat, newPlaceForMyGoat);

currentPlaceForMyGoat would now be 
	
	{
		yard: {
			grass: "dead",
			fence: true,
			wolves: true,
			ProtectedByHumans: false,
			wonderfulPlace: true,
			deepHoles: true
		},
		price: "20/mo",
		goatKiller: true
	}

sorry :/ hahaha

[phpDate]: http://us3.php.net/manual/en/function.date.php