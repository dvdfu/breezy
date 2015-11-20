local Level = {}
local Player = require('player')
local Camera = require('camera')

local sprGrass = love.graphics.newImage('assets/grass.png')
local sprGroundTop = love.graphics.newImage('assets/ground-top.png')
local player = {}
local cam = {}

function Level:enter()
    player = Player:new()
    cam = Camera(player.x, player.y)
end

function Level:update(dt)
    player:update(dt)

    local dx, dy = player.x - cam.x, player.y - cam.y
    cam:move(dx/30, dy/30)
end

function Level:draw()
    cam:draw(function()
        player:draw()
        for i = 0, 3 do
            love.graphics.draw(sprGrass, i*80, 320-16)
            love.graphics.draw(sprGroundTop, i*80, 320, 0, 1, 10)
        end
    end)
end

return Level
