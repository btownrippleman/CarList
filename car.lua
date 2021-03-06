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
	composer.gotoScene( "list", { effect = "slideRight", time = 350 } )
end



function scene:deleteCar()
	-- delete the selected car, go back to the list view
   deleteCarRecord(g.carIndex)
	g.carIndex = #g.cars - 1
	composer.gotoScene( "list", { effect = "slideRight", time = 250 } )
end

local function deleteBtnPush(event)
	 scene:deleteCar()
end

local function addColorBtnPush(event)
	composer.gotoScene( "color", { effect = "slideLeft", time = 350 } )
end


-- Handle a push of the Cancel button
local function cancelBtnPush( event )
	-- Clear the reference to the car being edited
	g.car = nil
	g.carIndex = nil

	-- Go back to the list view
	composer.gotoScene( "list", { effect = "slideRight", time = 350 } )
end

-- Called when the scene's view does not exist.
function scene:create( event )
	local sceneGroup = self.view
  self.carTitle = display.newText("Car #" ..g.carIndex, display.contentWidth/2,20,"",18) --added for problem #2
	self.carTitle:setFillColor(0,0,0)
	sceneGroup:insert( self.carTitle )
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


	-- Create the Delete button
	self.deleteBtn = widget.newButton{
			left = g.width/2-23, top = g.height-10, width = 30, height = g.topMargin,
			label = "Delete",
			font = native.systemFontBold,
			onRelease = deleteBtnPush
	}
	sceneGroup:insert( self.deleteBtn )

	-- Create the Done button
	self.doneBtn = widget.newButton{
	    left = g.width - 70, top = 10, width = 70, height = g.topMargin,
	    label = "Done",
	    font = native.systemFontBold,
	    onRelease = doneBtnPush
	}
	sceneGroup:insert( self.doneBtn )

	-- Create the Color picked button
	self.colorBtn = widget.newButton{
				left = g.width - 115, top = g.height/2+70, width = 70, height = g.topMargin,
				label = "Color: " .. g.colors[g.car.color],
				font = native.systemFontBold,
				onRelease = addColorBtnPush
		}
		sceneGroup:insert( self.colorBtn )

end

-- Called when the scene is about to show or is now showing
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		if g.car.color then
			self.colorBtn:setLabel("Color: " .. g.colors[g.car.color])

		end

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
