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
        seg.body = love.physics.newBody(world, x, y + length/2, 'dynamic')
        seg.shape = love.physics.newRectangleShape(1, length)
        seg.fixture = love.physics.newFixture(seg.body, seg.shape, 1)
        return seg
    end
    local segLength = 2
    local x, y = bodyA:getX(), bodyA:getY()+12
    local prevSeg = makeSegment(world, x, y, segLength)
    love.physics.newRevoluteJoint(bodyA, prevSeg.body, x, y, false)
    for i = 1, 16 do
        local seg = makeSegment(world, x, y + i*segLength, segLength)
        local joint = love.physics.newRevoluteJoint(prevSeg.body, seg.body, prevSeg.body:getX(), prevSeg.body:getY() + segLength/2, false)
        joint:setLimitsEnabled()
        joint:setLimits(-1/180*math.pi, 1/180*math.pi)
        love.physics.newRopeJoint(prevSeg.body, seg.body, prevSeg.body:getX(), prevSeg.body:getY(), seg.body:getX(), seg.body:getY(), segLength, false)
        prevSeg = seg
    end
    x, y = prevSeg.body:getX(), prevSeg.body:getY() + segLength/2
    bodyB:setPosition(x, y)
    love.physics.newRevoluteJoint(bodyB, prevSeg.body, x, y, false)
end

function Player:initialize(world)
    self.x, self.y = 160, 320
    self.vx, self.vy = 0.3, 0
    self.grounded = false

    self.puff = {}
    self.puff.body = love.physics.newBody(world, 160, 160, 'dynamic')
    self.puff.body:setFixedRotation()
    self.puff.shape = love.physics.newCircleShape(12)
    self.puff.fixture = love.physics.newFixture(self.puff.body, self.puff.shape, 0.1)
    self.puff.fixture:setRestitution(0.6)

    self.seed = {}
    self.seed.body = love.physics.newBody(world, 160, 160+32, 'dynamic')
    self.seed.shape = love.physics.newCircleShape(4)
    self.seed.fixture = love.physics.newFixture(self.seed.body, self.seed.shape, 0.1)

    makeRope(world, self.puff.body, self.seed.body)
end

function Player:update(dt)
    self.puff.body:setX(160)
    if Input:isDown() and self.y > 160 then
        self.puff.body:applyForce(0, -10)
        self.seed.body:applyForce(-0.05, 0)
        if self.vx < Player.xSpeedMax then
            self.vx = self.vx + Player.xAcc
        else
            self.vx = Player.xSpeedMax
        end
        self.vy = self.vy - Player.yAcc
        if self.vy < -Player.ySpeedMax then
            self.vy = -Player.ySpeedMax
        end
    else
        if self.vx > Player.xSpeedMin then
            self.vx = self.vx - Player.xAcc
        else
            self.vx = Player.xSpeedMin
        end
        self.vy = self.vy + Player.yAcc
        if self.vy > Player.ySpeedMax then
            self.vy = Player.ySpeedMax
        end
    end
    self.y = self.y + self.vy

    if self.y + self.vy > 320 then
        self.grounded = true
        self.y = 320
        self.vy = 0
        self.vx = 0
    end
end

function Player:draw()
    love.graphics.draw(Player.sprSeed, self.x-4, self.y-4)
    -- love.graphics.circle('fill', self.puff.body:getX(), self.puff.body:getY(), self.puff.shape:getRadius())
    -- love.graphics.circle('fill', self.seed.body:getX(), self.seed.body:getY(), self.seed.shape:getRadius())
end

return Player
