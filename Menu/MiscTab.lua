local MiscTab = {}

function MiscTab.Init(Tab)
    local MovementBox = Tab:AddLeftGroupbox("Movement")
    local CombatBox   = Tab:AddRightGroupbox("Combat")
    local QOLBox      = Tab:AddLeftGroupbox("QOL")

    MovementBox:AddToggle("Fly",           { Text = "Fly",            Default = false })
    MovementBox:AddSlider("FlySpeed",      { Text = "Fly Speed",      Default = 50, Min = 1, Max = 300, Rounding = 1, Suffix = " studs/s" })
    MovementBox:AddToggle("Noclip",        { Text = "Noclip",         Default = false })
    MovementBox:AddToggle("SpeedHack",     { Text = "Speed Hack",     Default = false })
    MovementBox:AddSlider("WalkSpeed",     { Text = "Walk Speed",     Default = 32,  Min = 1, Max = 300, Rounding = 1 })
    MovementBox:AddToggle("InfiniteJump",  { Text = "Infinite Jump",  Default = false })

    CombatBox:AddToggle("NoRagdoll",       { Text = "No Ragdoll",     Default = false })
    CombatBox:AddToggle("NoFallDamage",    { Text = "No Fall Damage", Default = false })

    QOLBox:AddToggle("AntiAFK",            { Text = "Anti AFK",       Default = false })
    QOLBox:AddToggle("Fullbright",         { Text = "Fullbright",     Default = false })
    QOLBox:AddToggle("FOVChanger",         { Text = "FOV Changer",    Default = false })
    QOLBox:AddSlider("FOVValue",           { Text = "FOV",            Default = 90,  Min = 1, Max = 120, Rounding = 1 })
end

return MiscTab
