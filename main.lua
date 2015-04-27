-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local json = require( "json" )


local function yearsCreate(begin, ending) -- added but not used for the problem #3 of the assignment is there a way to get a for loop to make a JSON object?
	local years = "{"
	for i = begin,ending do
		years = years .. "\"" .. i .. "\", "
 	end
	years = years .. "\"" .. ending .. "\"},"
	return years
end



-- This table holds all the global data that we want to access from each different scene.
globalAppData =
{
	-- Screen layout metrics
	width = display.contentWidth,
	height = display.contentHeight,
	xCenter = display.contentWidth / 2,
	yCenter = display.contentHeight / 2,
	topMargin = 55,   -- Room for title and buttons at the top of each scene

	-- Car years generated with	for i = 1950,2015 do print("\"".. i .."\", ") end

	years = {   -- added for problem #3 of the assignment, i used a for loop in an online lua interpeter to make it
		"1950",
		"1951",
		"1952",
		"1953",
		"1954",
		"1955",
		"1956",
		"1957",
		"1958",
		"1959",
		"1960",
		"1961",
		"1962",
		"1963",
		"1964",
		"1965",
		"1966",
		"1967",
		"1968",
		"1969",
		"1970",
		"1971",
		"1972",
		"1973",
		"1974",
		"1975",
		"1976",
		"1977",
		"1978",
		"1979",
		"1980",
		"1981",
		"1982",
		"1983",
		"1984",
		"1985",
		"1986",
		"1987",
		"1988",
		"1989",
		"1990",
		"1991",
		"1992",
		"1993",
		"1994",
		"1995",
		"1996",
		"1997",
		"1998",
		"1999",
		"2000",
		"2001",
		"2002",
		"2003",
		"2004",
		"2005",
		"2006",
		"2007",
		"2008",
		"2009",
		"2010",
		"2011",
		"2012",
		"2013",
		"2014",
		"2015"},

 	--years = json.encode(yearsCreate(1977,1989)),

	-- Car brand names (constant)
	brands = {
		"Audi",
		"BMW",
		"Chevrolet",
		"Dodge",
		"Ford",
		"GMC",
		"Honda",
		"Porsche",
		"Subaru",
		"Toyota",
	},

	-- Car style names (constant)
	styles = {
		"Coupe",
		"Sedan",
		"Wagon",
		"Convertible",
		"SUV",
		"Truck",
	},

	colors = {
		"black",
		"white",
		"grey",
		"red",
		"orange",
		"yellow",
		"green",
		"light blue",
		"blue",
		"indigo",
		"violet",
		"camouflage"


	},

	-- The list of cars that the user is creating.
	-- This is an array of car records.
	-- A car record is a table { year =  yearsIndex, brand = brandIndex, style = styleIndex }
	cars = {},	  -- array starts out empty

	-- The car being edited in the detail scenes
	car = nil;  	 -- a copy of the car record being edited, or nil if none
	carIndex = nil;	 -- index of car in cars array being edited, or nil if none
 }

-- File local reference to the global data
local g = globalAppData

-- Construct and return a default car record.
function defaultCarRecord( yearsIndex, brandIndex, styleIndex )
	return { year = 65, brand = 3, style = 2}   -- 1987 Chevrolet Sedan
end

-- Return a copy of the car record at car
function copyCarRecord( car )
	return { year = car.year, brand = car.brand, style = car.style }
end

function deleteCarRecord( car ) -- added for problem #4 of the assignment, deletes a car from the table
    table.remove(g.cars, car)
  end

	-- Return the path name for the user data file where the car list is saved
local function dataFilePath()
	return system.pathForFile( "carData.txt", system.DocumentsDirectory )
end

-- Save the cars list to the user data file
local function saveCarData()
	local file = io.open( dataFilePath(), "w" )
	if file then
		file:write( json.encode( g.cars ) )
		io.close( file )
		print( "Car list saved: " .. #g.cars .. " cars" )
	end
end

-- Load the cars list from the user data file
local function loadCarData()
	local file = io.open( dataFilePath(), "r" )
	if file then
		local str = file:read( "*a" )	-- Read entile file as a string (JSON encoded)
		if str then
			local carTable = json.decode( str )
			if carTable then
				g.cars = carTable
				print( "Car list loaded: " .. #g.cars .. " cars" )
			end
		end
		io.close( file )
	end
end

-- Handle system events for the app
local function onSystemEvent( event )
	if event.type == "applicationSuspend" or event.type == "applicationExit" then
		saveCarData()
	end
end

-- Init the app
local function initApp()
	-- Load saved car data, if any
	  loadCarData()

	-- Add system event listener for the app (stays installed in all scenes)
	Runtime:addEventListener( "system", onSystemEvent )

	-- Start in the list view
	display.setStatusBar( display.HiddenStatusBar )
	composer.gotoScene( "list" )
end

-- Start the app
initApp()
