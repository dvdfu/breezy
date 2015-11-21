local Level = {}
local Player = require('player')
local Camera = require('camera')

local sprGrass = love.graphics.newImage('assets/grass.png')
local sprGroundTop = love.graphics.newImage('assets/ground-top.png')
local player = {}
local cam = {}
local x = 0

function Level:enter()
    player = Player:new()
    cam = Camera(player.x, player.y)
end

function Level:update(dt)
    x = x - player.vx
    player:update(dt)

    local dx, dy = player.x - cam.x, player.y - cam.y
    cam:move(dx/30, dy/30)
end

function Level:draw()
    cam:draw(function()
        player:draw()
        for i = -1, 3 do
            local gx = x % 80 + i*80
            love.graphics.draw(sprGrass, gx, 320-16)
            love.graphics.draw(sprGroundTop, gx, 320, 0, 1, 10)
        end
    end)
end

return Level
