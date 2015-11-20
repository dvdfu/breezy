local Class = require('middleclass')
local Player = Class('Player')

Player.static.gravity = 0.01
Player.static.maxSpeed = 2

function Player:initialize()
    self.x, self.y = 160, 160
    self.vy = 0
end

function Player:update(dt)
    if Input:isDown() then
        self.vy = self.vy - Player.gravity
        if self.vy < -Player.maxSpeed then
            self.vy = -Player.maxSpeed
        end
    else
        self.vy = self.vy + Player.gravity
        if self.vy > Player.maxSpeed then
            self.vy = Player.maxSpeed
        end
    end
    self.y = self.y + self.vy

    if self.y + self.vy > 320 then
        self.y = 320
        self.vy = 0
    end
end

function Player:draw()
    love.graphics.circle('fill', self.x, self.y, 16, 16*4)
end

return Player
