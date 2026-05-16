local GITHUB_BASE = "https://raw.githubusercontent.com/assemblylinearvelocity/tuffhiverd/main/"

local function loadModule(path)
    local success, result = pcall(function()
        return game:HttpGet(GITHUB_BASE .. path .. "?v=" .. os.time())
    end)
    if not success then
        warn("[tuffhiverd] Failed to fetch:", path, "|", result)
        return nil
    end
    local loadSuccess, module = pcall(function()
        return loadstring(result)()
    end)
    if not loadSuccess then
        warn("[tuffhiverd] Failed to execute:", path, "|", module)
        return nil
    end
    return module
end

if shared.tuffhiverd then
    if shared.tuffhiverd.detach then
        shared.tuffhiverd.detach()
    end
end

task.spawn(function()
    local Library = loadModule("GUI/library.lua")
    if not Library then return warn("Failed to load Library") end

    local SaveManager = loadModule("GUI/SaveManager.lua")
    if not SaveManager then return warn("Failed to load SaveManager") end

    local ThemeManager = loadModule("GUI/ThemeManager.lua")
    if not ThemeManager then return warn("Failed to load ThemeManager") end

    local CombatTab = loadModule("Menu/CombatTab.lua")
    if not CombatTab then return warn("Failed to load CombatTab") end

    local VisualsTab = loadModule("Menu/VisualsTab.lua")
    if not VisualsTab then return warn("Failed to load VisualsTab") end

    local MiscTab = loadModule("Menu/MiscTab.lua")
    if not MiscTab then return warn("Failed to load MiscTab") end

    local SettingsTab = loadModule("Menu/SettingsTab.lua")
    if not SettingsTab then return warn("Failed to load SettingsTab") end

    local tuffhiverd = {}

    function tuffhiverd.init()
        local Window = Library:CreateWindow({
            Title = "tuffhiverd",
            AutoShow = true,
        })

        local Tabs = {
            Combat   = Window:AddTab("Combat"),
            Visuals  = Window:AddTab("Visuals"),
            Misc     = Window:AddTab("Misc"),
            Settings = Window:AddTab("Settings"),
        }

        CombatTab.Init(Tabs.Combat)
        VisualsTab.Init(Tabs.Visuals)
        MiscTab.Init(Tabs.Misc)
        SettingsTab.Init(Tabs.Settings, Library, SaveManager, ThemeManager)

        SaveManager:SetLibrary(Library)
        ThemeManager:SetLibrary(Library)
        SaveManager:SetFolder("tuffhiverd")
        ThemeManager:SetFolder("tuffhiverd")
        SaveManager:LoadAutoloadConfig()
    end

    function tuffhiverd.detach()
        if Library then
            Library:Unload()
        end
    end

    shared.tuffhiverd = tuffhiverd

    local ok, err = xpcall(tuffhiverd.init, function(e)
        warn("Init failed:", e, debug.traceback())
        tuffhiverd.detach()
    end)

    if not ok then
        warn("Initialization failed:", err)
    end
end)
