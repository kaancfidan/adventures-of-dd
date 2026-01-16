Background = {}
Background.__index = Background

local skyShaderCode = love.filesystem.read("shaders/sky.glsl")
local skyShader = love.graphics.newShader(skyShaderCode)
skyShader:send("screen_height", love.graphics.getHeight())
skyShader:send("sky_height", 2*love.graphics.getHeight())

function Background:new()
    local b = setmetatable({}, Background)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    b.groundSprite = love.graphics.newImage("assets/background.png")

    b.scaleX = w / b.groundSprite:getWidth()
    b.scaleY = h / b.groundSprite:getHeight()

    return b
end

function Background:update(cameraPos)
end

function Background:draw()
    love.graphics.setShader(skyShader)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()

    -- love.graphics.setColor(0.223,0.482,0.266,1)
    -- love.graphics.rectangle('fill',0, 500, love.graphics.getWidth(), love.graphics.getHeight() - 500)
    -- love.graphics.setColor(1,1,1,1)

    love.graphics.draw(self.groundSprite, 0, 0, 0, self.scaleX, self.scaleY)
end



