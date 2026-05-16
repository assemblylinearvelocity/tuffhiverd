local VisualsTab = {}

function VisualsTab.Init(Tab)
    local ESPBox   = Tab:AddLeftGroupbox("ESP")
    local ChamsBox = Tab:AddRightGroupbox("Chams")

    ESPBox:AddToggle("PlayerESP", {
        Text    = "Player ESP",
        Default = false,
    })

    ESPBox:AddToggle("ShowHealth", {
        Text    = "Show Health",
        Default = false,
    })

    ESPBox:AddToggle("ShowName", {
        Text    = "Show Name",
        Default = true,
    })

    ChamsBox:AddToggle("PlayerChams", {
        Text    = "Player Chams",
        Default = false,
    })

    ChamsBox:AddLabel("Chams Color"):AddColorPicker("ChamsColor", {
        Default = Color3.fromRGB(255, 100, 100),
    })
end

return VisualsTab
