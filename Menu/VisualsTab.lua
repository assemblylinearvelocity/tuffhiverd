local VisualsTab = {}

function VisualsTab.Init(Tab, ESP)
    local ESPBox = Tab:AddLeftGroupbox("ESP")

    ESPBox:AddToggle("PlayerESP", {
        Text    = "Player ESP",
        Default = false,
    })

    ESPBox:AddLabel("Player Color"):AddColorPicker("PlayerESPColor", {
        Default = Color3.fromRGB(255, 255, 255),
    })

    ESPBox:AddToggle("MobESP", {
        Text    = "Mob ESP",
        Default = false,
    })

    ESPBox:AddLabel("Mob Color"):AddColorPicker("MobESPColor", {
        Default = Color3.fromRGB(255, 100, 100),
    })

    ESPBox:AddToggle("ShowHealth", {
        Text    = "Show Health",
        Default = true,
    })

    ESPBox:AddToggle("ShowName", {
        Text    = "Show Name",
        Default = true,
    })

    Toggles.PlayerESP:OnChanged(function()
        if Toggles.PlayerESP.Value or Toggles.MobESP.Value then
            ESP:Start()
        else
            ESP:Stop()
        end
    end)

    Toggles.MobESP:OnChanged(function()
        if Toggles.PlayerESP.Value or Toggles.MobESP.Value then
            ESP:Start()
        else
            ESP:Stop()
        end
    end)
end

return VisualsTab
