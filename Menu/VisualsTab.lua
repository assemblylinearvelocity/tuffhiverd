local VisualsTab = {}

function VisualsTab.Init(Tab)
    local ESPBox   = Tab:AddLeftGroupbox("ESP")
    local ChamsBox = Tab:AddRightGroupbox("Chams")

    ESPBox:AddToggle("PlayerESP", {
        Text    = "Player ESP",
        Default = false,
        Callback = function(Value) end
    })

    ESPBox:AddToggle("ShowHealth", {
        Text    = "Show Health",
        Default = false,
        Callback = function(Value) end
    })

    ESPBox:AddToggle("ShowName", {
        Text    = "Show Name",
        Default = true,
        Callback = function(Value) end
    })

    ChamsBox:AddToggle("PlayerChams", {
        Text    = "Player Chams",
        Default = false,
        Callback = function(Value) end
    })

    ChamsBox:AddLabel("Chams Color"):AddColorPicker("ChamsColor", {
        Default  = Color3.fromRGB(255, 100, 100),
        Callback = function(Value) end
    })
end

return VisualsTab
