Background = {}
Background.__index = Background

local skyShaderCode = love.filesystem.read("shaders/sky.glsl")
local skyShader = love.graphics.newShader(skyShaderCode)
skyShader:send("screen_height", love.graphics.getHeight())
skyShader:send("sky_height", 2*love.graphics.getHeight())

function Background:new()
    local b = setmetatable({}, Background)
    return b
end

function Background:update(cameraPos)
end

function Background:draw()
    love.graphics.setShader(skyShader)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()

    love.graphics.setColor(0.25,0.59,0.04,1)
    love.graphics.rectangle('fill',0, 500, love.graphics.getWidth(), love.graphics.getHeight() - 500)
    love.graphics.setColor(1,1,1,1)
end



