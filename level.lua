local Level = {}
local Player = require('player')
local Camera = require('camera')
local RGBColor = require('RGBcolor')

local sprGrass = love.graphics.newImage('assets/images/grass.png')
local sprGroundTop = love.graphics.newImage('assets/images/ground-top.png')
local sprGround = love.graphics.newImage('assets/images/ground.png')
local sprCloud = love.graphics.newImage('assets/images/cloud.png')
local sprSky = love.graphics.newImage('assets/images/sky.png')
local sprStars = love.graphics.newImage('assets/images/stars.png')

local numPhases = 6
local phases = {
    [0] = {
        bg = RGBColor.new(0, 0, 0),
        mfg = RGBColor.new(80, 120, 200),
        afg = RGBColor.new(0, 0, 0)
    },
    [1] = {
        bg = RGBColor.new(0, 0, 0),
        mfg = RGBColor.new(80, 120, 200),
        afg = RGBColor.new(0, 0, 0)
    },
    [2] = {
        bg = RGBColor.new(170, 150, 40),
        mfg = RGBColor.new(255, 255, 255),
        afg = RGBColor.new(40, 20, 10)
    },
    [3] = {
        bg = RGBColor.new(170, 230, 255),
        mfg = RGBColor.new(255, 255, 255),
        afg = RGBColor.new(0, 0, 0)
    },
    [4] = {
        bg = RGBColor.new(170, 230, 255),
        mfg = RGBColor.new(255, 255, 255),
        afg = RGBColor.new(0, 0, 0)
    },
    [5] = {
        bg = RGBColor.new(100, 40, 110),
        mfg = RGBColor.new(255, 255, 255),
        afg = RGBColor.new(40, 10, 20)
    }
}

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
    self.time = 0
end

function Level:update(dt)
    world:update(dt)
    self.player:update(dt)
    if not self.player.grounded then
        self.x = self.player:getX()
        self.ground.body:setX(self.x)
    end

    local dx, dy = self.player.puff.body:getX() - self.cam.x, self.player.puff.body:getY() - self.cam.y
    self.cam:move(dx/10, dy/10)

    self.time = self.time + dt
end

function Level:getColors(phase, progress)
    local color = phases[phase]
    local nextColor = phases[(phase + 1) % numPhases]
    return {
        bg = RGBColor.blend(color.bg, nextColor.bg, progress),
        mfg = RGBColor.blend(color.mfg, nextColor.mfg, progress),
        afg = RGBColor.blend(color.afg, nextColor.afg, progress)
    }
end

function Level:draw()
    local hour = self.time % 24
    local phase = math.floor(numPhases * hour/24)
    local progress = (numPhases * hour/24) % 1
    local skyColor = self:getColors(phase, progress)

    love.graphics.setColor(RGBColor.get(skyColor.bg))
    love.graphics.draw(sprSky, 0, 0, 0, 640/32, 400/32)
    love.graphics.setColor(255, 255, 255)

    if phase == 0 then
        love.graphics.draw(sprStars, 160, 100)
    elseif phase == 1 then
        love.graphics.setColor(255, 255, 255, 255*math.max(0, 1 - progress*2))
        love.graphics.draw(sprStars, 160, 100)
    elseif phase == 5 then
        love.graphics.setColor(255, 255, 255, 255*math.min(1, progress*2))
        love.graphics.draw(sprStars, 160, 100)
    end
    love.graphics.setColor(255, 255, 255, 255)

    self.cam:draw(function()
        local x = math.floor(self.x/640) * 640
        love.graphics.draw(sprCloud, x, 160)
        love.graphics.draw(sprCloud, x+640, 160)

        x = math.floor(self.x/320) * 320
        for i = -3, 5 do
            love.graphics.draw(sprGrass, x + i*80, 320-16)
            love.graphics.draw(sprGroundTop, x + i*80, 320)
            love.graphics.draw(sprGround, x + i*80, 320+16, 0, 1, 9)
        end
        self.player:draw()
        -- self:drawBodies()
    end)

    love.graphics.setBlendMode('multiplicative')
    love.graphics.setColor(RGBColor.get(skyColor.mfg))
    love.graphics.draw(sprSky, 0, 0, 0, 640/32, 400/32)
    love.graphics.setBlendMode('additive')
    love.graphics.setColor(RGBColor.get(skyColor.afg))
    love.graphics.draw(sprSky, 0, 0, 0, 640/32, 400/32)
    love.graphics.setBlendMode('alpha')
    love.graphics.setColor(255, 255, 255)
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
