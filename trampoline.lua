
Trampoline = {}
Trampoline.__index = Trampoline

function Trampoline:new(x, y, width, height)
    local instance = setmetatable({}, Trampoline)
    instance.width = width
    instance.height = height

    instance.collider = world:newRectangleCollider(x, y, width, height, {collision_class = "trampoline"})
    instance.collider:setFixedRotation(true)
    instance.collider:setType('static')

    return instance
end