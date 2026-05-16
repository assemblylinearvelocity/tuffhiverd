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
        local Window = Library:Window({
            Name = "tuffhiverd",
            Size = UDim2.new(0, 550, 0, 400)
        })

        local Watermark = Library:Watermark("tuffhiverd")
        Watermark:SetVisibility(true)

        local KeybindList = Library:KeybindList()
        KeybindList:SetVisibility(false)

        local CombatPage   = Window:Page({ Name = "Combat",   Columns = 2 })
        local VisualsPage  = Window:Page({ Name = "Visuals",  Columns = 2 })
        local MiscPage     = Window:Page({ Name = "Misc",     Columns = 2 })
        local SettingsPage = Window:Page({ Name = "Settings", Columns = 2 })

        CombatTab.Init(CombatPage)
        VisualsTab.Init(VisualsPage)
        MiscTab.Init(MiscPage, Library)
        SettingsTab.Init(SettingsPage, Library, Watermark, KeybindList)
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
