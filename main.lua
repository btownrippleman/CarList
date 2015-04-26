-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local json = require( "json" )


-- This table holds all the global data that we want to access from each different scene.
globalAppData =
{
	-- Screen layout metrics
	width = display.contentWidth,
	height = display.contentHeight,
	xCenter = display.contentWidth / 2,
	yCenter = display.contentHeight / 2,
	topMargin = 55,   -- Room for title and buttons at the top of each scene

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

	-- The list of cars that the user is creating.
	-- This is an array of car records.
	-- A car record is a table { brand = brandIndex, style = styleIndex }
	cars = {},	  -- array starts out empty

	-- The car being edited in the detail scenes
	car = nil;  	 -- a copy of the car record being edited, or nil if none
	carIndex = nil;	 -- index of car in cars array being edited, or nil if none
	carTitle = nil;
}

-- File local reference to the global data
local g = globalAppData

-- Construct and return a default car record.
function defaultCarRecord( brandIndex, styleIndex )
	return { brand = 3, style = 2 }   -- Chevrolet Sedan
end

-- Return a copy of the car record at car
function copyCarRecord( car )
	return { brand = car.brand, style = car.style }
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
