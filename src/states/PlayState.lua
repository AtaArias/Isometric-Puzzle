PlayState = Class{__includes = BaseState}

local psystem = love.graphics.newParticleSystem(PARTICLE, 25)
psystem:setParticleLifetime(0.5) -- life in seconds
psystem:setColors(0, 0, 0, 1, 1, 1, 0, 1) --

local psysX = 0; psysY = 0

function PlayState:enter(params)
    self.levelNum = params.level
    self.level = Level(self.levelNum)
    self.moves = 5
    self.power = 0

    player.x = 2; player.y = 2 -- move player to the center of the screen
end

function PlayState:update(dt)
    psystem:update(dt)

    local mousex, mousey = push:toGame(love.mouse.getPosition())
    mousey = mousey - 40

    if love.keyboard.wasPressed('r') then
        local nextLevel = Level(self.levelNum)
        gStateMachine:change('transition', {lvl1 = self.level, lvl2 = nextLevel})
    end

    if not mousex or not mousey then
        return
    end
    
    local mousex = mousex - WINDOW_WIDTH / 2 - 16
    local worldx, worldy = mousex / 2 +  mousey, -mousex / 2 + mousey
    local mapx, mapy = math.floor(worldx / 32), math.floor(worldy / 32)
    if mapx < 5 and mapx >= 0 and mapy < 5 and mapy >= 0 then
        thisTile = self.level.map[mapx + 1 + mapy * 5]

        if thisTile.empty then
            return -- don't move over empty tiles
        end

        thisTile.z = 10
        if love.mouse.wasPressed then
            local dist = math.abs(player.x - mapx) + math.abs(player.y - mapy)
            if dist < 2 + self.power and dist > 0 then
                gSounds['jump']:stop()
                gSounds['jump']:play()

                local lastTile = self.level.map[player.x + 1 + 5 * player.y]

                if dist > 1 then
                    self.power = self.power - dist + 1
                end

                if thisTile.bad then
                    psysX, psysY = push:toGame(love.mouse.getPosition())
                    psystem:emit(1)
                    gSounds['light']:stop()
                    gSounds['light']:play()
                    self.power = self.power + 1
                    -- spawn a + power
                end

                lastTile.empty = true
                
                thisTile.bad = false

                player.x = mapx; player.y = mapy

                -- check for the win condition
                if not self.level:badTiles() then
                    if (self.levelNum + 1) > #gMaps then
                        gStateMachine:change('win')
                    else
                        local nextLevel =  Level(self.levelNum + 1)
                        gStateMachine:change('transition', {lvl1 = self.level, lvl2 = nextLevel, nextNum = self.levelNum + 1})
                    end
                end

                -- check if we have any moves less
                if self.moves < 1 then
                    gStateMachine:change('game-over', {level = self.levelNum})
                end
            end
        end
    end
end

function PlayState:render()
    -- draw world
    if self.levelNum == 1 then
        love.graphics.printf('Click to move', WINDOW_WIDTH / 3 * 2, 20, WINDOW_WIDTH / 3, 'center')
        love.graphics.printf('Turn all the the lights off to win', WINDOW_WIDTH / 3 * 2, 70, WINDOW_WIDTH / 3, 'center')
    elseif self.levelNum == 2 then
        love.graphics.printf('Turn off a tile and get extra jump length', WINDOW_WIDTH / 3 * 2, 20, WINDOW_WIDTH / 3, 'center')
    end

    love.graphics.printf('Press R to restart', 0, 20, WINDOW_WIDTH / 3, 'center')

    love.graphics.translate(WINDOW_WIDTH / 2 - 16, 40)
    for y = 0, 4 do
        for x = 0, 4 do
            local thisTile = self.level.map[5 * y + x + 1]

            if thisTile.empty then
                goto continue
            end
            
            local texture

            if thisTile.bad then
                texture = gTiles['badTile']
            else
                texture = gTiles['tile']
            end

            drawX = 32 * x - 32 * y
            drawY = 16 * x + 16 * y + thisTile.z
            
            love.graphics.draw(texture, drawX, drawY)

            if y == player.y and x == player.x then
                love.graphics.draw(player.sprite, drawX, drawY + player.height)
            end

            if thisTile.z > 0 then
                thisTile.z = 0 
            end

            ::continue::
        end

    end
    love.graphics.origin()

    love.graphics.draw(psystem, psysX, psysY)
end

function PlayState:exit()
    psystem:reset()
end