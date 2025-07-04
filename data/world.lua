-- data/world.lua
return {
    church1 = {
        file = "maps/church1.txt",
        exits = {
            { x = 31, y = 3, map = "rectory", spawn = { x = 2, y = 3 } }
        },
        events = {
            {
                type = "dialog",
                x = 10, y = 5,
                text = "The silence here feels... wrong.",
                once = true
            },
            {
                type = "floating_text",
                x = 12, y = 7,
                text = "The wind whispers through the rafters.",
                color = {0.8, 0.8, 1.0}, -- light blue-ish
                once = false
            }
        }
    },
    rectory = {
        file = "maps/rectory.txt",
        exits = {
            { x = 2, y = 3, map = "church1", spawn = { x = 31, y = 3 } }
        },
        events = {
            {
                type = "dialog",
                x = 4, y = 4,
                text = "A chill runs down your spine.",
                once = true
            }
        }
    }
}