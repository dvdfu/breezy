local Level = {}
local Player = require('player')
local Camera = require('camera')

local sprGrass = love.graphics.newImage('assets/images/grass.png')
local sprGroundTop = love.graphics.newImage('assets/images/ground-top.png')
local sprGround = love.graphics.newImage('assets/images/ground.png')
local sprCloud = love.graphics.newImage('assets/images/cloud.png')

function Level:enter()
    love.physics.setMeter(64) --pixels per meter
    world = love.physics.newWorld(0, 160, true)
    self.ground = {
        body = love.physics.newBody(world, 160, 320 + 1),
        shape = love.physics.newRectangleShape(320, 2)
    }
    self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)


    self.player = Player:new(world)
    self.cam = Camera(self.player.x, self.player.y)
    self.x = 0
end

function Level:update(dt)
    world:update(1/60)
    self.x = self.x - self.player.vx
    self.player:update(dt)

    local dx, dy = self.player.puff.body:getX() - self.cam.x, self.player.puff.body:getY() - self.cam.y
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
        self:drawBodies()
    end)
end

function Level:drawBodies()
    local bodies = world:getBodyList()
    for _, body in pairs(bodies) do
        for _, fixture in pairs(body:getFixtureList()) do
            local shape = fixture:getShape()
            if shape:getType() == 'circle' then
                love.graphics.circle('line', body:getX(), body:getY(), shape:getRadius())
            elseif shape:getType() == 'polygon' then
                love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
            end
        end
    end
end

return Level
