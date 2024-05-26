local peachy = require("lib/peachy/peachy")

Trampoline = {}
Trampoline.__index = Trampoline

function Trampoline:new(x, y)
    local t = setmetatable({}, Trampoline)
    t.x = x
    t.y = y

    local sheet = love.graphics.newImage("assets/trampoline.png")
    t.frontSprite = love.graphics.newImage("assets/trampoline_front.png")

    local sheetJson = "assets/trampoline.json"

    t.animations = {
        idle = peachy.new(sheetJson, sheet, "idle"),
        down = peachy.new(sheetJson, sheet, "down"),
        launch = peachy.new(sheetJson, sheet, "launch")
    }

    t.width = t.animations.idle:getWidth()
    t.height = t.animations.idle:getHeight()
    t.matOffset = 150

    t.collider = world:newRectangleCollider(x - t.width / 2, y, t.width, 10, {
        collision_class = "trampoline"
    })

    t.stopper = world:newRectangleCollider(x - t.width / 2, y + 80, t.width, 10, {
        collision_class = "trampoline"
    })

    t.stopper:setType('static')

    t.collider:setFixedRotation(true)

    t.currAnimation = t.animations.idle

    return t
end

function Trampoline:destroy()
    self.collider:destroy()
    self.stopper:destroy()
end

function Trampoline:drawBack()
    self.currAnimation:draw(self.x, self.y, 0, 1, 1, self.width / 2, self.matOffset)

    if debug then
        drawCoords(self.x, self.y)
    end
end

function Trampoline:drawFront()
    love.graphics.draw(self.frontSprite, self.x, self.y, 0, 1, 1, self.width / 2, self.matOffset - 40)
end

function Trampoline:update(dt)
    local px, py = self.collider:getPosition()
    local _, dy = self.collider:getLinearVelocity()

    local fspring = -2500*(py-self.y)
    local fdamper = -200*math.max(0, dy)

    self.collider:applyForce(0, fspring+fdamper)

    if py > self.y + 10 then
        self.currAnimation = self.animations.down
    elseif py < self.y - 2 and dy < 0 then
        self.currAnimation = self.animations.launch
    else
        self.currAnimation = self.animations.idle
    end

    self.currAnimation:update(dt)
end
