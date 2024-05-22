require "player"
require "trampoline"

function love.load()
    love.window.setMode(1024, 768)

    love.graphics.setBackgroundColor(0.53,0.80,0.92,1)

    local wf = require("lib/windfield/windfield")

    world = wf.newWorld(0, 981)
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('trampoline')
    world:addCollisionClass('player')

    player1 = Doga:new(471, 400, "space")
    player2 = Deniz:new(550, 400, "return", -1)
    trampoline = Trampoline:new(360, 434, 280, 270, 152)

    love.mouse.setVisible(false)
end

function love.draw()
    love.graphics.setColor(0.25,0.59,0.04,1)
    love.graphics.rectangle('fill',0, 500, 1024, 300)
    love.graphics.setColor(1,1,1,1)

    trampoline:drawBack()
    player1:draw()
    player2:draw()
    trampoline:drawFront()

    if debug then
        world:draw()

        local mx, my = love.mouse.getPosition()
        drawCrosshair(mx, my)
    end
end

function love.update(dt)
    world:update(dt)
    player1:update(dt)
    player2:update(dt)
    trampoline:update(dt)
end

function love.keypressed(key)
    player1:keypressed(key)
    player2:keypressed(key)

    if key == '`' then
        debug = not debug
    end
end

function love.keyreleased(key)
    player1:keyreleased(key)
    player2:keyreleased(key)
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