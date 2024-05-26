local peachy = require("lib/peachy/peachy")
local gamera = require("lib/gamera/gamera")

Player = {}
Player.__index = Player

function Player:new(id, slot)
    local p = setmetatable({}, Player)
    p.id = id
    p.slot = slot

    local sheet = love.graphics.newImage(string.format("assets/%s.png", id))
    local sheetJson = string.format("assets/%s.json", id)

    p.animations = {
        idle = peachy.new(sheetJson, sheet, "idle"),
        crouch = peachy.new(sheetJson, sheet, "crouch"),
        jump = peachy.new(sheetJson, sheet, "jump")
    }

    p.width = p.animations.idle:getWidth()
    p.height = p.animations.idle:getHeight()
    p.density = 12000 / (p.width * p.height)

    p.camera = gamera.new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    return p
end

function Player:init()
    self.currAnimation = self.animations.idle
    self.grounded = false

    if self.collider then
        self.collider:destroy()
    end

    self.collider = world:newRectangleCollider(
        self.slot.x - self.width/2,
        500 - self.height/2,
        self.width, 
        self.height, 
        { collision_class = "player" })

    self.collider.fixture:setDensity(self.density)
    self.collider.body:resetMassData()

    self.collider:setFixedRotation(true)

    if self.trampoline then
        self.trampoline:destroy()
    end

    self.trampoline = Trampoline:new(self.slot.x, 600)
end

function Player:destroy()
    self.collider:destroy()
    self.trampoline:destroy()
end

function Player:isGrounded() 
    local colliders = world:queryRectangleArea(
        self.collider:getX() - self.width / 2,
        self.collider:getY() + self.height / 2, 
        self.width, 2, {'trampoline'})

    return #colliders > 0
end

function Player:update(dt)
    self.trampoline:update(dt)

    self.grounded = self:isGrounded()

    local _, dy = self.collider:getLinearVelocity()

    -- switch animation to jump if airborne
    if self.grounded == false and self.currAnimation == self.animations.idle and dy < 0 then
        self.currAnimation = self.animations.jump
    end

    -- switch animation to idle if idling on the ground
    if self.grounded and dy >= 0 and self.currAnimation ~= self.animations.crouch then
        self.currAnimation = self.animations.idle
    end

    self.currAnimation:update(dt)
end

function Player:draw()
    self.trampoline:drawBack()

    local px, py = self.collider:getPosition()
    self.currAnimation:draw(px - self.slot.dir * self.width / 2, py - self.height / 2, 0, self.slot.dir)

    self.trampoline:drawFront()

    if debug then
        drawCoords(px, py)
    end
end

function Player:keypressed(key)
    if key == self.slot.jumpKey then
        self.currAnimation = self.animations.crouch
    end
end

function Player:keyreleased(key)
    if key == self.slot.jumpKey then        
        if self.grounded and self.currAnimation == self.animations.crouch then
            local _, dy = self.collider:getLinearVelocity()
            self.collider:applyLinearImpulse(0, math.min(-6000, -0.2*dy*dy))
        end

        self.currAnimation = self.animations.idle
    end
end

PlayerSlot = {}
PlayerSlot.__index = PlayerSlot

function PlayerSlot:new(order, jumpKey)
    local s = setmetatable({}, PlayerSlot)
    s.order = order
    s.jumpKey = jumpKey

    -- dummy values to be filled
    s.x = 0
    s.dir = 1

    return s
end

Doga = setmetatable({}, {__index = Player})
Doga.__index = Doga
Doga.id = 'doga'

function Doga:new(slot)
    return Player:new(Doga.id, slot)
end

Deniz = setmetatable({}, {__index = Player})
Deniz.__index = Deniz
Deniz.id = 'deniz'

function Deniz:new(slot)
    return Player:new(Deniz.id, slot)
end
