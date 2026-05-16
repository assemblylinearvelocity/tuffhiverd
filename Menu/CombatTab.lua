local CombatTab = {}

function CombatTab.Init(Tab)
    local ParryBox  = Tab:AddLeftGroupbox("Parry")
    local CombatBox = Tab:AddRightGroupbox("Combat")

    ParryBox:AddToggle("AutoParry", {
        Text    = "Auto Parry",
        Default = false,
        Callback = function(Value) end
    })

    ParryBox:AddSlider("ParryWindow", {
        Text    = "Parry Window",
        Default = 150,
        Min     = 0,
        Max     = 500,
        Suffix  = "ms",
        Callback = function(Value) end
    })

    ParryBox:AddDropdown("ParryMode", {
        Text    = "Parry Mode",
        Values  = { "Auto", "Semi-Auto", "Manual" },
        Default = 1,
        Callback = function(Value) end
    })

    CombatBox:AddToggle("AutoBlock", {
        Text    = "Auto Block",
        Default = false,
        Callback = function(Value) end
    })

    CombatBox:AddToggle("HitPrediction", {
        Text    = "Hit Prediction",
        Default = false,
        Callback = function(Value) end
    })

    CombatBox:AddSlider("PredictionAmount", {
        Text    = "Prediction Amount",
        Default = 50,
        Min     = 0,
        Max     = 200,
        Suffix  = "ms",
        Callback = function(Value) end
    })
end

return CombatTab
