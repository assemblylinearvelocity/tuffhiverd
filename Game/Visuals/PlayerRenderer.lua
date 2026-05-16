local PlayerRenderer = {}
PlayerRenderer.__index = PlayerRenderer

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local BODY_PARTS = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg","HumanoidRootPart"}
local BAR_GAP = 3
local SMOOTH_SPEED = 0.12

local function NewLine(color, thickness)
    local l = Drawing.new("Line")
    l.Visible = false
    l.Color = color
    l.Thickness = thickness
    return l
end

local function NewBoxSet(color, thickness)
    return {
        Top    = NewLine(color, thickness),
        Bottom = NewLine(color, thickness),
        Left   = NewLine(color, thickness),
        Right  = NewLine(color, thickness),
    }
end

local function SetSetVisible(set, visible)
    for _, l in pairs(set) do l.Visible = visible end
end

local function GetBoundingBox(character)
    if not character:FindFirstChild("HumanoidRootPart") then return nil, nil end
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyOnScreen = false
    for _, partName in ipairs(BODY_PARTS) do
        local part = character:FindFirstChild(partName)
        if not part or not part:IsA("BasePart") then continue end
        local size = part.Size
        local cf = part.CFrame
        local offsets = {
            Vector3.new( size.X/2,  size.Y/2,  size.Z/2),
            Vector3.new(-size.X/2,  size.Y/2,  size.Z/2),
            Vector3.new( size.X/2, -size.Y/2,  size.Z/2),
            Vector3.new(-size.X/2, -size.Y/2,  size.Z/2),
            Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
            Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
            Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
            Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
        }
        for _, offset in ipairs(offsets) do
            local screen, onScreen = Camera:WorldToViewportPoint(cf * offset)
            if onScreen then
                anyOnScreen = true
                minX = math.min(minX, screen.X)
                minY = math.min(minY, screen.Y)
                maxX = math.max(maxX, screen.X)
                maxY = math.max(maxY, screen.Y)
            end
        end
    end
    if not anyOnScreen then return nil, nil end
    return Vector2.new(math.round(minX), math.round(minY)),
           Vector2.new(math.round(maxX), math.round(maxY))
end

local function GetHealth(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return 100, 100 end
    local maxHp = character:GetAttribute("MaxHealth") or humanoid.MaxHealth
    local hp = humanoid.Health
    if maxHp <= 0 then maxHp = 100 end
    return math.clamp(hp, 0, maxHp), maxHp
end

local function HpToColor(pct)
    pct = math.clamp(pct, 0, 1)
    if pct > 0.5 then
        return Color3.fromRGB(math.floor(255*(1-pct)*2), 255, 0)
    else
        return Color3.fromRGB(255, math.floor(255*pct*2), 0)
    end
end

local function NewText(size)
    local t = Drawing.new("Text")
    t.Visible = false
    t.Size = size
    t.Center = true
    t.Outline = true
    t.Color = Color3.fromRGB(255, 255, 255)
    return t
end

function PlayerRenderer.new(player)
    local self = setmetatable({}, PlayerRenderer)
    self.player = player
    self.box = {
        outer = NewBoxSet(Color3.fromRGB(0, 0, 0), 1),
        main  = NewBoxSet(Color3.fromRGB(255, 255, 255), 1),
        inner = NewBoxSet(Color3.fromRGB(0, 0, 0), 1),
    }
    self.healthBar = {
        outlineLeft   = NewLine(Color3.fromRGB(0, 0, 0), 1),
        outlineRight  = NewLine(Color3.fromRGB(0, 0, 0), 1),
        outlineTop    = NewLine(Color3.fromRGB(0, 0, 0), 1),
        outlineBottom = NewLine(Color3.fromRGB(0, 0, 0), 1),
        fill          = NewLine(Color3.fromRGB(0, 255, 0), 1),
    }
    self.nameText  = NewText(16)
    self.healthText = NewText(10)
    self.distText  = NewText(11)
    self._smoothHp = 1
    return self
end

function PlayerRenderer:UpdateBox(min, max, color)
    local o, i = 1, 1
    local sets = {
        { set = self.box.outer, tl = Vector2.new(min.X-o, min.Y-o), tr = Vector2.new(max.X+o, min.Y-o), bl = Vector2.new(min.X-o, max.Y+o), br = Vector2.new(max.X+o, max.Y+o) },
        { set = self.box.main,  tl = Vector2.new(min.X,   min.Y),   tr = Vector2.new(max.X,   min.Y),   bl = Vector2.new(min.X,   max.Y),   br = Vector2.new(max.X,   max.Y)   },
        { set = self.box.inner, tl = Vector2.new(min.X+i, min.Y+i), tr = Vector2.new(max.X-i, min.Y+i), bl = Vector2.new(min.X+i, max.Y-i), br = Vector2.new(max.X-i, max.Y-i) },
    }
    for _, s in ipairs(sets) do
        s.set.Top.From    = s.tl;  s.set.Top.To    = Vector2.new(s.tr.X+1, s.tr.Y)
        s.set.Bottom.From = s.bl;  s.set.Bottom.To = Vector2.new(s.br.X+1, s.br.Y)
        s.set.Left.From   = s.tl;  s.set.Left.To   = Vector2.new(s.bl.X,   s.bl.Y+1)
        s.set.Right.From  = s.tr;  s.set.Right.To  = Vector2.new(s.br.X,   s.br.Y+1)
        for _, l in pairs(s.set) do l.Visible = true end
    end
    for _, l in pairs(self.box.main) do
        l.Color = color or Color3.fromRGB(255, 255, 255)
    end
end

function PlayerRenderer:UpdateName(min, max)
    local label = self.player.DisplayName .. " (@" .. self.player.Name .. ")"
    local fontSize = math.clamp(math.round((max.Y - min.Y) * 0.15), 15, 18)
    self.nameText.Size     = fontSize
    self.nameText.Text     = label
    self.nameText.Position = Vector2.new(math.round((min.X + max.X) / 2), math.round(min.Y - fontSize - 2))
    self.nameText.Visible  = true
end

function PlayerRenderer:HideName()
    self.nameText.Visible = false
end

function PlayerRenderer:UpdateHealthBar(min, max, character)
    local hp, maxHp = GetHealth(character)
    self._smoothHp = self._smoothHp + (hp / maxHp - self._smoothHp) * SMOOTH_SPEED
    local pct    = math.clamp(self._smoothHp, 0, 1)
    local top    = math.round(min.Y)
    local bottom = math.round(max.Y)
    local height = bottom - top
    local barX   = math.round(min.X - BAR_GAP - 1)
    local fillY  = math.round(bottom - height * pct)

    self.healthBar.outlineLeft.From    = Vector2.new(barX-1, top-1);    self.healthBar.outlineLeft.To    = Vector2.new(barX-1, bottom+1); self.healthBar.outlineLeft.Visible    = true
    self.healthBar.outlineRight.From   = Vector2.new(barX+1, top-1);   self.healthBar.outlineRight.To   = Vector2.new(barX+1, bottom+1); self.healthBar.outlineRight.Visible   = true
    self.healthBar.outlineTop.From     = Vector2.new(barX-1, top-1);   self.healthBar.outlineTop.To     = Vector2.new(barX+2, top-1);    self.healthBar.outlineTop.Visible     = true
    self.healthBar.outlineBottom.From  = Vector2.new(barX-1, bottom+1); self.healthBar.outlineBottom.To = Vector2.new(barX+2, bottom+1); self.healthBar.outlineBottom.Visible  = true

    self.healthBar.fill.From    = Vector2.new(barX, math.max(fillY, top))
    self.healthBar.fill.To      = Vector2.new(barX, bottom + 1)
    self.healthBar.fill.Color   = HpToColor(pct)
    self.healthBar.fill.Visible = pct > 0
    self.healthText.Visible     = false
end

function PlayerRenderer:HideHealthBar()
    for _, l in pairs(self.healthBar) do l.Visible = false end
    self.healthText.Visible = false
end

function PlayerRenderer:HideBox()
    for _, set in pairs(self.box) do SetSetVisible(set, false) end
    self:HideHealthBar()
    self:HideName()
    self.distText.Visible = false
end

function PlayerRenderer:Update(character, showBox, showHealth, showName, boxColor)
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        self:HideBox(); return
    end
    local min, max = GetBoundingBox(character)
    if not min then self:HideBox(); return end

    if showBox then self:UpdateBox(min, max, boxColor) else for _, s in pairs(self.box) do SetSetVisible(s, false) end end
    if showHealth then self:UpdateHealthBar(min, max, character) else self:HideHealthBar() end
    if showName then self:UpdateName(min, max) else self:HideName() end
    self.distText.Visible = false
end

function PlayerRenderer:Destroy()
    for _, set in pairs(self.box) do for _, l in pairs(set) do l:Remove() end end
    for _, l in pairs(self.healthBar) do l:Remove() end
    self.nameText:Remove()
    self.healthText:Remove()
    self.distText:Remove()
end

return PlayerRenderer
