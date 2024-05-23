local peachy = require("lib/peachy/peachy")

Trampoline = {}
Trampoline.__index = Trampoline

function Trampoline:new(x, y, width, height, matOffset)
    local t = setmetatable({}, Trampoline)
    t.x = x
    t.y = y
    t.width = width
    t.height = height
    t.matOffset = matOffset

    t.collider = world:newRectangleCollider(x, y + matOffset, width, 20, {
        collision_class = "trampoline"
    })

    t.stopper = world:newRectangleCollider(x, y + matOffset + 80, width, 20, {
        collision_class = "trampoline"
    })

    t.stopper:setType('static')

    t.collider:setFixedRotation(true)

    local sheet = love.graphics.newImage("assets/trampoline.png")
    t.frontSprite = love.graphics.newImage("assets/trampoline_front.png")

    local sheetJson = "assets/trampoline.json"

    t.animations = {
        idle = peachy.new(sheetJson, sheet, "idle"),
        down = peachy.new(sheetJson, sheet, "down"),
        launch = peachy.new(sheetJson, sheet, "launch")
    }

    t.currAnimation = t.animations.idle

    return t
end

function Trampoline:drawBack()
    self.currAnimation:draw(self.x, self.y)

    if debug then
        drawCoords(self.x, self.y)
    end
end

function Trampoline:drawFront()
    love.graphics.draw(self.frontSprite, self.x, self.y + 40, 0, 1, 1)
end

function Trampoline:isPushed() 
    local colliders = world:queryRectangleArea(
        self.collider:getX() - self.width / 2,
        self.collider:getY() - 10, 
        self.width, 2, {'player'})

    return #colliders > 0
end

function Trampoline:update(dt)
    local px, py = self.collider:getPosition()
    local _, dy = self.collider:getLinearVelocity()

    local fspring = -2000*(py-(self.y+self.matOffset))
    local fdamper = -150*math.max(0, dy)

    self.collider:applyForce(0, fspring+fdamper)

    local isPushed = self:isPushed()

    if py > self.y+self.matOffset+20 then
        self.currAnimation = self.animations.down
    elseif py < self.y+self.matOffset and dy < 0 then
        self.currAnimation = self.animations.launch
    else
        self.currAnimation = self.animations.idle
    end

    self.currAnimation:update(dt)
end
