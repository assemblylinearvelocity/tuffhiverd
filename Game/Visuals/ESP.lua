local ESP = {}

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local EspRenderer = nil
local Renderers   = {}
local Connection  = nil

local function isPlayer(model)
    return Players:GetPlayerFromCharacter(model) ~= nil
end

local function getLabel(model)
    local player = Players:GetPlayerFromCharacter(model)
    if player then
        return player.DisplayName .. " (@" .. player.Name .. ")"
    end
    return model.Name
end

local function removeRenderer(model)
    if Renderers[model] then
        Renderers[model]:Destroy()
        Renderers[model] = nil
    end
end

local function update()
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

        local isPlr   = isPlayer(model)
        local shouldShow = (isPlr and playerESP) or (not isPlr and mobESP)

        if shouldShow then
            current[model] = true
            if not Renderers[model] then
                Renderers[model] = EspRenderer.new(model.Name)
            end
            local color = isPlr
                and (Options.PlayerESPColor and Options.PlayerESPColor.Value or Color3.fromRGB(255, 255, 255))
                or  (Options.MobESPColor    and Options.MobESPColor.Value    or Color3.fromRGB(255, 100, 100))
            Renderers[model]:Update(model, true, showHealth, showName, color, getLabel(model))
        else
            if Renderers[model] then
                Renderers[model]:HideBox()
            end
        end
    end

    for model in pairs(Renderers) do
        if not current[model] then
            removeRenderer(model)
        end
    end
end

function ESP:Init(renderer)
    EspRenderer = renderer
end

function ESP:Start()
    if Connection then return end
    Connection = RunService.RenderStepped:Connect(update)
end

function ESP:Stop()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    for model, renderer in pairs(Renderers) do
        renderer:Destroy()
        Renderers[model] = nil
    end
end

function ESP:Unload()
    ESP:Stop()
end

return ESP
