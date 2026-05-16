local Misc = {}

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer

local Connections = {}
local OriginalValues = {}

local function getChar()
    return LocalPlayer.Character
end

local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function connect(event, fn)
    local c = event:Connect(fn)
    table.insert(Connections, c)
    return c
end

-- Movement

local flyConn = nil
local flyBodyVel = nil
local flyBodyGyro = nil

local function startFly()
    local hrp = getHRP()
    if not hrp then return end

    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVel.Velocity = Vector3.zero
    flyBodyVel.Parent = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBodyGyro.D = 100
    flyBodyGyro.CFrame = hrp.CFrame
    flyBodyGyro.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not Toggles.Fly or not Toggles.Fly.Value then
            stopFly()
            return
        end
        local hrp2 = getHRP()
        if not hrp2 then return end

        local speed = Options.FlySpeed and Options.FlySpeed.Value or 50
        local cam   = workspace.CurrentCamera
        local dir   = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

        if dir.Magnitude > 0 then
            flyBodyVel.Velocity = dir.Unit * speed
        else
            flyBodyVel.Velocity = Vector3.zero
        end

        flyBodyGyro.CFrame = cam.CFrame
    end)
end

function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    local hum = getHum()
    if hum then hum.PlatformStand = false end
end

local noclipConn = nil

local function startNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        local char = getChar()
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    local char = getChar()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- QOL

local antiAFKConn = nil

local function startAntiAFK()
    antiAFKConn = task.spawn(function()
        while Toggles.AntiAFK and Toggles.AntiAFK.Value do
            local vrs = game:GetService("VirtualUser")
            vrs:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            vrs:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(20)
        end
    end)
end

local origBrightness = nil

local function setFullbright(enabled)
    local lighting = game:GetService("Lighting")
    if enabled then
        if not origBrightness then
            origBrightness = {
                Brightness        = lighting.Brightness,
                ClockTime         = lighting.ClockTime,
                FogEnd            = lighting.FogEnd,
                GlobalShadows     = lighting.GlobalShadows,
                Ambient           = lighting.Ambient,
                OutdoorAmbient    = lighting.OutdoorAmbient,
            }
        end
        lighting.Brightness     = 2
        lighting.ClockTime      = 14
        lighting.FogEnd         = 100000
        lighting.GlobalShadows  = false
        lighting.Ambient        = Color3.fromRGB(178, 178, 178)
        lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    else
        if origBrightness then
            for k, v in pairs(origBrightness) do
                lighting[k] = v
            end
            origBrightness = nil
        end
    end
end

local origFOV = nil

local function setFOV(enabled, value)
    local cam = workspace.CurrentCamera
    if enabled then
        if not origFOV then origFOV = cam.FieldOfView end
        cam.FieldOfView = value or 90
    else
        if origFOV then
            cam.FieldOfView = origFOV
            origFOV = nil
        end
    end
end

-- Combat

local noRagdollConn = nil

local function startNoRagdoll()
    noRagdollConn = RunService.Stepped:Connect(function()
        local hum = getHum()
        if hum and hum:GetState() == Enum.HumanoidStateType.Ragdoll then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function stopNoRagdoll()
    if noRagdollConn then noRagdollConn:Disconnect(); noRagdollConn = nil end
end

local noFallDmgConn = nil

local function startNoFallDamage()
    noFallDmgConn = RunService.Stepped:Connect(function()
        local hum = getHum()
        if hum then
            hum.FreeFalling:Connect(function(active)
                if not active then
                    hum.Health = hum.Health
                end
            end)
        end
    end)
end

local function stopNoFallDamage()
    if noFallDmgConn then noFallDmgConn:Disconnect(); noFallDmgConn = nil end
end

local infJumpConn = nil

local function startInfJump()
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

local function stopInfJump()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
end

function Misc:Init()
    Toggles.Fly:OnChanged(function(v)
        if v then startFly() else stopFly() end
    end)

    Toggles.Noclip:OnChanged(function(v)
        if v then startNoclip() else stopNoclip() end
    end)

    Toggles.InfiniteJump:OnChanged(function(v)
        if v then startInfJump() else stopInfJump() end
    end)

    Toggles.NoRagdoll:OnChanged(function(v)
        if v then startNoRagdoll() else stopNoRagdoll() end
    end)

    Toggles.NoFallDamage:OnChanged(function(v)
        if v then startNoFallDamage() else stopNoFallDamage() end
    end)

    Toggles.Fullbright:OnChanged(function(v)
        setFullbright(v)
    end)

    Toggles.FOVChanger:OnChanged(function(v)
        setFOV(v, Options.FOVValue and Options.FOVValue.Value or 90)
    end)

    Options.FOVValue:OnChanged(function(v)
        if Toggles.FOVChanger and Toggles.FOVChanger.Value then
            workspace.CurrentCamera.FieldOfView = v
        end
    end)

    Toggles.SpeedHack:OnChanged(function(v)
        local hum = getHum()
        if not hum then return end
        if v then
            OriginalValues.WalkSpeed = hum.WalkSpeed
            hum.WalkSpeed = Options.WalkSpeed and Options.WalkSpeed.Value or 32
        else
            hum.WalkSpeed = OriginalValues.WalkSpeed or 16
        end
    end)

    Options.WalkSpeed:OnChanged(function(v)
        if Toggles.SpeedHack and Toggles.SpeedHack.Value then
            local hum = getHum()
            if hum then hum.WalkSpeed = v end
        end
    end)

    Toggles.AntiAFK:OnChanged(function(v)
        if v then startAntiAFK() end
    end)
end

function Misc:Unload()
    stopFly()
    stopNoclip()
    stopInfJump()
    stopNoRagdoll()
    stopNoFallDamage()
    setFullbright(false)
    setFOV(false)

    local hum = getHum()
    if hum and OriginalValues.WalkSpeed then
        hum.WalkSpeed = OriginalValues.WalkSpeed
    end

    for _, c in ipairs(Connections) do c:Disconnect() end
    Connections = {}
end

return Misc
