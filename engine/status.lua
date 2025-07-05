-- engine/status.lua
local defs = require("data.status_definitions")
local status = {}
local values = {}
local callbacks = {}

function status.init(opts)
    print("[status] Initializing status values...")
    values = {}
    callbacks = opts or {}

    for id, def in pairs(defs) do
        values[id] = def.default or def.min or 0
        print("[status] " .. id .. " initialized to " .. values[id])
    end
end

function status.modify(stat, amount)
    local def = defs[stat]
    if not def then return end

    values[stat] = math.min(def.max, math.max(def.min, (values[stat] or 0) + amount))
    print("[status] " .. stat .. " modified to " .. values[stat])

    if values[stat] == def.min and def.on_min then
        def.on_min()
        if stat == "health" and callbacks.gameOver then
            callbacks.gameOver()
        end
    end

    if values[stat] == def.max and def.on_max then
        def.on_max()
    end
end

function status.get(stat)
    return values[stat] or 0
end

function status.draw(x, y)
    local sorted = {}
    for id, def in pairs(defs) do table.insert(sorted, id) end
    table.sort(sorted)

    for i, id in ipairs(sorted) do
        local def = defs[id]
        local val = values[id] or 0
        local barWidth = 100
        local pct = (val - def.min) / (def.max - def.min)
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", x, y + (i-1)*20, barWidth, 16)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", x, y + (i-1)*20, barWidth * pct, 16)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(def.name .. ": " .. val, x + barWidth + 10, y + (i-1)*20)
    end
end

return status