local screenWidth = 800
local screenHeight = 600

local basket = {
    x = screenWidth / 2,
    y = screenHeight - 50,
    width = 80,
    height = 20,
    speed = 400
}

local objects = {}
local objectSpawnTime = 0.5
local timeSinceLastObject = 0
local objectSpeed = 200

local score = 0

function love.load()
    love.window.setMode(screenWidth, screenHeight)
    love.window.setTitle("Catch the Falling Objects")
end

function love.update(dt)
    if love.keyboard.isDown("left") then
        basket.x = basket.x - basket.speed * dt
    elseif love.keyboard.isDown("right") then
        basket.x = basket.x + basket.speed * dt
    end

    if basket.x < 0 then
        basket.x = 0
    elseif basket.x + basket.width > screenWidth then
        basket.x = screenWidth - basket.width
    end

    timeSinceLastObject = timeSinceLastObject + dt
    if timeSinceLastObject >= objectSpawnTime then
        timeSinceLastObject = 0
        table.insert(objects, {x = math.random(0, screenWidth), y = 0, width = 20, height = 20})
    end

    for i = #objects, 1, -1 do
        local obj = objects[i]
        obj.y = obj.y + objectSpeed * dt

        if obj.x < basket.x + basket.width and
           obj.x + obj.width > basket.x and
           obj.y < basket.y + basket.height and
           obj.y + obj.height > basket.y then
            score = score + 1
            table.remove(objects, i)
        elseif obj.y > screenHeight then
            table.remove(objects, i)
        end
    end
end

function love.draw()
    love.graphics.rectangle("fill", basket.x, basket.y, basket.width, basket.height)

    for _, obj in ipairs(objects) do
        love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height)
    end

    love.graphics.print("Score: " .. score, 10, 10)
end
