require "player"
require "trampoline"

function love.load()
    love.window.setMode(1024, 768)

    local wf = require("lib/windfield/windfield")

    world = wf.newWorld(0, 981)
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('trampoline')
    world:addCollisionClass('player')

    player = Doga:new(471, 400, 58, 97)
    -- player = Deniz:new(479, 400, 42, 70)
    trampoline = Trampoline:new(430, 434, 140, 135, 76)

    love.mouse.isVisible = false
end

function love.draw()
    trampoline:drawBack()
    player:draw()
    trampoline:drawFront()

    if debug then
        world:draw()

        local mx, my = love.mouse.getPosition()
        drawCrosshair(mx, my)
    end
end

function love.update(dt)
    world:update(dt)
    player:update(dt)
end

function love.keypressed(key)
    player:keypressed(key)

    if key == '`' then
        debug = not debug
    end
end

function love.keyreleased(key)
    player:keyreleased(key)
end

function drawCoords(x, y)
    love.graphics.setColor(1,0,0,1)
    love.graphics.line(x, y, x + 10, y)
    love.graphics.setColor(0,1,0,1)
    love.graphics.line(x, y, x, y + 10)
    love.graphics.setColor(1,1,1,1)
end

function drawCrosshair(x, y)
    love.graphics.line(0, y, 1024, y)
    love.graphics.line(x, 0, x, 768)
end