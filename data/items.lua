-- data/items.lua
return {
    relic = {
        name = "Sacred Relic",
        symbol = "!",
        description = "A relic of a saint. Demons fear it.",
        key = "2",
        modifiers = {
            faith = 10
        }
    },

    holy_water = {
        name = "Holy Water",
        symbol = "h",
        description = "Purifies corrupted ground.",
        key = "1",
        modifiers = {
            fear = -10
        }
    },

    salt = {
        name = "Blessed Salt",
        symbol = "s",
        description = "Used for protection.",
        key = "3",
        modifiers = {
            fear = -5,
            faith = 5
        }
    }
}