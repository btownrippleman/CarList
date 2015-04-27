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
	local values = scene.colorPicker:getValues()
	local color = values[1].index  -- Save the data for the car we are currently selecting
  g.car.color = color
	-- Go back to the list view
	composer.gotoScene( "car", { effect = "slideRight", time = 350 } )
end

-- Handle a push of the Cancel button
local function cancelBtnPush( event )

	-- Go back to the list view
	composer.gotoScene( "car", { effect = "slideRight", time = 350 } )
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
 end

-- Called when the scene is about to show or is now showing
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then




		-- Create the car brand and body style picker wheel.
		-- This widget needs to be temporary because there is no way
		-- to programmatically change the selection for a new use.
		self.colorPicker = widget.newPickerWheel{
			top = g.topMargin,
			fontSize = 16,
			columns = {

				-- Middle column is car body styles
				{
					align = "center",
					labels = g.colors,
					startIndex = 3,

				},
				-- Middle column is car body styles

			}
		}
		sceneGroup:insert( self.colorPicker )
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
		if self.colorPicker then
			self.colorPicker:removeSelf()
			self.colorPicker = nil
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
