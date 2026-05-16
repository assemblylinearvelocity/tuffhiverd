local SettingsTab = {}

function SettingsTab.Init(Tab, Library, SaveManager, ThemeManager)
    local MenuBox = Tab:AddLeftGroupbox("Menu")

    MenuBox:AddButton("Unload", function()
        Library:Unload()
    end)

    MenuBox:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
        Default = "End",
        NoUI    = true,
        Text    = "Menu Keybind",
    })

    Library.ToggleKeybind = Options.MenuKeybind

    MenuBox:AddToggle("ShowKeybindList", {
        Text    = "Keybind List",
        Default = false,
        Callback = function(Value)
            Library.KeybindFrame.Visible = Value
        end
    })

    ThemeManager:ApplyToTab(Tab)
    SaveManager:BuildConfigSection(Tab)
end

return SettingsTab
