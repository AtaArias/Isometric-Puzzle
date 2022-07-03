StartState = Class{__includes = BaseState}

-- menu and ui handeling

-- TODO: Implement functional UI
local actions = {
    function() gStateMachine:change('play', {level = 1}) end,
    function() gStateMachine:change('level-select') end,
    function() gStateMachine:change('option-select') end
}

local selected = 1

local menuX, menuWidth = WINDOW_WIDTH / 3, WINDOW_WIDTH / 3 

function StartState:update(dt)
    selected = 0
    local msx, msy = push:toGame(love.mouse.getPosition())

    if not msx or not msy then
        return 
    end
    
    if msx > menuX and msx < menuX + menuWidth then
        if msy > 120 then
            --nothing
        elseif msy > 90 then
            selected = 3
        elseif msy > 60 then
            selected = 2
        elseif msy > 24 then
            selected = 1
        end

        if love.mouse.wasPressed then
            gSounds['button']:play()
            actions[selected]()
        end
    end
 end

local function shadow(text, x, y, width, align)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1 - r, 1 - g, 1 - b, a)
    love.graphics.printf(text, x - 1, y - 1, width, align)
    love.graphics.setColor(r, g, b, a)
end

function StartState:render()
    drawBackground()

    love.graphics.setFont(gFonts['small'])

    love.graphics.setColor(0.6,0.4,0.4,1)
    love.graphics.rectangle('fill', menuX, 0, menuWidth, WINDOW_HEIGHT)
    love.graphics.setColor(1,1,1,1)

    -- simply render the score to the middle of the screen
    if selected == 1 then love.graphics.setColor(0,0,0,1) end
    shadow('Play now', menuX, 30, menuWidth, 'center')
    love.graphics.printf('Play now', menuX, 30, menuWidth, 'center')
    love.graphics.setColor(1,1,1,1)

    if selected == 2 then love.graphics.setColor(0,0,0,1) end
    shadow('Select level', menuX, 60, menuWidth, 'center')
    love.graphics.printf('Select level', menuX, 60, menuWidth, 'center')
    love.graphics.setColor(1,1,1,1)

    if selected == 3 then love.graphics.setColor(0,0,0,1) end
    shadow('Options', menuX, 90, menuWidth, 'center')
    love.graphics.printf('Options', menuX, 90, menuWidth, 'center')
    love.graphics.setColor(1,1,1,1)
end

function StartState:enter()
    gSounds['music']:play()
end