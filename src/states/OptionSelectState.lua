OptionSelectState = Class{__includes = BaseState}

local Slider = {x = WINDOW_WIDTH / 3, y = WINDOW_HEIGHT / 6 + 30, width = WINDOW_WIDTH / 3, ball = 1, 
                call = function(self) gSounds['music']:setVolume(self.ball) end}

local Slider2 = {x = WINDOW_WIDTH / 3, y = WINDOW_HEIGHT / 6 + 30 + 100, width = WINDOW_WIDTH / 3, ball = 1, 
                call = function(self) 
                    gSounds['light']:setVolume(self.ball)
                    gSounds['jump']:setVolume(self.ball) 
                    gSounds['button']:setVolume(self.ball)
                end}

local menuB = { x = 20, y = 20, width = 80, height = 30, text = 'Menu',
                call = function()
                    gSounds['button']:play()
                    gStateMachine:change('start')
                end,
                render = function(self) 
                    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 2)

                    love.graphics.setColor(0,0,0,1)
                    love.graphics.printf(self.text, self.x, self.y, self.width, 'center')

                    love.graphics.setColor(1,1,1,1)
                end,
                update = function(self)
                    msx, msy = push:toGame(love.mouse.getPosition())

                    if not msx or not msy then
                        return
                    elseif not love.mouse.isDown(1) then
                        return
                    end

                    if msx > self.x and msx < self.x + self.width and
                        msy > self.y and msy < self.y + self.width then
                            self.call()
                    end
                end
                }


function OptionSelectState:init()

end

local function drawSlider(s)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('fill', s.x, s.y, s.ball * s.width, 10)

    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('line', s.x, s.y, s.width, 10, 4)
    
    
    love.graphics.setColor(0,0,0,1)
    love.graphics.circle('fill', s.x + s.width * s.ball - 1, s.y + 5, 5)

    love.graphics.setColor(1,1,1,1)
end

local function SliderUpdate(s)
    if love.mouse.isDown(1) then
        local msx, msy = push:toGame(love.mouse.getPosition())

        if not msx or not msy then
            return
        end

        msx = msx - s.x
        msy = msy - s.y

        if msx < 0 or msx > s.width then
            return
        elseif msy < 0 or msy > 10 then
            return
        end

        s.ball = msx / s.width

        s:call()
    end
end



function OptionSelectState:update(dt)
    SliderUpdate(Slider)
    SliderUpdate(Slider2)

    menuB:update()
end

function OptionSelectState:render()
    drawBackground()

    love.graphics.printf('Music volume', WINDOW_WIDTH / 3, WINDOW_HEIGHT/ 6, WINDOW_WIDTH / 3, 'center')
    drawSlider(Slider)

    love.graphics.printf('Sfx volume', WINDOW_WIDTH / 3, WINDOW_HEIGHT/ 6 + 100, WINDOW_WIDTH / 3, 'center')
    drawSlider(Slider2)

    menuB:render()
end

    


-- TODO:
-- change background
-- select screen resolution