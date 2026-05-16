local SettingsTab = {}

function SettingsTab.Init(Tab, Library, SaveManager, ThemeManager)
    local UIBox = Tab:AddLeftGroupbox("Interface")

    UIBox:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
        Default = "RightControl",
        Mode    = "Toggle",
        Text    = "Menu Keybind",
        Callback = function(Value) end,
        ChangedCallback = function(New)
            Library.ToggleKeybind = Options.MenuKeybind
        end
    })

    UIBox:AddToggle("ShowKeybindList", {
        Text    = "Keybind List",
        Default = false,
        Callback = function(Value)
            Library.KeybindFrame.Visible = Value
        end
    })

    local ThemeBox = Tab:AddRightGroupbox("Theme")
    ThemeManager:ApplyToGroupbox(ThemeBox)

    SaveManager:BuildConfigSection(Tab)
end

return SettingsTab
