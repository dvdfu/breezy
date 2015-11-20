local Vector = require('modules/hump/vector')
local Input = {}

local state = {
    pressed = false,
    released = false,
    down = false
}

local pos = {
    pressed = Vector(0, 0),
    released = Vector(0, 0),
    previous = Vector(0, 0)
}

function love.mousepressed(x, y, button)
    if button == 'l' then
        state.pressed = true
        pos.pressed = Vector(love.mouse.getPosition())
    end
end

function love.mousereleased(x, y, button)
    if button == 'l' then
        state.released = true
        pos.released = Vector(love.mouse.getPosition())
    end
end

function Input:isDown()
    return state.down
end

function Input:isPressed()
    return state.pressed
end

function Input:isReleased()
    return state.released
end

function Input:velocity()
    return Vector(love.mouse.getPosition()) - pos.previous
end

function Input:dragged()
    if self:isDown() then
        return Vector(love.mouse.getPosition()) - pos.pressed
    end
    return Vector(0, 0)
end

function Input:pressedPosition()
    return pos.pressed
end

function Input:update()
    state.pressed = false
    state.released = false
    state.down = love.mouse.isDown('l')
    pos.previous = Vector(love.mouse.getPosition())
end

function Input:draw()
    local x, y = love.mouse.getPosition()
    if state.down then
        love.graphics.setColor(255, 64, 64, 64)
        love.graphics.circle('fill', x, y, 12, 36)
    else
        love.graphics.setColor(64, 64, 64, 64)
        love.graphics.circle('fill', x, y, 16, 48)
    end
    love.graphics.circle('fill', x, y, 2, 6)
    love.graphics.setColor(255, 255, 255, 255)
end

return Input
