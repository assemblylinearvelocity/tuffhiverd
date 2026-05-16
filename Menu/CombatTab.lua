local CombatTab = {}

function CombatTab.Init(Page)
    local ParrySection = Page:Section({ Name = "Parry", Side = 1 })

    ParrySection:Toggle({
        Name = "Auto Parry",
        Default = false,
        Flag = "AutoParry",
        Callback = function(Value) end
    })

    ParrySection:Slider({
        Name = "Parry Window",
        Min = 0,
        Max = 500,
        Decimals = 0,
        Default = 150,
        Suffix = "ms",
        Flag = "ParryWindow",
        Callback = function(Value) end
    })

    ParrySection:Dropdown({
        Name = "Parry Mode",
        Items = { "Auto", "Semi-Auto", "Manual" },
        Default = "Auto",
        Flag = "ParryMode",
        Callback = function(Value) end
    })

    local CombatSection = Page:Section({ Name = "Combat", Side = 2 })

    CombatSection:Toggle({
        Name = "Auto Block",
        Default = false,
        Flag = "AutoBlock",
        Callback = function(Value) end
    })

    CombatSection:Toggle({
        Name = "Hit Prediction",
        Default = false,
        Flag = "HitPrediction",
        Callback = function(Value) end
    })

    CombatSection:Slider({
        Name = "Prediction Amount",
        Min = 0,
        Max = 200,
        Decimals = 0,
        Default = 50,
        Suffix = "ms",
        Flag = "PredictionAmount",
        Callback = function(Value) end
    })
end

return CombatTab
