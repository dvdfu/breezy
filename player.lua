local Class = require('middleclass')
local Player = Class('Player')

Player.static.sprSeed = love.graphics.newImage('assets/images/seed.png')

function Player:initialize(world, x, y)
    self.ax = 0.05
    self.ground = nil
    self.grounded = false
    self.locked = false
    self.contact = {}

    self.puff = {}
    self.puff.body = love.physics.newBody(world, x, y, 'dynamic')
    self.puff.body:setLinearDamping(1)
    self.puff.shape = love.physics.newCircleShape(6)
    self.puff.fixture = love.physics.newFixture(self.puff.body, self.puff.shape, 0.1)
    self.puff.fixture:setSensor(true)

    self.seed = {}
    self.seed.body = love.physics.newBody(world, x, y, 'dynamic')
    self.seed.shape = love.physics.newCircleShape(1)
    self.seed.fixture = love.physics.newFixture(self.seed.body, self.seed.shape, 0.1)
    self.seed.fixture:setUserData({
        name = 'seed',
        callback = function(other) self:collide(other) end
    })

    self.stem = makeRope(world, self.puff.body, self.seed.body)
end

function Player:update(dt)
    self.puff.body:applyForce(0, -1.8)
    if self.grounded then
        self.seed.body:setPosition(self.contact.x, self.contact.y)
        if not self.locked then
            love.physics.newRevoluteJoint(self.seed.body, self.ground, self.contact.x, self.contact.y, false)
            for _, seg in pairs(self.stem) do
                seg.fixture:setSensor(false)
            end
            -- self.seed.body:setAngle(-math.pi/2)
            -- self.seed.body:setFixedRotation(true)
            self.locked = true
        end
    else
        if Input:isDown() or love.keyboard.isDown(' ') then
            self.puff.body:applyForce(0.4, -0.4)
        end
    end
end

function Player:draw()
    local headAngle, tailAngle = 0, 0
    for i = 1, #self.stem-1 do
        local seg = self.stem[i].body
        local segNext = self.seed.body
        segNext = self.stem[i+1].body
        if i == 1 then
            headAngle = math.atan2(segNext:getY()-seg:getY(), segNext:getX()-seg:getX())
        elseif i == #self.stem-1 then
            love.graphics.setColor(220, 180, 160)
            tailAngle = math.atan2(segNext:getY()-seg:getY(), segNext:getX()-seg:getX())
        end
        love.graphics.line(seg:getX(), seg:getY(), segNext:getX(), segNext:getY())
        love.graphics.setColor(255, 255, 255)
    end
    for i = 0, 6 do
        local a, r = i/12 * 2*math.pi + headAngle + math.pi/2, 5 + math.abs(i-3)
        local x, y = self.puff.body:getX(), self.puff.body:getY()
        love.graphics.line(x, y, x + r*math.cos(a), y + r*math.sin(a))
    end
    love.graphics.draw(Player.sprSeed, self.seed.body:getX(), self.seed.body:getY(), tailAngle, 1, 1, 2, 2)
end

function Player:collide(other)
    local data = other:getUserData()
    if not data or not data.name then return end
    if data.name == 'ground' then
        self.ground = data.body
        self.grounded = true
        self.contact = {
            x = self.seed.body:getX(),
            y = self.seed.body:getY()
        }
    end
end

function Player:getX()
    return self.seed.body:getX()
end

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
    local segLength = 6
    local x, y = bodyA:getX(), bodyA:getY()
    local seg = {}
    for i = 1, 5 do
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

return Player
