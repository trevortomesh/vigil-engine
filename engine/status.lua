-- engine/status.lua
local definitions = require("data.status_definitions")
local status = {}

-- Initialize all statuses to their min values
for id, def in pairs(definitions) do
    status[id] = def.min
end

function status.modify(id, amount)
    local def = definitions[id]
    if not def then return end

    status[id] = math.max(def.min, math.min(def.max, (status[id] or def.min) + amount))

    if status[id] == def.max and def.on_max then
        def.on_max()
    elseif status[id] == def.min and def.on_min then
        def.on_min()
    end
end

function status.draw(xOffset)
    local x = xOffset or 10
    local y = 300
    for id, def in pairs(definitions) do
        local value = status[id] or def.min
        local barWidth = 200
        local barHeight = 14
        local fillRatio = (value - def.min) / (def.max - def.min)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(def.name .. ": " .. value, x, y)

        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", x, y + 18, barWidth, barHeight)

        love.graphics.setColor(0.5, 0.8, 1)
        love.graphics.rectangle("fill", x, y + 18, barWidth * fillRatio, barHeight)

        y = y + 40
    end
end

return status