WinState = Class{__includes = BaseState}

function WinState:update(dt)

end

function WinState:render()
    drawBackground()
    love.graphics.setFont(gFonts['big'])
    love.graphics.printf('Congrats for winning!!', 0, WINDOW_HEIGHT/6, WINDOW_WIDTH, 'center')
end