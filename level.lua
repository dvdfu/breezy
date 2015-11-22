local Level = {}
local Player = require('player')
local Camera = require('camera')

local sprGrass = love.graphics.newImage('assets/images/grass.png')
local sprGroundTop = love.graphics.newImage('assets/images/ground-top.png')
local sprGround = love.graphics.newImage('assets/images/ground.png')
local sprCloud = love.graphics.newImage('assets/images/cloud.png')

local function beginContact(a, b, coll) end

local function endContact(a, b, coll) end

local function preSolve(a, b, coll) end

local function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
    local dataA, dataB = a:getUserData(), b:getUserData()
    if dataA and dataA.callback then dataA.callback(b) end
    if dataB and dataB.callback then dataB.callback(a) end
end

function Level:enter()
    love.physics.setMeter(64) --pixels per meter
    world = love.physics.newWorld(0, 640, true)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    self.ground = {
        body = love.physics.newBody(world, 160, 320),
        shape = love.physics.newRectangleShape(320, 1)
    }
    self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)
    self.ground.fixture:setUserData({
        name = 'ground',
        body = self.ground.body
    })

    self.x = 0
    self.player = Player:new(world, 0, 160)
    self.cam = Camera(self.player.x, self.player.y)
end

function Level:update(dt)
    world:update(1/60)
    self.player:update(dt)
    self.x = self.player:getX()
    self.ground.body:setX(self.x)

    local dx, dy = self.player.puff.body:getX() - self.cam.x, self.player.puff.body:getY() - self.cam.y
    self.cam:move(dx/10, dy/10)
end

function Level:draw()
    self.cam:draw(function()
        local x = math.floor(self.x/320) * 320
        -- love.graphics.draw(sprCloud, x, 160)
        -- love.graphics.draw(sprCloud, x+640, 160)
        for i = -3, 5 do
            love.graphics.draw(sprGrass, x + i*80, 320-16)
            love.graphics.draw(sprGroundTop, x + i*80, 320)
            love.graphics.draw(sprGround, x + i*80, 320+16, 0, 1, 9)
        end
        self.player:draw()
        -- self:drawBodies()
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
