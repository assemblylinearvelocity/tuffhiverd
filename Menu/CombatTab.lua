local CombatTab = {}

function CombatTab.Init(Tab)
    local ParryBox  = Tab:AddLeftGroupbox("Parry")
    local CombatBox = Tab:AddRightGroupbox("Combat")

    ParryBox:AddToggle("AutoParry", {
        Text    = "Auto Parry",
        Default = false,
    })

    ParryBox:AddSlider("ParryWindow", {
        Text     = "Parry Window",
        Default  = 150,
        Min      = 1,
        Max      = 500,
        Rounding = 1,
        Suffix   = "ms",
    })

    ParryBox:AddDropdown("ParryMode", {
        Text    = "Parry Mode",
        Values  = { "Auto", "Semi-Auto", "Manual" },
        Default = 1,
    })

    CombatBox:AddToggle("AutoBlock", {
        Text    = "Auto Block",
        Default = false,
    })

    CombatBox:AddToggle("HitPrediction", {
        Text    = "Hit Prediction",
        Default = false,
    })

    CombatBox:AddSlider("PredictionAmount", {
        Text     = "Prediction Amount",
        Default  = 50,
        Min      = 1,
        Max      = 200,
        Rounding = 1,
        Suffix   = "ms",
    })
end

return CombatTab
