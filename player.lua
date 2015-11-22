local Class = require('middleclass')
local Player = Class('Player')

Player.static.yAcc = 0.01
Player.static.xAcc = 0.01
Player.static.ySpeedMax = 0.5
Player.static.xSpeedMin = 0.5
Player.static.xSpeedMax = 2
Player.static.sprSeed = love.graphics.newImage('assets/images/seed.png')

function makeRope(world, bodyA, bodyB)
    local function makeSegment(world, x, y, length)
        local seg = {}
        seg.body = love.physics.newBody(world, x, y, 'dynamic')
        seg.body:setFixedRotation(true)
        seg.shape = love.physics.newCircleShape(length/2)
        seg.fixture = love.physics.newFixture(seg.body, seg.shape, 0.01)
        seg.fixture:setSensor(true)
        return seg
    end
    local segLength = 8
    local x, y = bodyA:getX(), bodyA:getY()
    local prevSeg = makeSegment(world, x, y, segLength)
    love.physics.newRevoluteJoint(bodyA, prevSeg.body, x, y, false)
    for i = 1, 7 do
        local seg = makeSegment(world, x, y + i*segLength, segLength)
        love.physics.newRevoluteJoint(prevSeg.body, seg.body, prevSeg.body:getX(), prevSeg.body:getY() + segLength/2, false)
        love.physics.newDistanceJoint(prevSeg.body, seg.body, prevSeg.body:getX(), prevSeg.body:getY(), seg.body:getX(), seg.body:getY(), false)
        prevSeg = seg
    end
    x, y = prevSeg.body:getX(), prevSeg.body:getY()
    bodyB:setPosition(x, y)
    love.physics.newRevoluteJoint(bodyB, prevSeg.body, x, y, false)
end

function Player:initialize(world)
    self.x, self.y = 160, 320
    self.vx, self.vy = 0.3, 0
    self.grounded = false

    self.puff = {}
    self.puff.body = love.physics.newBody(world, 160, 160, 'dynamic')
    self.puff.shape = love.physics.newCircleShape(12)
    self.puff.fixture = love.physics.newFixture(self.puff.body, self.puff.shape, 0.1)
    self.puff.fixture:setSensor(true)

    self.seed = {}
    self.seed.body = love.physics.newBody(world, 160, 160, 'dynamic')
    self.seed.shape = love.physics.newCircleShape(4)
    self.seed.fixture = love.physics.newFixture(self.seed.body, self.seed.shape, 0.1)

    makeRope(world, self.puff.body, self.seed.body)
end

function Player:update(dt)
    self.puff.body:setX(160)
    if Input:isDown() then
        self.puff.body:applyForce(0, -5)
        self.seed.body:applyForce(-0.1, 0)
    end
end

function Player:draw()
    love.graphics.draw(Player.sprSeed, self.seed.body:getX()-4, self.seed.body:getY()-4)
    -- love.graphics.circle('fill', self.puff.body:getX(), self.puff.body:getY(), self.puff.shape:getRadius())
    -- love.graphics.circle('fill',  self.seed.body:getY(), self.seed.shape:getRadius())
end

return Player
