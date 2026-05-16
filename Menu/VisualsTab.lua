local VisualsTab = {}

function VisualsTab.Init(Tab, ESP)
    local ESPBox   = Tab:AddLeftGroupbox("ESP")
    local ChamsBox = Tab:AddRightGroupbox("Chams")

    ESPBox:AddToggle("PlayerESP", {
        Text    = "Player ESP",
        Default = false,
    })

    ESPBox:AddToggle("MobESP", {
        Text    = "Mob ESP",
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

    Toggles.PlayerESP:OnChanged(function(Value)
        if Value or Toggles.MobESP.Value then
            ESP:Start()
        else
            if not Toggles.MobESP.Value then
                ESP:Stop()
            end
        end
    end)

    Toggles.MobESP:OnChanged(function(Value)
        if Value or Toggles.PlayerESP.Value then
            ESP:Start()
        else
            if not Toggles.PlayerESP.Value then
                ESP:Stop()
            end
        end
    end)

    ChamsBox:AddToggle("PlayerChams", {
        Text    = "Player Chams",
        Default = false,
    })

    ChamsBox:AddLabel("Chams Color"):AddColorPicker("ChamsColor", {
        Default = Color3.fromRGB(255, 100, 100),
    })
end

return VisualsTab
