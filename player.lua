local Class = require('middleclass')
local Player = Class('Player')

Player.static.yAcc = 0.01
Player.static.xAcc = 0.01
Player.static.ySpeedMax = 0.5
Player.static.xSpeedMin = 0.5
Player.static.xSpeedMax = 2
Player.static.sprSeed = love.graphics.newImage('assets/seed.png')

function Player:initialize()
    self.x, self.y = 160, 160
    self.vx, self.vy = 0.3, 0
    self.grounded = false
end

function Player:update(dt)
    if Input:isDown() and self.y > 0 then
        if self.vx < Player.xSpeedMax then
            self.vx = self.vx + Player.xAcc
        else
            self.vx = Player.xSpeedMax
        end
        self.vy = self.vy - Player.yAcc
        if self.vy < -Player.ySpeedMax then
            self.vy = -Player.ySpeedMax
        end
    else
        if self.vx > Player.xSpeedMin then
            self.vx = self.vx - Player.xAcc
        else
            self.vx = Player.xSpeedMin
        end
        self.vy = self.vy + Player.yAcc
        if self.vy > Player.ySpeedMax then
            self.vy = Player.ySpeedMax
        end
    end
    self.y = self.y + self.vy

    if self.y + self.vy > 320 then
        self.grounded = true
        self.y = 320
        self.vy = 0
        self.vx = 0
    end
end

function Player:draw()
    love.graphics.draw(Player.sprSeed, self.x-4, self.y-4)
end

return Player
