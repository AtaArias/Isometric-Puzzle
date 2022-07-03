TransitionState = Class{__includes = BaseState}

local vel = 0

function TransitionState:enter(params)
    self.firstLvl = params.lvl1
    self.secondLvl = params.lvl2
    self.secondLvl:setOutside()

    self.nextNum = params.nextNum

    self.map1 = self.firstLvl.map
    self.map2 = self.secondLvl.map

    self.finished = false

    self.outing = true
end

function TransitionState:update(dt)
    --Move firstMap tiles below
    if self.outing then
        for y = 0, 4 do
            for x = 0, 4 do
                local thisTile = self.map1[x + y * 5 + 1]
                local drawY = 16 * x + 16 * y + thisTile.z

                thisTile.z = thisTile.z + (WINDOW_HEIGHT - drawY + 200) / 2 / (((x + y) / 5) + 5) * dt * 10
                thisTile.z = math.floor(thisTile.z)
            end
        end
    else 
        --Move second map tiles up
        for y = 0, 4 do
            for x = 0, 4 do
                local thisTile = self.map2[x + y * 5 + 1]

                thisTile.z = thisTile.z - thisTile.z / 2 / (x + y + 1) * dt * 10

                thisTile.z = math.floor(thisTile.z)

                if thisTile.z == 0 then
                    self.finished = true
                else
                    self.finished = false
                end
            end
        end
    end

    if not self.firstLvl:inScreen() and self.outing then
        self.outing = false
    end

    if self.finished then
        gStateMachine:change('play', {level = self.secondLvl.num})
    end
end

function TransitionState:render()
    if self.outing then
        self.firstLvl:render()
    else
        self.secondLvl:render()
    end
end 