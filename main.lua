love.graphics.setDefaultFilter('nearest', 'nearest')
love.graphics.setBackgroundColor(120, 190, 220)

local Player = require('player')
local Camera = require('camera')
Input = require('input')

function love.load()
    sprGrass = love.graphics.newImage('assets/grass.png')
    sprGroundTop = love.graphics.newImage('assets/ground-top.png')
    scaleShader = love.graphics.newShader[[
        extern float scale;
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
            vertex_position.xy *= scale;
            return transform_projection * vertex_position;
        }

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            return Texel(texture, texture_coords);
        }
    ]]
    scaleShader:send('scale', 2)

    canvas = love.graphics.newCanvas(320, 320)
    p = Player:new()
    cam = Camera(p.x, p.y)
end

function love.update(dt)
    p:update(dt)
    Input:update(dt)

    local dcx, dcy = p.x - cam.x, p.y - cam.y
    cam:move(dcx/30, dcy/30)
end

function love.draw()
    canvas:clear()
    love.graphics.setCanvas(canvas)
    love.graphics.push()
    love.graphics.translate(-160, -160)
    cam:draw(function()
        p:draw()
        for i = 0, 3 do
            love.graphics.draw(sprGrass, i*80, 320-16)
            love.graphics.draw(sprGroundTop, i*80, 320, 0, 1, 10)
        end
    end)
    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.setShader(scaleShader)
    love.graphics.draw(canvas)
    love.graphics.setShader()
end
