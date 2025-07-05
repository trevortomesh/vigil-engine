-- game.lua
local debugon = true
local gameState = "playing"  -- can be "playing" or "gameover"
local gameOverMessage = nil
local settings = require("settings")
local gameOverFont = love.graphics.newFont(settings.gameOver.font, settings.gameOver.fontSize or 64)
local floatingTexts = {}
local itemData = require("data.items")
local status = require("engine.status")
local maploader = require("engine.maploader")
local world = require("data.world")

local worldState = {}
local triggeredEvents = {}
local currentMapId = world.start.map
local map = {}
local tileSize = 16
local activeDialog = nil

local player = {
    x = 1,
    y = 1,
    char = '@',
    color = {1, 1, 1},
    inventory = {}
}

local keyBindings = "1234567890fghjklzxcvbnmqertyuiop"

function love.load()
    status.init({
        gameOver = function()
            print("[game] Game over triggered.")
            gameState = "gameover"
        end
    })

    love.graphics.setFont(love.graphics.newFont(settings.floatingText.fontSize or 14))
    loadMap(currentMapId, world.start.position)
end

function loadMap(mapId, spawnPoint)
    if not triggeredEvents[mapId] then
        triggeredEvents[mapId] = {}
    end

    local mapData = world[mapId]
    assert(mapData, "Map not found: " .. tostring(mapId))

    currentMapId = mapId

    if not worldState[mapId] then
        local rawMap, playerStart = maploader.load(mapData.file)
        worldState[mapId] = {
            map = rawMap,
            playerStart = playerStart,
            items = {},
            npcs = {},
        }
    end

    map = worldState[mapId].map

    if spawnPoint then
        player.x = spawnPoint.x
        player.y = spawnPoint.y
    else
        player.x = worldState[mapId].playerStart.x
        player.y = worldState[mapId].playerStart.y
    end
end

function love.draw()
if gameState == "gameover" then
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(gameOverFont)
    love.graphics.printf(settings.gameOver.message or "YOU DIED", 0, love.graphics.getHeight() / 2 - 32, love.graphics.getWidth(), "center")

    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Press [Enter] or [Space] to try again", 0, love.graphics.getHeight() / 2 + 48, love.graphics.getWidth(), "center")
    
    return -- ⛔ prevent drawing the rest of the game
end

    if gameOverMessage then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf(gameOverMessage, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end

    drawMap()
    drawPlayer()
    drawInventory()
    status.draw(10, love.graphics.getHeight() - 80)

    if activeDialog then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 50, 400, 700, 80)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(activeDialog, 60, 420)
    end

    for _, ft in ipairs(floatingTexts) do
        local color = ft.color or settings.floatingText.color or {1, 1, 1}
        love.graphics.setColor(color[1], color[2], color[3], ft.alpha)
        love.graphics.print(ft.text, ft.x * tileSize, ft.y * tileSize)
    end
end

function love.update(dt)
    if gameState ~= "playing" then return end

    for i = #floatingTexts, 1, -1 do
        local ft = floatingTexts[i]

        local speed = settings.floatingText.speed or 12
        local fadeRate = settings.floatingText.fadeRate or 0.35

        ft.y = ft.y - (speed * dt / 10)
        ft.alpha = ft.alpha - (fadeRate * dt)

        if ft.alpha <= 0 then
            table.remove(floatingTexts, i)
        end
    end
end

function drawMap()
    for y = 1, #map do
        for x = 1, #map[y] do
            local char = map[y][x]
            love.graphics.setColor(0.7, 0.7, 0.7)
            love.graphics.print(char, x * tileSize, y * tileSize)
        end
    end
end

function drawPlayer()
    love.graphics.setColor(player.color)
    love.graphics.print(player.char, player.x * tileSize, player.y * tileSize)
end

function drawInventory()
    local startX = 650
    local startY = 10
    local line = 1
    local keyIndex = 1

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Inventory:", startX, startY)

    for itemId, quantity in pairs(player.inventory) do
        if quantity > 0 then
            local item = itemData[itemId]
            local key = keyBindings:sub(keyIndex, keyIndex)
            item.key = key
            love.graphics.print(string.format("[%s] %s x%d", key, item.name, quantity), startX, startY + line * 16)
            keyIndex = keyIndex + 1
            line = line + 1
        else
            itemData[itemId].key = nil
        end
    end
end

function love.keypressed(key)
    if gameState == "gameover" then
        if key == "return" or key == "space" then
            love.event.quit("restart")
        end
        return  -- ⛔ block all other input
    end

    if activeDialog then
        if key == "return" or key == "space" then
            activeDialog = nil
        end
        return
    end

    if key == "up" or key == "w" then movePlayer(0, -1)
    elseif key == "down" or key == "s" then movePlayer(0, 1)
    elseif key == "left" or key == "a" then movePlayer(-1, 0)
    elseif key == "right" or key == "d" then movePlayer(1, 0)
    elseif key == "space" then
        map[player.y][player.x] = '.'
    end

    for id, item in pairs(itemData) do
        if item.key == key and player.inventory[id] and player.inventory[id] > 0 then
            spawnFloatingText("Used " .. item.name, player.x, player.y - 1)
            player.inventory[id] = player.inventory[id] - 1

            if player.inventory[id] <= 0 then
                item.key = nil
            end

            if item.modifiers then
                for statId, amount in pairs(item.modifiers) do
                    status.modify(statId, amount)
                end
            end
        end
    end
end

function movePlayer(dx, dy)
    local newX = player.x + dx
    local newY = player.y + dy

    if debugon then
        status.modify("health", -10)
    end

    local events = world[currentMapId].events or {}
    for i, event in ipairs(events) do
        if event.x == newX and event.y == newY then
            if not event.once or not triggeredEvents[currentMapId][i] then
                if event.type == "dialog" then
                    activeDialog = event.text
                elseif event.type == "floating_text" then
                    spawnFloatingText(event.text or "[no text]", newX, newY, event.color)
                end
                triggeredEvents[currentMapId][i] = true
            end
        end
    end

    local tile = map[newY] and map[newY][newX]
    if not tile or tile == "#" then return end

    for _, exit in ipairs(world[currentMapId].exits or {}) do
        if exit.x == newX and exit.y == newY then
            loadMap(exit.map, exit.spawn)
            return
        end
    end

    player.x = newX
    player.y = newY
    pickupItem(newX, newY)
end

function spawnFloatingText(text, x, y, color)
    table.insert(floatingTexts, {
        text = text,
        x = x,
        y = y,
        alpha = 1,
        lifetime = settings.floatingText.lifetime or 2,
        color = color or settings.floatingText.color or {1, 1, 1}
    })
end

function pickupItem(x, y)
    local tile = map[y][x]
    for id, item in pairs(itemData) do
        if item.symbol == tile then
            player.inventory[id] = (player.inventory[id] or 0) + 1
            map[y][x] = '.'
            print("Picked up:", item.name)
            return
        end
    end
end