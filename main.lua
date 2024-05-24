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

    players = {}
    trampoline = Trampoline:new(360, 434, 280, 270, 152)

    love.mouse.setVisible(false)
end

function love.draw()
    love.graphics.setColor(0.25,0.59,0.04,1)
    love.graphics.rectangle('fill',0, 500, 1024, 300)
    love.graphics.setColor(1,1,1,1)

    trampoline:drawBack()

    for _, p in pairs(players) do
        p:draw(key)
    end

    trampoline:drawFront()

    if debug then
        world:draw()

        local mx, my = love.mouse.getPosition()
        drawCrosshair(mx, my)
    end
end

function love.update(dt)
    world:update(dt)

    for _, p in pairs(players) do
        p:update(dt)
    end

    trampoline:update(dt)
end

function love.keypressed(key)
    if key == '1' then 
        if players.doga ~= nil then
            players.doga:destroy()
            players.doga = nil
        else
            players.doga = Doga:new(471, 400, "space")
        end
    end

    if key == '2' then 
        if players.deniz ~= nil then
            players.deniz:destroy()
            players.deniz = nil
        else
            players.deniz = Deniz:new(550, 400, "return", -1)
        end
    end

    for _, p in pairs(players) do
        p:keypressed(key)
    end

    if key == '`' then
        debug = not debug
    end
end

function love.keyreleased(key)
    for _, p in pairs(players) do
        p:keyreleased(key)
    end
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