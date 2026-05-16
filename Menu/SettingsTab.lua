local SettingsTab = {}

local Themes = {
    Default = {
        ["Background"]      = Color3.fromRGB(15, 15, 20),
        ["Inline"]          = Color3.fromRGB(20, 20, 25),
        ["Page Background"] = Color3.fromRGB(30, 30, 35),
        ["Border"]          = Color3.fromRGB(10, 10, 10),
        ["Outline"]         = Color3.fromRGB(27, 27, 32),
        ["Accent"]          = Color3.fromRGB(235, 157, 255),
        ["Element"]         = Color3.fromRGB(33, 33, 36),
        ["Hovered Element"] = Color3.fromRGB(40, 40, 43),
        ["Text"]            = Color3.fromRGB(215, 215, 215),
        ["Text Border"]     = Color3.fromRGB(0, 0, 0),
    },
    Midnight = {
        ["Background"]      = Color3.fromRGB(10, 10, 18),
        ["Inline"]          = Color3.fromRGB(15, 15, 25),
        ["Page Background"] = Color3.fromRGB(20, 20, 35),
        ["Border"]          = Color3.fromRGB(8, 8, 15),
        ["Outline"]         = Color3.fromRGB(20, 20, 30),
        ["Accent"]          = Color3.fromRGB(100, 180, 255),
        ["Element"]         = Color3.fromRGB(25, 25, 40),
        ["Hovered Element"] = Color3.fromRGB(35, 35, 55),
        ["Text"]            = Color3.fromRGB(200, 210, 255),
        ["Text Border"]     = Color3.fromRGB(0, 0, 0),
    },
    Rose = {
        ["Background"]      = Color3.fromRGB(20, 12, 15),
        ["Inline"]          = Color3.fromRGB(28, 18, 22),
        ["Page Background"] = Color3.fromRGB(38, 25, 30),
        ["Border"]          = Color3.fromRGB(10, 6, 8),
        ["Outline"]         = Color3.fromRGB(30, 20, 25),
        ["Accent"]          = Color3.fromRGB(255, 100, 140),
        ["Element"]         = Color3.fromRGB(40, 28, 33),
        ["Hovered Element"] = Color3.fromRGB(52, 36, 43),
        ["Text"]            = Color3.fromRGB(255, 210, 220),
        ["Text Border"]     = Color3.fromRGB(0, 0, 0),
    },
}

local function applyTheme(Library, name)
    local theme = Themes[name]
    if not theme then return end
    for key, color in theme do
        Library:ChangeTheme(key, color)
    end
end

function SettingsTab.Init(Page, Library, Watermark, KeybindList)
    local UISection = Page:Section({ Name = "Interface", Side = 1 })

    UISection:Label({ Name = "Menu Keybind" }):Keybind({
        Name = "Menu Keybind",
        Mode = "Toggle",
        Default = Enum.KeyCode.Z,
        Flag = "MenuKeybind",
        Callback = function()
            local flag = Library.Flags["MenuKeybind"]
            if flag and flag.Key then
                Library.MenuKeybind = "Enum.KeyCode." .. tostring(flag.Key)
            end
        end
    })

    UISection:Toggle({
        Name = "Watermark",
        Default = true,
        Flag = "ShowWatermark",
        Callback = function(Value)
            Watermark:SetVisibility(Value)
        end
    })

    UISection:Toggle({
        Name = "Keybind List",
        Default = false,
        Flag = "ShowKeybindList",
        Callback = function(Value)
            KeybindList:SetVisibility(Value)
        end
    })

    local ThemeSection = Page:Section({ Name = "Theme", Side = 2 })

    ThemeSection:Dropdown({
        Name = "Theme",
        Items = { "Default", "Midnight", "Rose" },
        Default = "Default",
        Flag = "Theme",
        Callback = function(Value)
            applyTheme(Library, Value)
        end
    })

    ThemeSection:Label({ Name = "Accent Color" }):Colorpicker({
        Name = "Accent Color",
        Default = Color3.fromRGB(235, 157, 255),
        Alpha = false,
        Flag = "AccentColor",
        Callback = function(Value)
            Library:ChangeTheme("Accent", Value)
        end
    })
end

return SettingsTab
