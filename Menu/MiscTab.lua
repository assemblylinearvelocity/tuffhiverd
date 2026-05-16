local MiscTab = {}

function MiscTab.Init(Tab)
    local GeneralBox = Tab:AddLeftGroupbox("General")

    GeneralBox:AddToggle("AntiAFK", {
        Text    = "Anti AFK",
        Default = false,
        Callback = function(Value) end
    })
end

return MiscTab
