local Player = require('player')
local Camera = require('camera')
Input = require('input')

function love.load()
    p = Player:new()
    cam = Camera(p.x, p.y)
end

function love.update(dt)
    p:update(dt)
    Input:update(dt)

    local dcx, dcy = p.x - cam.x, p.y - cam.y
    cam:move(dcx/20, dcy/20)
end

function love.draw()
    cam:draw(function()
        p:draw()
        love.graphics.rectangle('fill', 0, 320, 320, 320)
    end)
    Input:draw()
end
