local peachy = require("lib/peachy/peachy")

Trampoline = {}
Trampoline.__index = Trampoline

function Trampoline:new(x, y, width, height, matOffset)
    local t = setmetatable({}, Trampoline)
    t.x = x
    t.y = y
    t.width = width
    t.height = height

    t.collider = world:newRectangleCollider(x, y + matOffset, width, 20, {
        collision_class = "trampoline"
    })
    t.collider:setType('static')

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
    love.graphics.draw(self.frontSprite, self.x, self.y + 20, 0, 1, 1)
end

function Trampoline:update(dt)
    self.currAnimation:update(dt)
end
