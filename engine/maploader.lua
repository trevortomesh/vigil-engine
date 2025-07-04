local MapLoader = {}

function MapLoader.load(path)
    local map = {}
    local playerStart = { x = 1, y = 1 }

    local y = 1
    for line in love.filesystem.lines(path) do
        map[y] = {}
        for x = 1, #line do
            local char = line:sub(x, x)
            map[y][x] = char
            if char == '@' then
                playerStart.x = x
                playerStart.y = y
                map[y][x] = '.' -- Replace with floor
            end
        end
        y = y + 1
    end

    return map, playerStart
end

return MapLoader