return {
    faith = {
        name = "Faith",
        min = 0,
        max = 100,
        on_min = function() print("Faith at zero!") end,
        on_max = function() print("Faith full.") end,
    },
    fear = {
        name = "Fear",
        min = 0,
        max = 100,
        on_max = function() print("Too much fear!") end,
    }
}