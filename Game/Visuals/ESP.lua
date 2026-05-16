local ESP = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Boxes = {}
local Connection

local function isPlayer(model)
    return Players:GetPlayerFromCharacter(model) ~= nil
end

local function getRoot(model)
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChildWhichIsA("BasePart")
end

local function getHealth(model)
    local hum = model:FindFirstChildWhichIsA("Humanoid")
    if hum then
        return hum.Health, hum.MaxHealth
    end
    return nil, nil
end

local function createBox(model)
    if Boxes[model] then return end

    local box = {
        Highlight = Instance.new("BoxHandleAdornment"),
        NameLabel = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthFill = Drawing.new("Square"),
    }

    box.Highlight.Adornee = model
    box.Highlight.AlwaysOnTop = true
    box.Highlight.ZIndex = 5
    box.Highlight.Size = Vector3.new(4, 6, 4)
    box.Highlight.Color3 = Color3.fromRGB(255, 255, 255)
    box.Highlight.Transparency = 0.6
    box.Highlight.Parent = Camera

    box.NameLabel.Visible = false
    box.NameLabel.Center = true
    box.NameLabel.Outline = true
    box.NameLabel.Size = 14
    box.NameLabel.Font = Drawing.Fonts.UI
    box.NameLabel.Color = Color3.fromRGB(255, 255, 255)

    box.HealthBar.Visible = false
    box.HealthBar.Filled = false
    box.HealthBar.Color = Color3.fromRGB(0, 0, 0)
    box.HealthBar.Thickness = 3

    box.HealthFill.Visible = false
    box.HealthFill.Filled = true
    box.HealthFill.Color = Color3.fromRGB(0, 255, 0)
    box.HealthFill.Thickness = 1

    Boxes[model] = box
end

local function removeBox(model)
    local box = Boxes[model]
    if not box then return end

    box.Highlight:Destroy()
    box.NameLabel:Remove()
    box.HealthBar:Remove()
    box.HealthFill:Remove()

    Boxes[model] = nil
end

local function updateBox(model, box, showName, showHealth)
    local root = getRoot(model)
    if not root then
        box.Highlight.Adornee = nil
        box.NameLabel.Visible = false
        box.HealthBar.Visible = false
        box.HealthFill.Visible = false
        return
    end

    box.Highlight.Adornee = model

    local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)

    if not onScreen then
        box.NameLabel.Visible = false
        box.HealthBar.Visible = false
        box.HealthFill.Visible = false
        return
    end

    local scale = 1 / (rootPos.Z * math.tan(math.rad(Camera.FieldOfView / 2)) * 2 / Camera.ViewportSize.Y)
    local boxH = 6 * scale
    local boxW = 4 * scale
    local screenX = rootPos.X
    local screenY = rootPos.Y

    if showName then
        local player = Players:GetPlayerFromCharacter(model)
        box.NameLabel.Text = player and player.DisplayName or model.Name
        box.NameLabel.Position = Vector2.new(screenX, screenY - boxH / 2 - 16)
        box.NameLabel.Visible = true
    else
        box.NameLabel.Visible = false
    end

    if showHealth then
        local hp, maxHp = getHealth(model)
        if hp and maxHp and maxHp > 0 then
            local ratio = math.clamp(hp / maxHp, 0, 1)
            local barX = screenX - boxW / 2 - 6
            local barY = screenY - boxH / 2
            local barH = boxH

            box.HealthBar.Position = Vector2.new(barX, barY)
            box.HealthBar.Size = Vector2.new(4, barH)
            box.HealthBar.Visible = true

            box.HealthFill.Position = Vector2.new(barX, barY + barH * (1 - ratio))
            box.HealthFill.Size = Vector2.new(4, barH * ratio)
            box.HealthFill.Color = Color3.fromRGB(
                math.floor(255 * (1 - ratio)),
                math.floor(255 * ratio),
                0
            )
            box.HealthFill.Visible = true
        else
            box.HealthBar.Visible = false
            box.HealthFill.Visible = false
        end
    else
        box.HealthBar.Visible = false
        box.HealthFill.Visible = false
    end
end

function ESP:Update()
    local playerESP  = Toggles.PlayerESP  and Toggles.PlayerESP.Value
    local mobESP     = Toggles.MobESP     and Toggles.MobESP.Value
    local showHealth = Toggles.ShowHealth and Toggles.ShowHealth.Value
    local showName   = Toggles.ShowName   and Toggles.ShowName.Value

    local alive = workspace:FindFirstChild("Alive")
    if not alive then return end

    local current = {}

    for _, model in ipairs(alive:GetChildren()) do
        if not model:IsA("Model") then continue end
        if model == LocalPlayer.Character then continue end

        local isPlr = isPlayer(model)
        local shouldShow = (isPlr and playerESP) or (not isPlr and mobESP)

        if shouldShow then
            current[model] = true
            if not Boxes[model] then
                createBox(model)
            end
            updateBox(model, Boxes[model], showName, showHealth)
        end
    end

    for model in pairs(Boxes) do
        if not current[model] then
            removeBox(model)
        end
    end
end

function ESP:Start()
    if Connection then return end
    Connection = RunService.RenderStepped:Connect(function()
        ESP:Update()
    end)
end

function ESP:Stop()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    for model in pairs(Boxes) do
        removeBox(model)
    end
end

function ESP:Unload()
    ESP:Stop()
end

return ESP
