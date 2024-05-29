require "player"
require "trampoline"
require "background"

local gr = love.graphics

function love.load()
    love.window.setFullscreen(true)
    gr.setDefaultFilter('nearest', 'nearest')

    local wf = require("lib/windfield/windfield")

    world = wf.newWorld(0, 981)

    world:addCollisionClass('trampoline')
    world:addCollisionClass('player')

    playerOptions = {Doga, Deniz, Robin}

    playerSlots = {PlayerSlot:new(3, 'tab'), PlayerSlot:new(2, 'return'), PlayerSlot:new(1, 'space')}

    players = {}

    love.mouse.setVisible(false)
    bg = Background:new()
end

function drawEverything(camX, camY, camW, camH)
    bg:draw()

    for _, p in pairs(players) do
        p:draw()
    end

    if debug then
        world:draw()
    end
end

function love.draw()
    local activeSlots = getActiveSlots()

    if #activeSlots == 0 then
        bg:draw()
    else
        for _, p in pairs(players) do
            p.camera:draw(drawEverything)
        end
    end

    if debug then
        local mx, my = love.mouse.getPosition()
        drawCrosshair(mx, my)
    end
end

function love.update(dt)
    world:update(dt)

    for _, p in pairs(players) do
        p:update(dt)
    end

    world:setQueryDebugDrawing(debug)
end

function love.keypressed(key)
    if key >= '1' and key <= '9' then
        changePlayers(key)
        return
    end

    if key == '`' then
        debug = not debug
        return
    end

    for _, p in pairs(players) do
        p:keypressed(key)
    end
end

function love.keyreleased(key)
    for _, p in pairs(players) do
        p:keyreleased(key)
    end
end

function changePlayers(key)
    local num = tonumber(key)

    if num > #playerOptions then
        return
    end

    local chosen = playerOptions[num]

    if players[chosen.id] ~= nil then
        local player = players[chosen.id]
        table.insert(playerSlots, player.slot)

        -- just so that the first available slot is always the left-most one
        table.sort(playerSlots, function(a, b)
            return a.order > b.order
        end)

        player:destroy()
        players[chosen.id] = nil
    else
        local slot = table.remove(playerSlots)
        local player = playerOptions[num]:new(slot)

        players[player.id] = player
    end

    redistributePlayers()
end

function redistributePlayers()
    local activeSlots = getActiveSlots()

    if #activeSlots == 0 then
        return
    end

    table.sort(activeSlots, function(a, b)
        return a.order > b.order
    end)

    local maxOrder = activeSlots[1].order

    local coords = {}
    local step = gr:getWidth() / (maxOrder + 1)

    for i = 1, maxOrder do
        table.insert(coords, i * step)
    end

    for _, p in pairs(players) do
        p.slot.x = coords[p.slot.order]
        p.slot.dir = (p.slot.order == 1) and 1 or -1
        p:init()
    end
end

function getActiveSlots()
    local activeSlots = {}
    for _, p in pairs(players) do
        table.insert(activeSlots, p.slot)
    end
    return activeSlots
end

function drawCoords(x, y, size)
    size = size or 10

    gr.setColor(1, 0, 0, 1)
    gr.line(x, y, x + size, y)
    gr.setColor(0, 1, 0, 1)
    gr.line(x, y, x, y + size)
    gr.setColor(1, 1, 1, 1)
end

function drawCrosshair(x, y)
    gr.line(0, y, 1024, y)
    gr.line(x, 0, x, 768)
end

function dashLine(p1, p2, dash, gap)
    local dy, dx = p2.y - p1.y, p2.x - p1.x
    local an, st = math.atan2(dy, dx), dash + gap
    local len = math.sqrt(dx * dx + dy * dy)
    local nm = (len - dash) / st
    
    gr.push()
        gr.translate(p1.x, p1.y)
        gr.rotate(an)
        for i = 0, nm do
            gr.line(i * st, 0, i * st + dash, 0)
        end
        gr.line(nm * st, 0, nm * st + dash, 0)
    gr.pop()
end
