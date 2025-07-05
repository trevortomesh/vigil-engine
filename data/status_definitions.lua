return {
    faith = {
        name = "Faith",
        default = 50,
        min = 0,
        max = 100,
        on_min = function() print("Faith at zero!") end,
        on_max = function() print("Faith full.") end,
    },
    fear = {
        name = "Fear",
        default = 0,
        min = 0,
        max = 100,
        on_max = function() print("Too much fear!") end,
    },
    health = {
        name = "Health",
        default = 100,
        min = 0,
        max = 100,
        on_min = function() print("You have died!") end,
    }
}