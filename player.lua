local Class = require('middleclass')
local Player = Class('Player')

Player.static.sprSeed = love.graphics.newImage('assets/images/seed.png')

function makeRope(world, bodyA, bodyB)
    local function makeSegment(world, x, y, length)
        local seg = {}
        seg.body = love.physics.newBody(world, x, y, 'dynamic')
        seg.shape = love.physics.newCircleShape(length/2)
        seg.fixture = love.physics.newFixture(seg.body, seg.shape, 0.01)
        seg.fixture:setSensor(true)
        return seg
    end
    local segments = {}
    local segLength = 9
    local x, y = bodyA:getX(), bodyA:getY()
    local seg = {}
    for i = 1, 4 do
        seg = makeSegment(world, x, y + (i-1)*segLength, segLength)
        if i == 1 then
            love.physics.newRevoluteJoint(bodyA, seg.body, x, y, false)
        else
            local prevSeg = segments[i-1]
            love.physics.newRevoluteJoint(prevSeg.body, seg.body, prevSeg.body:getX(), prevSeg.body:getY() + segLength/2, false)
            love.physics.newDistanceJoint(prevSeg.body, seg.body, prevSeg.body:getX(), prevSeg.body:getY(), seg.body:getX(), seg.body:getY(), false)
        end
        segments[i] = seg
    end
    seg = segments[#segments]
    x, y = seg.body:getX(), seg.body:getY()
    bodyB:setPosition(x, y)
    love.physics.newRevoluteJoint(bodyB, seg.body, x, y, false)
    return segments
end

function Player:initialize(world)
    self.x, self.y = 160, 320
    self.vx, self.vy = 0.5, 0
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

    self.stem = makeRope(world, self.puff.body, self.seed.body)
end

function Player:update(dt)
    self.puff.body:setX(160)
    if Input:isDown() then
        self.puff.body:applyForce(0, -0.5)
        self.seed.body:applyForce(-0.01, 0)
    end
end

function Player:draw()
    for i = 1, #self.stem do
        local seg = self.stem[i].body
        local segNext = self.seed.body
        if i < #self.stem then
            segNext = self.stem[i+1].body
        end
        love.graphics.line(seg:getX(), seg:getY(), segNext:getX(), segNext:getY())
    end
    love.graphics.draw(Player.sprSeed, self.seed.body:getX()-4, self.seed.body:getY()-4)
    -- love.graphics.circle('fill', self.puff.body:getX(), self.puff.body:getY(), self.puff.shape:getRadius())
    -- love.graphics.circle('fill',  self.seed.body:getY(), self.seed.shape:getRadius())
end

return Player
