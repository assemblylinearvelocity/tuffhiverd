local MiscTab = {}

function MiscTab.Init(Page, Library)
    local GeneralSection = Page:Section({ Name = "General", Side = 1 })

    GeneralSection:Toggle({
        Name = "Anti AFK",
        Default = false,
        Flag = "AntiAFK",
        Callback = function(Value) end
    })

    local ConfigSection = Page:Section({ Name = "Config", Side = 2 })

    ConfigSection:Textbox({
        Name = "Config Name",
        Default = "",
        Placeholder = "Enter config name...",
        Flag = "ConfigName",
        Callback = function(Value) end
    })

    ConfigSection:Button({
        Name = "Save Config",
        Callback = function()
            local Name = Library.Flags["ConfigName"]
            if Name and Name ~= "" then
                Library:SaveConfig(Name)
            end
        end
    })

    ConfigSection:Button({
        Name = "Load Config",
        Callback = function()
            local Name = Library.Flags["ConfigName"]
            if Name and Name ~= "" then
                local Path = Library.Folders.Configs .. "/" .. Name .. ".json"
                if isfile(Path) then
                    Library:LoadConfig(readfile(Path))
                end
            end
        end
    })
end

return MiscTab
