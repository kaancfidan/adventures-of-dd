local peachy = require("lib/peachy/peachy")

Player = {}
Player.__index = Player

function Player:new(x, y, width, height, animations)
    local instance = setmetatable({}, Player)
    instance.width = width
    instance.height = height

    instance.animations = animations
    instance.currAnimation = animations.idle

    instance.collider = world:newRectangleCollider(x, y, width, height, {
        collision_class = "player"
    })
    instance.collider:setFixedRotation(true)

    instance.grounded = false

    return instance
end

function Player:update(dt)
    local colliders = world:queryRectangleArea(self.collider:getX() - self.width / 2,
        self.collider:getY() + self.height / 2, self.width, 2, {'trampoline'})

    if #colliders > 0 then
        self.grounded = true
    else
        self.grounded = false
    end

    local _, dy = self.collider:getLinearVelocity()

    if self.grounded == false and dy < 0 then
        self.currAnimation = self.animations.jump
    end

    if self.grounded and dy == 0 and self.currAnimation == self.animations.jump then
        self.currAnimation = self.animations.idle
    end

    self.currAnimation:update(dt)
end

function Player:draw()
    local px, py = self.collider:getPosition()
    self.currAnimation:draw(px, py)
end

function Player:keypressed(key)
    local _, dy = self.collider:getLinearVelocity()

    if key == "space" and dy >= 0 then
        self.currAnimation = self.animations.crouch
    end
end

function Player:keyreleased(key)
    if key == "space" and self.grounded then
        self.collider:applyLinearImpulse(0, -5000)
    end
end

Doga = setmetatable({}, {__index = Player})
Doga.__index = Doga

function Doga:new(x, y, width, height)
    local sheet = love.graphics.newImage("assets/doga.png")
    local sheetJson = "assets/doga.json"

    local animations = {
        idle = peachy.new(sheetJson, sheet, "idle"),
        crouch = peachy.new(sheetJson, sheet, "crouch"),
        jump = peachy.new(sheetJson, sheet, "jump")
    }

    return Player:new(x, y, width, height, animations)
end
