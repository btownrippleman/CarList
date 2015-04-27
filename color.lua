-----------------------------------------------------------------------------------------
--
-- car.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require "json"

local widget = require( "widget" )


-- File local reference to the global data
local g = globalAppData


-- Handle a push of the Done button
local function doneBtnPush( event )
	-- Get the selected values from car picker wheel
	local values = scene.carPicker:getValues()
	local year = values[1].index
	local brand = values[2].index
	local style = values[3].index

	-- Save the data for the car we are currently editing

	g.car.year = year
	g.car.brand = brand
	g.car.style = style


	-- Go back to the list view
	composer.gotoScene( "list", { effect = "slideLeft", time = 350 } )
end

-- Handle a push of the Cancel button
local function cancelBtnPush( event )

	-- Go back to the list view
	composer.gotoScene( "list", { effect = "slideLeft", time = 350 } )
end

-- Called when the scene's view does not exist.
function scene:create( event )
	local sceneGroup = self.view
 	-- Make a light gray background
	local bg = display.newRect( sceneGroup, g.xCenter, g.yCenter, g.width, g.height )
	bg:setFillColor( 0.9 )
	sceneGroup:insert(bg)

	-- Create the Cancel button
	self.cancelBtn = widget.newButton{
	    left = 0, top = 10, width = 90, height = g.topMargin,
	    label = "Cancel",
	    font = native.systemFontBold,
	    onRelease = cancelBtnPush
	}
	sceneGroup:insert( self.cancelBtn )

	-- Create the Done button
	self.doneBtn = widget.newButton{
	    left = g.width - 70, top = 10, width = 70, height = g.topMargin,
	    label = "Done",
	    font = native.systemFontBold,
	    onRelease = doneBtnPush
	}
	sceneGroup:insert( self.doneBtn )
	sceneGroup:insert( self.carTitle )
end

-- Called when the scene is about to show or is now showing
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

	if self.carTitle then
		self.carTitle.text = "Car #" .. g.carIndex
	end

		-- Create the car brand and body style picker wheel.
		-- This widget needs to be temporary because there is no way
		-- to programmatically change the selection for a new use.
		self.carPicker = widget.newPickerWheel{
			top = g.topMargin,
			fontSize = 16,
			columns = {
				-- Left column is car brands
				{
					align = "left",
					labels = g.years,
					startIndex = g.car.year,

				},
				-- Middle column is car body styles
				{
					align = "center",
					labels = g.brands,
					startIndex = g.car.brand,

				},
				-- Middle column is car body styles
				{
					align = "right",
					labels = g.styles,
					startIndex = g.car.style,

				}
			}
		}
		sceneGroup:insert( self.carPicker )
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

-- Called when the scene is about to hide or is now hidden
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then


		-- Remove the picker wheel
		if self.carPicker then
			self.carPicker:removeSelf()
			self.carPicker = nil
		end
	end
end

-- Called prior to the removal of scene's "view" (sceneGroup)
function scene:destroy( event )
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
