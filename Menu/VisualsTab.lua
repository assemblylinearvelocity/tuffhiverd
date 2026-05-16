local VisualsTab = {}

function VisualsTab.Init(Page)
    local ESPSection = Page:Section({ Name = "ESP", Side = 1 })

    ESPSection:Toggle({
        Name = "Player ESP",
        Default = false,
        Flag = "PlayerESP",
        Callback = function(Value) end
    })

    ESPSection:Toggle({
        Name = "Show Health",
        Default = false,
        Flag = "ShowHealth",
        Callback = function(Value) end
    })

    ESPSection:Toggle({
        Name = "Show Name",
        Default = true,
        Flag = "ShowName",
        Callback = function(Value) end
    })

    local ChamsSection = Page:Section({ Name = "Chams", Side = 2 })

    ChamsSection:Toggle({
        Name = "Player Chams",
        Default = false,
        Flag = "PlayerChams",
        Callback = function(Value) end
    })

    ChamsSection:Label({ Name = "Chams Color" }):Colorpicker({
        Name = "Chams Color",
        Default = Color3.fromRGB(255, 100, 100),
        Alpha = false,
        Flag = "ChamsColor",
        Callback = function(Value) end
    })
end

return VisualsTab
