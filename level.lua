local Level = {}
local Player = require('player')
local Camera = require('camera')

local sprGrass = love.graphics.newImage('assets/images/grass.png')
local sprGroundTop = love.graphics.newImage('assets/images/ground-top.png')
local sprGround = love.graphics.newImage('assets/images/ground.png')
local sprCloud = love.graphics.newImage('assets/images/cloud.png')

function Level:enter()
    self.player = Player:new()
    self.cam = Camera(self.player.x, self.player.y)
    self.x = 0
end

function Level:update(dt)
    self.x = self.x - self.player.vx
    self.player:update(dt)

    local dx, dy = self.player.x - self.cam.x, self.player.y - self.cam.y
    self.cam:move(dx/30, dy/30)
end

function Level:draw()
    self.cam:draw(function()
        local cx = self.x % (320+192) - 192
        love.graphics.draw(sprCloud, cx, 160)
        self.player:draw()
        local gx = self.x % 80
        for i = -1, 3 do
            love.graphics.draw(sprGrass, gx + i*80, 320-16)
            love.graphics.draw(sprGroundTop, gx + i*80, 320)
            love.graphics.draw(sprGround, gx + i*80, 320+16, 0, 1, 9)
        end
    end)
end

return Level
