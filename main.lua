require "player"
require "trampoline"

function love.load()
    love.window.setMode(1024, 768)

    local wf = require("lib/windfield/windfield")

    world = wf.newWorld(0, 981)
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('trampoline')
    world:addCollisionClass('player')

    doga = Doga:new(471, 400, 58, 97)
    trampoline = Trampoline:new(400, 500, 200, 20)
end

function love.draw()
    doga:draw()
end

function love.update(dt)
    world:update(dt)
    doga:update(dt)
end

function love.keypressed(key)
    doga:keypressed(key)
end

function love.keyreleased(key)
    doga:keyreleased(key)
end