love.graphics.setDefaultFilter('nearest', 'nearest')
love.graphics.setBackgroundColor(120, 190, 220)

Gamestate = require('gamestate')
Level = require('level')
Input = require('input')

function love.load()
    Gamestate.registerEvents({ 'update' })
    Gamestate.switch(Level)

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

    canvas = love.graphics.newCanvas(320, 200)
end

function love.update(dt)
    Input:update(dt)
end

function love.draw()
    canvas:clear()
    love.graphics.setCanvas(canvas)
    love.graphics.push()
    love.graphics.translate(-160, -100)
    Gamestate.draw()
    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.setShader(scaleShader)
    love.graphics.draw(canvas)
    love.graphics.setShader()
end
