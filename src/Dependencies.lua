-- TODO: Add all the credits here: 
-- music credits
--[[
  Wholesome mp3: https://incompetech.com/music/royalty-free/music.html  
]]
-- sound effects credits
--[[
    sfxr: http://drpetter.se/project_sfxr.html
    other sounds: https://github.com/inexorgame/audioaugust
]]
-- assets credits
--[[
    The devil workshop isometric tiles: https://devilsworkshop.itch.io/isometric-tiles-pixel-art
]]
-- fonts credits


--GLOBALS
PARTICLE = love.graphics.newImage('assets/particle.png')

math.randomseed(os.time()) -- add randomness

WINDOW_WIDTH, WINDOW_HEIGHT = 426, 240


gTiles = { 
    ['grass'] = love.graphics.newImage('assets/blocks_73.png'),
    ['tile'] = love.graphics.newImage("assets/blocks_74.png"), -- 29
    ['badTile'] = love.graphics.newImage("assets/blocks_95.png"), -- 30
    ['player'] = love.graphics.newImage("assets/blocks_99.png")
    --['player'] = love.graphics.newImage('player.png')
}

gMaps = {
    {0,0,0,0,2,
    0,0,0,0,1,
    0,0,1,1,1,
    0,0,0,0,0,
    0,0,0,0,0
    },
    {2,1,1,0,2,
    0,0,0,0,1,
    0,0,1,1,1,
    0,0,0,0,0,
    0,0,0,0,0
    },
    {2,1,2,0,2,
    0,0,0,0,1,
    1,0,1,1,1,
    0,0,0,0,0,
    2,0,0,0,0   
    },
    {2,1,1,1,2,
    0,0,1,0,0,
    1,0,1,0,1,
    1,0,1,0,0,
    2,1,1,1,2
    },
    {0,0,0,0,0,
     0,0,2,0,0,
     0,2,1,2,0,
     0,0,2,0,0,
     0,0,0,0,0
    },
    {2,1,2,1,2,
     1,0,1,0,1,
     1,1,1,1,2,
     1,0,1,0,1,
     2,1,2,1,2
    },
    {2,1,2,1,2,
     0,0,0,0,1,
     1,1,1,1,2,
     0,0,1,0,1,
     2,1,2,1,2
    },
    {1,1,1,1,1,
     2,0,1,0,2,
     0,0,1,0,0,
     1,0,1,0,2,
     1,1,1,1,1
    }
}

local font = 'fonts/Teko-Bold.ttf'

gFonts = {
    ['small'] = love.graphics.newFont(font, 20),
    ['medium'] = love.graphics.newFont(font, 40),
    ['big'] = love.graphics.newFont(font, 60)
}

gSounds = {
    ['light'] = love.audio.newSource('sounds/pickUp.wav', 'static'),
    ['jump'] = love.audio.newSource('sounds/impacts_wooden_wooden_impact_1.ogg', 'static'),
    ['music'] = love.audio.newSource('sounds/Wholesome.mp3', 'stream'),
    ['button'] = love.audio.newSource('sounds/buttons_button_1.ogg', 'static')
}

gSounds['music']:setLooping(true)

gGrassTiles = {}

for i = 73, 92 do
    table.insert(gGrassTiles, love.graphics.newImage('assets/blocks_' .. tostring(i) .. '.png'))
end

BACKGROUND = {}

-- MORE LIKE UTILS
function drawBackground()
    love.graphics.translate(WINDOW_WIDTH / 2, -WINDOW_HEIGHT / 2)

    for y = 0, 15 do
        for x = 0, 12 do
            local texture = BACKGROUND[x + y * 10 + 1]

            local drawX = 32 * x - 32 * y
            local drawY = 16 * x + 16 * y
            
            love.graphics.draw(texture, drawX, drawY)
        end
    end

    love.graphics.origin()
end

for y = 0, 15 do
    for x = 0, 12 do
        local texture = gGrassTiles[math.random(#gGrassTiles)]

        table.insert(BACKGROUND, texture)
    end
end


push = require 'lib/push'

Class = require 'lib/class'

require 'src/StateMachine'

-- game states
require 'src/states/BaseState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/LevelSelectState'
require 'src/states/StartState'
require 'src/states/OptionSelectState'
require 'src/states/TransitionState'
require 'src/states/WinState'
--[[ I neead a start state -> play state(1) -> lost state -> start or play
                           -> level select -> play state(level)
]]



require 'src/Level'