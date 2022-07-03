LevelSelectState = Class{__includes = BaseState}

local scaleFac = 0.5

local xoff, yoff = 2.5 * scaleFac * 64, 80

local boxPos = {}

local touching

function LevelSelectState:init()
    self.selectedLevel = 1

    xoff, yoff = 3.5 * scaleFac * 64, 80
end

local leftButton =  {x = 10, y = WINDOW_HEIGHT / 3 + 8, width = 40, height = WINDOW_HEIGHT / 3}
local rightButton = {x = WINDOW_WIDTH - 50, y = WINDOW_HEIGHT / 3 + 8, width = 40, height = WINDOW_HEIGHT / 3}

local function mouseClick(button)
    if not love.mouse.isDown(1) then
        return false
    end

    local msx, msy = push:toGame(love.mouse.getPosition())

    if msx < button.x or msx > button.x + button.width then
        return false
    end

    if msy < button.y or msy > button.y + button.height then
        return false
    end

    return true
end

local function drawButtons()
    love.graphics.setColor(1,1,1,0.6)

    local l = leftButton
    love.graphics.rectangle('fill', l.x, l.y, l.width, l.height, 4)
    love.graphics.polygon('fill', l.x + 30, l.y + l.height / 3, l.x + 30, l.y + l.height / 3 * 2, l.x + 10, l.y + l.height/2)

    local r = rightButton
    love.graphics.rectangle('fill', r.x, r.y, r.width, r.height, 4)
    love.graphics.polygon('fill', r.x + 10, r.y + r.height / 3, r.x + 10, r.y + r.height / 3 * 2, r.x + 30, r.y + r.height/2)

    love.graphics.setColor(1,1,1,1)
end

function LevelSelectState:update(dt)
    touching = 0

    --check for input and begin that level
    local mousex, mousey = push:toGame(love.mouse.getPosition())

    if not mousex or not mousey then
        return 
    end 

    if touchingLevel(mousex, mousey) then
        touching = touchingLevel(mousex, mousey)
        if love.mouse.wasPressed then
            gStateMachine:change('play', {level = touching})
        end
    end

    if love.keyboard.isDown('left') or mouseClick(leftButton) then
        xoff = xoff + 100 * dt
        xoff = math.min(12 * scaleFac * 32, xoff)
    elseif love.keyboard.isDown('right') or mouseClick(rightButton) then
        xoff = xoff - 100 * dt
    end

    boxPos = {}
end

function LevelSelectState:render()
    drawBackground()
    drawLevelGrid()
    drawButtons()
end

function drawLevelGrid()
    local x, y = xoff, yoff
    x, y = math.floor(x), math.floor(y)

    for i, map in ipairs(gMaps) do
        drawMiniMap(map, x, y, i == touching)
        x = x + 12 * scaleFac * 32
    end
end

function drawMiniMap(map, x, y, flag)
    love.graphics.translate(x, y)
    love.graphics.scale(-scaleFac, scaleFac)

    --draw rectangle behind

    love.graphics.setColor(0.2,0.2,0.2,1)
    love.graphics.rectangle('fill', -2 * 64 -10, -10, 5 * 64 + 20 , 6 * 32 + 20, 6)

    local msx, msy = push:toGame(love.mouse.getPosition())
    love.graphics.setColor(135 / 255, 206 / 255, 250 / 255, 1)

    if flag then
        love.graphics.setColor(135 / 255 / 3 * 2, 206 / 255/ 3 * 2, 250 / 255 / 3 * 2, 1)
    end

    
    love.graphics.rectangle('fill', -2 * 64, 0, 5 * 64, 6 * 32, 4)
    love.graphics.setColor(1,1,1,1)

    for y = 0, 4 do
        for x = 0, 4 do
            index = map[x + 1 + 5 * y]
            if index == 0 then
                goto continue
            elseif index == 1 then
                texture = gTiles['tile']
            else 
                texture = gTiles['badTile']
            end
            drawX = 32 * x - 32 * y
            drawY = 16 * x + 16 * y 

            love.graphics.draw(texture, drawX, drawY)

            ::continue::
        end
    end

    local x1, y1 = love.graphics.transformPoint(-2 * 64, 0)
    local x2, y2 = love.graphics.transformPoint(3 * 64 , 6 * 32)

    table.insert(boxPos, {x1, y1, x2, y2})

    love.graphics.origin()
end

function touchingLevel(x, y)
    local msx, msy = x , y 

    for _, button in pairs({leftButton, rightButton}) do -- if the mouse is over a button do not do anything
        if msx < button.x or msx > button.x + button.width then
            -- nothing 
        elseif msy < button.y or msy > button.y + button.height then
            -- nothing
        else
            return false
        end
    end

    for i, verts in ipairs(boxPos) do
        -- vertices are rotated because the maps are rotated
        if msx > verts[3] and msx < verts[1] and msy > verts[2] and msy < verts[4] then
            return i
        end
    end

    return false
end
