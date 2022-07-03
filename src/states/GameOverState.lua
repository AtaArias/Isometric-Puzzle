GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.lastLevel = params.level
end

function GameOverState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {level = self.lastLevel})
    end
end

function GameOverState:render()
    -- simple UI code
    --love.graphics.setFont(flappyFont)
    love.graphics.printf('Press enter to retry', 0, 64, WINDOW_WIDTH, 'center')

    --love.graphics.setFont(mediumFont)
    --love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end