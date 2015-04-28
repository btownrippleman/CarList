-----------------------------------------------------------------------------------------
--
-- list.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )


-- File local reference to the global data
local g = globalAppData


-- Render a row in the table widget
local function onRowRender( event )
	-- Get the row to render and the corresponding car record
	local row = event.row
	local index = row.index
	local car = g.cars[index]

	-- Make the row text
	local brandText = g.brands[car.brand]
	local styleText = g.styles[car.style]
	local yearsText = g.years[car.year]
	local color     = g.colors[car.color]
	local rowText = yearsText .. " " .. brandText .. " " .. styleText .. " "

	-- Draw the row
	local rowHeight = row.contentHeight
	local rowWidth = row.contentWidth
	local rowTitle = display.newText( row, rowText, 0, 0, native.systemFont, 18 )
	rowTitle:setFillColor( 0 )	-- black text
	rowTitle.anchorX = 0  	-- left aligned
	rowTitle.x = 15	 	-- leave a small left margin
	rowTitle.y = rowHeight * 0.5  -- vertically centered
end

if color then colorButtonWidgetMake(row) end

local function colorButtonWidgetMake(row)


					local button = widget.newButton{
							left = g.width - 90 , top = row.y, width = 90, height = row.height,
							label = row.color,
							font = native.systemFontBold,
							onRelease = editColorBtnPush
					}
			row:insert(button)
end


local function editColorBtnPush()

end

-- Edit the car at the given index in the list in details view
function scene:editCar( index )
	-- Remember the car index and make a copy of it, then go to the car view
	g.carIndex = index
	g.car = copyCarRecord( g.cars[index] )
	composer.gotoScene( "car", { effect = "slideLeft", time = 350 } )
end


-- Handle a touch event for a row in the table widget
local function onRowTouch( event )
	if event.phase == "tap" or event.phase == "release" then
		scene:editCar( event.target.index )
	end
end

-- Clear the car list
function scene:clearList()
	g.cars = {}
	g.carIndex = nil
	g.car = nil
	self.tableView:deleteAllRows()
end

-- Handler that gets notified when the Clear alert closes
local function onClearAlertComplete( event )
    if event.action == "clicked" then
        if event.index == 2 then  -- Clear pressed
					g.cars = {}
        	scene:clearList()
        end
    end
end

-- Handle a push on the Clear button
local function clearBtnPush(event)
	-- Show alert to confirm the clear
	native.showAlert( "Car List", "Clear all Cars?", { "Cancel", "Clear" }, onClearAlertComplete )
end

-- Add a car and edit it in the details view
function scene:addCar()
	-- Make a new default car and edit it in the car view
	g.carIndex = #g.cars + 1   -- Add new car past end of current list
	g.car = defaultCarRecord()
	composer.gotoScene( "car", { effect = "slideLeft", time = 250 } )
end

-- Handle a push on the Add (+) button
local function addBtnPush(event)
	scene:addCar()
end


-- Called when the scene's view does not exist.
function scene:create( event )
	local sceneGroup = self.view


	local title = display.newText("All Cars",display.contentWidth*.5,20,"",18) -- added for problem #1
	title:setFillColor(0,0,0)
	sceneGroup:insert( title )


	-- Make a light gray background
	local bg = display.newRect( sceneGroup, g.xCenter, g.yCenter, g.width, g.height )
	bg:setFillColor( 0.9 )

	-- Create the Clear button
	self.clearBtn = widget.newButton{
	    left = 0, top = 10, width = 70, height = g.topMargin,
	    label = "Clear",
	    font = native.systemFontBold,
	    onRelease = clearBtnPush
	}
	sceneGroup:insert( self.clearBtn )

	-- Create the Add (+) button
	self.addBtn = widget.newButton{
	    left = g.width - 30, top = 10, width = 30, height = g.topMargin,
	    label = "+",
	    font = native.systemFontBold,
	    onRelease = addBtnPush
	}
	sceneGroup:insert( self.addBtn )

	-- Create the table widget
	self.tableView = widget.newTableView
	{
	    left = 0,
	    top = g.topMargin,
	    height = g.height - g.topMargin,
	    width = g.width,
	    onRowRender = onRowRender,
	    onRowTouch = onRowTouch,
	}
	sceneGroup:insert( self.tableView )

end

-- Called when the scene is about to show or is now showing
function scene:show( event )


	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		self.tableView:deleteAllRows{} -- wow, this was all I had to do for #4 of the assignment .. aside from what I did in main.lua and car.lua

		-- If we are coming back from editing a car, change the cars array
		if g.car and g.carIndex then
			g.cars[g.carIndex] = g.car
			g.car = nil
			g.carIndex = nil
		end

		-- Make sure the table widget has enough rows for the cars list
		local t = self.tableView
		while #g.cars > t:getNumRows() do
			t:insertRow{}
		end

		self.tableView:scrollToY( { y=0, time=0, onComplete=scrollComplete } )
		-- Init or reload the table widget for any changes made after editing

		if t:getNumRows() > 0 then
			self.tableView:reloadData()	 -- this crashes if there are 0 cars
		end
	elseif phase == "did" then

		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

-- Called when the scene is about to hide or is now hidden
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

-- Called prior to the removal of scene's "view" (sceneGroup)
function scene:destroy( event )
	local sceneGroup = self.view

	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
