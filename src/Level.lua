Level = Class{}

-- all maps are 5 x 5

function Level:init(level)
    self.num = level
    self.map = gMaps[self.num] -- number array
    self:linkToTiles() -- tiled array
end

function Level:linkToTiles()
    local tiled = {}
    for x = 0, 4 do
        for y = 0, 4 do
            local thisTile = {z = 0}

            local index = self.map[5 * y + 1 + x]
            if index == 1 then
                thisTile.bad = false
            elseif index == 2 then
                thisTile.bad = true
            else
                thisTile.bad = false
                thisTile.empty = true
            end

            table.insert(tiled, thisTile)
        end
    end

    self.map = tiled
end

function Level:badTiles(x, y)
    for x = 0, 4 do
        for y = 0, 4 do
            local thisTile = self.map[5 * y + 1 + x]

            if thisTile.bad then
                return true
            end
        end
    end

    return false
end

function Level:render()
    love.graphics.translate(WINDOW_WIDTH / 2 - 16, 40)

    for y = 0, 4 do
        for x = 0, 4 do
            local thisTile = self.map[5 * y + x + 1]

            if thisTile.empty then
                goto continue
            end
            
            local texture

            if thisTile.bad then
                texture = gTiles['badTile']
            else
                texture = gTiles['tile']
            end

            local drawX = 32 * x - 32 * y
            local drawY = 16 * x + 16 * y + thisTile.z
            
            love.graphics.draw(texture, drawX, drawY)

            ::continue::
        end
    end

    love.graphics.origin()
end

function Level:inScreen()
    for y = 0, 4 do
        for x = 0, 4 do
            local z = self.map[5 * y + x +1].z

            local drawY = 16 * x + 16 * y + z
            if drawY < WINDOW_HEIGHT then
                return true
            end
        end
    end  
    return false
end

function Level:setOutside()
    for y = 0, 4 do
        for x = 0, 4 do
            local thisTile = self.map[5 * y + x + 1]

            thisTile.z = WINDOW_WIDTH - 40
        end
    end
end
