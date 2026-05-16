local ESP = {}

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local PlayerRenderer = nil
local MobRenderer    = nil
local ItemRenderer   = nil

local EntityRenderers = {}
local ItemRenderers   = {}
local Connection      = nil

local function isPlayer(model)
    return Players:GetPlayerFromCharacter(model) ~= nil
end

local function removeRenderer(tbl, key)
    if tbl[key] then
        tbl[key]:Destroy()
        tbl[key] = nil
    end
end

local function updateEntities()
    local playerESP      = Toggles.PlayerESP    and Toggles.PlayerESP.Value
    local mobESP         = Toggles.MobESP       and Toggles.MobESP.Value
    local plrShowHealth  = Toggles.ShowHealth   and Toggles.ShowHealth.Value
    local plrShowName    = Toggles.ShowName     and Toggles.ShowName.Value
    local mobShowHealth  = Toggles.MobShowHealth and Toggles.MobShowHealth.Value
    local mobShowName    = Toggles.MobShowName   and Toggles.MobShowName.Value

    local alive = workspace:FindFirstChild("Alive")
    if not alive then return end

    local current = {}

    for _, model in ipairs(alive:GetChildren()) do
        if not model:IsA("Model") then continue end
        if model == LocalPlayer.Character then continue end

        local isPlr      = isPlayer(model)
        local shouldShow = (isPlr and playerESP) or (not isPlr and mobESP)

        if shouldShow then
            current[model] = true

            if not EntityRenderers[model] then
                if isPlr then
                    local player = Players:GetPlayerFromCharacter(model)
                    EntityRenderers[model] = PlayerRenderer.new(player)
                else
                    EntityRenderers[model] = MobRenderer.new(model)
                end
            end

            local color = isPlr
                and (Options.PlayerESPColor and Options.PlayerESPColor.Value or Color3.fromRGB(255, 255, 255))
                or  (Options.MobESPColor    and Options.MobESPColor.Value    or Color3.fromRGB(255, 100, 100))

            local showHealth = isPlr and plrShowHealth or mobShowHealth
            local showName   = isPlr and plrShowName   or mobShowName

            EntityRenderers[model]:Update(model, true, showHealth, showName, color)
        else
            if EntityRenderers[model] then
                EntityRenderers[model]:HideBox()
            end
        end
    end

    for model in pairs(EntityRenderers) do
        if not current[model] then
            removeRenderer(EntityRenderers, model)
        end
    end
end

local function updateItems()
    local itemESP  = Toggles.ItemESP  and Toggles.ItemESP.Value
    local showName = Toggles.ItemShowName and Toggles.ItemShowName.Value

    local thrown = workspace:FindFirstChild("Thrown")
    if not thrown then return end

    local current = {}

    for _, model in ipairs(thrown:GetChildren()) do
        if not model:IsA("Model") and not model:IsA("BasePart") then continue end

        if itemESP then
            current[model] = true

            if not ItemRenderers[model] then
                ItemRenderers[model] = ItemRenderer.new(model)
            end

            local color = Options.ItemESPColor and Options.ItemESPColor.Value or Color3.fromRGB(255, 200, 0)
            ItemRenderers[model]:Update(model, true, showName, color)
        else
            if ItemRenderers[model] then
                ItemRenderers[model]:HideBox()
            end
        end
    end

    for model in pairs(ItemRenderers) do
        if not current[model] then
            removeRenderer(ItemRenderers, model)
        end
    end
end

function ESP:Init(playerRenderer, mobRenderer, itemRenderer)
    PlayerRenderer = playerRenderer
    MobRenderer    = mobRenderer
    ItemRenderer   = itemRenderer
end

function ESP:Start()
    if Connection then return end
    Connection = RunService.RenderStepped:Connect(function()
        updateEntities()
        updateItems()
    end)
end

function ESP:Stop()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
    for model, renderer in pairs(EntityRenderers) do
        renderer:Destroy()
        EntityRenderers[model] = nil
    end
    for model, renderer in pairs(ItemRenderers) do
        renderer:Destroy()
        ItemRenderers[model] = nil
    end
end

function ESP:Unload()
    ESP:Stop()
end

return ESP
