local VisualsTab = {}

function VisualsTab.Init(Tab, ESP)
    local LeftTabbox  = Tab:AddLeftTabbox()
    local RightTabbox = Tab:AddRightTabbox()

    local PlayerTab = LeftTabbox:AddTab("Players")
    local MobTab    = LeftTabbox:AddTab("Mobs")
    local ItemTab   = RightTabbox:AddTab("Items")

    PlayerTab:AddToggle("PlayerESP", {
        Text    = "Player ESP",
        Default = false,
    })

    PlayerTab:AddLabel("Box Color"):AddColorPicker("PlayerESPColor", {
        Default = Color3.fromRGB(255, 255, 255),
    })

    PlayerTab:AddToggle("ShowHealth", {
        Text    = "Show Health",
        Default = true,
    })

    PlayerTab:AddToggle("ShowName", {
        Text    = "Show Name",
        Default = true,
    })

    MobTab:AddToggle("MobESP", {
        Text    = "Mob ESP",
        Default = false,
    })

    MobTab:AddLabel("Box Color"):AddColorPicker("MobESPColor", {
        Default = Color3.fromRGB(255, 100, 100),
    })

    MobTab:AddToggle("MobShowHealth", {
        Text    = "Show Health",
        Default = true,
    })

    MobTab:AddToggle("MobShowName", {
        Text    = "Show Name",
        Default = true,
    })

    ItemTab:AddToggle("ItemESP", {
        Text    = "Item ESP",
        Default = false,
    })

    ItemTab:AddLabel("Box Color"):AddColorPicker("ItemESPColor", {
        Default = Color3.fromRGB(255, 200, 0),
    })

    ItemTab:AddToggle("ItemShowName", {
        Text    = "Show Name",
        Default = true,
    })

    local function onESPToggle()
        if Toggles.PlayerESP.Value or Toggles.MobESP.Value or Toggles.ItemESP.Value then
            ESP:Start()
        else
            ESP:Stop()
        end
    end

    Toggles.PlayerESP:OnChanged(onESPToggle)
    Toggles.MobESP:OnChanged(onESPToggle)
    Toggles.ItemESP:OnChanged(onESPToggle)
end

return VisualsTab
