local tileSize = 16
local player = { x = 1, y = 1 }
local rooms = {}
local currentRoom = nil
local activeDialog = nil
local symbols = {}

local function parseVC(filename)
    local path = "CartSlot/" .. filename
    if not love.filesystem.getInfo(path) then
        error("Cart file not found: " .. path)
    end

    local content = love.filesystem.read(path)
    if not content then
        error("Failed to read cart file: " .. path)
    end

    local roomName = nil
    local section = nil
    local cart = {
        rooms = {},
        symbols = {}
    }

    for line in content:gmatch("[^\r\n]+") do
        line = line:match("^%s*(.-)%s*$") -- trim whitespace

        if line:match("^== ROOM") then
            roomName = line:match("^== ROOM%s+(%S+)%s*==")
            cart.rooms[roomName] = {}
            section = "room"
        elseif line:match("^.:%s") then
            -- symbol mapping (e.g., o: DIALOG ...)
            local sym, cmd = line:match("^(%S):%s(.+)")
            if sym and cmd then
                cart.symbols[roomName] = cart.symbols[roomName] or {}
                table.insert(cart.symbols[roomName], { symbol = sym, command = cmd })
            end
        elseif line:match("^@:%s") then
            -- player start
            local _, pos = line:match("^@:%s+(.*)")
            local x, y = line:match("(%d+),(%d+)")
            player.x = tonumber(x)
            player.y = tonumber(y)
        elseif line ~= "" and section == "room" and roomName then
            table.insert(cart.rooms[roomName], line)
        end
    end

    return cart
end

local function loadRoom(roomName, cart)
    currentRoom = roomName
    rooms = cart.rooms
    symbols = cart.symbols
end

function love.load()
    local files = love.filesystem.getDirectoryItems("CartSlot")
    local vcFile = nil
    for _, file in ipairs(files) do
        if file:match("%.vc$") then
            vcFile = file
            break
        end
    end

    if not vcFile then error("No .vc file found in CartSlot") end

    local cart = parseVC(vcFile)

    -- Assume the first room listed is where we start
    local firstRoom = next(cart.rooms)
    loadRoom(firstRoom, cart)
end

function love.draw()
    if not currentRoom then return end

    love.graphics.setColor(1, 1, 1)
    for y, line in ipairs(rooms[currentRoom]) do
        for x = 1, #line do
            local char = line:sub(x, x)
            love.graphics.print(char, x * tileSize, y * tileSize)
        end
    end

    love.graphics.setColor(1, 1, 0)
    love.graphics.print("@", player.x * tileSize, player.y * tileSize)

    -- dialog
    if activeDialog then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 16, 240, 400, 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(activeDialog, 24, 248, 384)
    end
end

local function checkSymbolCollision(x, y)
    local roomLines = rooms[currentRoom]
    if not roomLines then return end

    local line = roomLines[y]
    if not line then return end

    local char = line:sub(x, x)
    local defs = symbols[currentRoom] or {}

    for _, def in ipairs(defs) do
        if def.symbol == char then
            -- Simple support for DIALOG
            if def.command:match("^DIALOG") then
                local dialog = def.command:match('DIALOG%s+"(.-)"')
                if dialog then
                    activeDialog = dialog:gsub("\\n", "\n")
                    return true
                end
            end
        end
    end

    return false
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end

    activeDialog = nil

    local dx, dy = 0, 0
    if key == "w" or key == "up" then dy = -1 end
    if key == "s" or key == "down" then dy = 1 end
    if key == "a" or key == "left" then dx = -1 end
    if key == "d" or key == "right" then dx = 1 end

    local nx = player.x + dx
    local ny = player.y + dy

    -- Check if destination is not a wall
    local row = rooms[currentRoom][ny]
    if row then
        local tile = row:sub(nx, nx)
        if tile ~= "#" then
            player.x = nx
            player.y = ny
            checkSymbolCollision(nx, ny)
        end
    end
end