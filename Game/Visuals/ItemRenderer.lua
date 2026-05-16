local ItemRenderer = {}
ItemRenderer.__index = ItemRenderer

local Camera = workspace.CurrentCamera
local SMOOTH_SPEED = 0.12

local function NewLine(color, thickness)
    local l = Drawing.new("Line")
    l.Visible = false
    l.Color = color
    l.Thickness = thickness
    return l
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

local function GetBoundingBox(model)
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyOnScreen = false

    for _, part in ipairs(model:GetDescendants()) do
        if not part:IsA("BasePart") then continue end
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

function ItemRenderer.new(model)
    local self = setmetatable({}, ItemRenderer)
    self.modelName = model.Name
    self.box = {
        outer = { Top = NewLine(Color3.fromRGB(0,0,0), 1), Bottom = NewLine(Color3.fromRGB(0,0,0), 1), Left = NewLine(Color3.fromRGB(0,0,0), 1), Right = NewLine(Color3.fromRGB(0,0,0), 1) },
        main  = { Top = NewLine(Color3.fromRGB(255,200,0), 1), Bottom = NewLine(Color3.fromRGB(255,200,0), 1), Left = NewLine(Color3.fromRGB(255,200,0), 1), Right = NewLine(Color3.fromRGB(255,200,0), 1) },
        inner = { Top = NewLine(Color3.fromRGB(0,0,0), 1), Bottom = NewLine(Color3.fromRGB(0,0,0), 1), Left = NewLine(Color3.fromRGB(0,0,0), 1), Right = NewLine(Color3.fromRGB(0,0,0), 1) },
    }
    self.nameText = NewText(13)
    self.distText = NewText(11)
    return self
end

local function SetSetVisible(set, visible)
    for _, l in pairs(set) do l.Visible = visible end
end

function ItemRenderer:UpdateBox(min, max, color)
    local o, i = 1, 1
    local sets = {
        { set = self.box.outer, tl = Vector2.new(min.X-o, min.Y-o), tr = Vector2.new(max.X+o, min.Y-o), bl = Vector2.new(min.X-o, max.Y+o), br = Vector2.new(max.X+o, max.Y+o) },
        { set = self.box.main,  tl = Vector2.new(min.X,   min.Y),   tr = Vector2.new(max.X,   min.Y),   bl = Vector2.new(min.X,   max.Y),   br = Vector2.new(max.X,   max.Y)   },
        { set = self.box.inner, tl = Vector2.new(min.X+i, min.Y+i), tr = Vector2.new(max.X-i, min.Y+i), bl = Vector2.new(min.X+i, max.Y-i), br = Vector2.new(max.X-i, max.Y-i) },
    }
    for _, s in ipairs(sets) do
        s.set.Top.From    = s.tl; s.set.Top.To    = Vector2.new(s.tr.X+1, s.tr.Y)
        s.set.Bottom.From = s.bl; s.set.Bottom.To = Vector2.new(s.br.X+1, s.br.Y)
        s.set.Left.From   = s.tl; s.set.Left.To   = Vector2.new(s.bl.X,   s.bl.Y+1)
        s.set.Right.From  = s.tr; s.set.Right.To  = Vector2.new(s.br.X,   s.br.Y+1)
        for _, l in pairs(s.set) do l.Visible = true end
    end
    for _, l in pairs(self.box.main) do
        l.Color = color or Color3.fromRGB(255, 200, 0)
    end
end

function ItemRenderer:UpdateName(min, max)
    local fontSize = 13
    self.nameText.Size     = fontSize
    self.nameText.Text     = self.modelName
    self.nameText.Position = Vector2.new(math.round((min.X + max.X) / 2), math.round(min.Y - fontSize - 2))
    self.nameText.Visible  = true
end

function ItemRenderer:HideBox()
    for _, set in pairs(self.box) do SetSetVisible(set, false) end
    self.nameText.Visible = false
    self.distText.Visible = false
end

function ItemRenderer:Update(model, showBox, showName, boxColor)
    local min, max = GetBoundingBox(model)
    if not min then self:HideBox(); return end

    if showBox then self:UpdateBox(min, max, boxColor) else for _, s in pairs(self.box) do SetSetVisible(s, false) end end
    if showName then self:UpdateName(min, max) else self.nameText.Visible = false end
    self.distText.Visible = false
end

function ItemRenderer:Destroy()
    for _, set in pairs(self.box) do for _, l in pairs(set) do l:Remove() end end
    self.nameText:Remove()
    self.distText:Remove()
end

return ItemRenderer
