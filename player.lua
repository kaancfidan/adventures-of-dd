local peachy = require("lib/peachy/peachy")

Player = {}
Player.__index = Player

function Player:new(x, y, width, height, density, animations, jumpKey, dir)
    local p = setmetatable({}, Player)
    p.width = width
    p.height = height
    p.dir = dir or 1

    p.jumpKey = jumpKey

    p.animations = animations
    p.currAnimation = animations.idle

    p.collider = world:newRectangleCollider(x, y, width, height, {
        collision_class = "player"
    })

    p.collider.fixture:setDensity(density)
    p.collider.body:resetMassData()

    p.collider:setFixedRotation(true)

    p.grounded = false

    return p
end

function Player:isGrounded() 
    local colliders = world:queryRectangleArea(
        self.collider:getX() - self.width / 2,
        self.collider:getY() + self.height / 2, 
        self.width, 2, {'trampoline'})

    return #colliders > 0
end

function Player:update(dt)
    self.grounded = self:isGrounded()

    local _, dy = self.collider:getLinearVelocity()

    if self.grounded == false and self.currAnimation == self.animations.idle and dy < 0 then
        self.currAnimation = self.animations.jump
    end

    if self.grounded and dy >= 0 and self.currAnimation ~= self.animations.crouch then
        self.currAnimation = self.animations.idle
    end

    self.currAnimation:update(dt)
end

function Player:draw()
    local px, py = self.collider:getPosition()
    self.currAnimation:draw(px - self.dir * self.width / 2, py - self.height / 2, 0, self.dir)

    if debug then
        drawCoords(px, py)
    end
end

function Player:keypressed(key)
    local _, dy = self.collider:getLinearVelocity()

    if key == self.jumpKey then
        self.currAnimation = self.animations.crouch
    end
end

function Player:keyreleased(key)
    if key == self.jumpKey then        
        if self.grounded and self.currAnimation == self.animations.crouch then
            local _, dy = self.collider:getLinearVelocity()
            self.collider:applyLinearImpulse(0, math.min(-5000, 40*dy))
        end

        self.currAnimation = self.animations.idle
    end
end

Doga = setmetatable({}, {__index = Player})
Doga.__index = Doga

function Doga:new(x, y, jumpKey, dir)
    local sheet = love.graphics.newImage("assets/doga.png")
    local sheetJson = "assets/doga.json"

    local animations = {
        idle = peachy.new(sheetJson, sheet, "idle"),
        crouch = peachy.new(sheetJson, sheet, "crouch"),
        jump = peachy.new(sheetJson, sheet, "jump")
    }

    local width, height = 58, 97
    local density = 1

    return Player:new(x - width/2, y - height/2, width, height, density, animations, jumpKey, dir)
end

Deniz = setmetatable({}, {__index = Player})
Deniz.__index = Deniz

function Deniz:new(x, y, jumpKey, dir)
    local sheet = love.graphics.newImage("assets/deniz.png")
    local sheetJson = "assets/deniz.json"

    local animations = {
        idle = peachy.new(sheetJson, sheet, "idle"),
        crouch = peachy.new(sheetJson, sheet, "crouch"),
        jump = peachy.new(sheetJson, sheet, "jump")
    }

    local width, height = 42, 70
    local density = 2.5

    return Player:new(x - width/2, y - height/2, width, height, density, animations, jumpKey, dir)
end
