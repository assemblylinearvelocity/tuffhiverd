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
    pcall(function()
        if shared.tuffhiverd.detach then
            shared.tuffhiverd.detach()
        end
    end)
end

task.spawn(function()
    local Library     = loadModule("GUI/library.lua")
    if not Library     then return warn("Failed to load Library") end

    local ThemeManager = loadModule("GUI/ThemeManager.lua")
    if not ThemeManager then return warn("Failed to load ThemeManager") end

    local SaveManager  = loadModule("GUI/SaveManager.lua")
    if not SaveManager  then return warn("Failed to load SaveManager") end

    local CombatTab   = loadModule("Menu/CombatTab.lua")
    if not CombatTab   then return warn("Failed to load CombatTab") end

    local VisualsTab  = loadModule("Menu/VisualsTab.lua")
    if not VisualsTab  then return warn("Failed to load VisualsTab") end

    local PlayerRenderer = loadModule("Game/Visuals/PlayerRenderer.lua")
    if not PlayerRenderer then return warn("Failed to load PlayerRenderer") end

    local MobRenderer    = loadModule("Game/Visuals/MobRenderer.lua")
    if not MobRenderer    then return warn("Failed to load MobRenderer") end

    local ItemRenderer   = loadModule("Game/Visuals/ItemRenderer.lua")
    if not ItemRenderer   then return warn("Failed to load ItemRenderer") end

    local ESP            = loadModule("Game/Visuals/ESP.lua")
    if not ESP            then return warn("Failed to load ESP") end

    local MiscTab     = loadModule("Menu/MiscTab.lua")
    if not MiscTab     then return warn("Failed to load MiscTab") end

    local SettingsTab = loadModule("Menu/SettingsTab.lua")
    if not SettingsTab then return warn("Failed to load SettingsTab") end

    local tuffhiverd = {}

    function tuffhiverd.init()
        local Window = Library:CreateWindow({
            Title        = "tuffhiverd",
            Center       = true,
            AutoShow     = true,
            TabPadding   = 8,
            MenuFadeTime = 0.2,
        })

        local Tabs = {
            Combat   = Window:AddTab("Combat"),
            Visuals  = Window:AddTab("Visuals"),
            Misc     = Window:AddTab("Misc"),
            Settings = Window:AddTab("UI Settings"),
        }

        ThemeManager:SetLibrary(Library)
        SaveManager:SetLibrary(Library)
        ThemeManager:SetFolder("tuffhiverd")
        SaveManager:SetFolder("tuffhiverd")
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

        ESP:Init(PlayerRenderer, MobRenderer, ItemRenderer)
        CombatTab.Init(Tabs.Combat)
        VisualsTab.Init(Tabs.Visuals, ESP)
        MiscTab.Init(Tabs.Misc)
        SettingsTab.Init(Tabs.Settings, Library, SaveManager, ThemeManager, ESP)

        Library:SetWatermarkVisibility(true)
        Library:SetWatermark("tuffhiverd")

        SaveManager:LoadAutoloadConfig()
    end

    function tuffhiverd.detach()
        pcall(function() ESP:Unload() end)
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
