-- SERVICES
local Players = game:GetService("Players")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- LOAD RAYFIELD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Delta Visual FINAL",
    LoadingTitle = "Stable Visual",
    LoadingSubtitle = "by dafaaa",
    ConfigurationSaving = { Enabled = false }
})

local VisualTab = Window:CreateTab("Visual", 4483362458)

-- SETTINGS (MASTER)
local Settings = {
    Enabled = false,
    TeamCheck = true,
    ShowName = true,
    ShowDistance = true,
    Color = Color3.fromRGB(255, 0, 0)
}

-- CACHE
local Cache = {}

-- ================= UTILS =================

local function IsEnemy(p)
    if not Settings.TeamCheck then return true end
    if not p.Team or not LocalPlayer.Team then return true end
    return p.Team ~= LocalPlayer.Team
end

local function ClearESP(p)
    if Cache[p] then
        if Cache[p].Loop then
            task.cancel(Cache[p].Loop)
        end
        for _,obj in pairs(Cache[p]) do
            if typeof(obj) == "Instance" then
                obj:Destroy()
            end
        end
        Cache[p] = nil
    end
end

local function ClearAll()
    for _,p in pairs(Players:GetPlayers()) do
        ClearESP(p)
    end
end

-- ================= APPLY ESP =================

local function ApplyESP(p)
    if not Settings.Enabled then return end
    if p == LocalPlayer then return end
    if not IsEnemy(p) then return end
    if not p.Character then return end

    ClearESP(p)
    Cache[p] = {}

    local char = p.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    -- HIGHLIGHT (STABLE)
    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.Parent = CoreGui
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.OutlineTransparency = 1
    hl.FillColor = Settings.Color
    hl.FillTransparency = 0.8
    Cache[p].Highlight = hl

    -- BILLBOARD
    local gui = Instance.new("BillboardGui")
    gui.Adornee = hrp
    gui.Size = UDim2.fromScale(5, 1.4)
    gui.StudsOffset = Vector3.new(0, 3.6, 0)
    gui.AlwaysOnTop = true
    gui.Parent = CoreGui
    Cache[p].Billboard = gui

    local txt = Instance.new("TextLabel")
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.fromScale(1, 1)
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.TextStrokeTransparency = 0
    txt.TextColor3 = Settings.Color
    txt.Parent = gui
    Cache[p].Text = txt

    -- LOOP (MASTER SAFE)
    Cache[p].Loop = task.spawn(function()
        while Settings.Enabled and hum.Health > 0 do
            if not Settings.Enabled or not IsEnemy(p) then
                break
            end

            local dist = math.floor(
                (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            )

            txt.Text =
                (Settings.ShowName and p.Name or "") ..
                (Settings.ShowDistance and ("\n[" .. dist .. "m]") or "")

            task.wait(0.25)
        end
        ClearESP(p)
    end)
end

-- ================= PLAYER HANDLER =================

local function SetupPlayer(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.4)
        if Settings.Enabled then
            ApplyESP(p)
        end
    end)

    if p.Character and Settings.Enabled then
        ApplyESP(p)
    end
end

for _,p in pairs(Players:GetPlayers()) do
    SetupPlayer(p)
end

Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(function(p)
    ClearESP(p)
end)

-- ================= UI =================

VisualTab:CreateToggle({
    Name = "Enable Highlight (MASTER)",
    Callback = function(v)
        Settings.Enabled = v
        ClearAll()
        if v then
            for _,p in pairs(Players:GetPlayers()) do
                ApplyESP(p)
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Callback = function(v)
        Settings.TeamCheck = v
        if Settings.Enabled then
            ClearAll()
            for _,p in pairs(Players:GetPlayers()) do
                ApplyESP(p)
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = true,
    Callback = function(v)
        Settings.ShowName = v
    end
})

VisualTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = true,
    Callback = function(v)
        Settings.ShowDistance = v
    end
})

VisualTab:CreateColorPicker({
    Name = "Highlight Color",
    Color = Settings.Color,
    Callback = function(c)
        Settings.Color = c
        for _,data in pairs(Cache) do
            if data.Highlight then
                data.Highlight.FillColor = c
            end
            if data.Text then
                data.Text.TextColor3 = c
            end
        end
    end
})

-- 🔄 REFRESH BUTTON
VisualTab:CreateButton({
    Name = "Refresh Highlight",
    Callback = function()
        if not Settings.Enabled then return end
        ClearAll()
        for _,p in pairs(Players:GetPlayers()) do
            ApplyESP(p)
        end
    end
})

-- ================= COMBAT TAB =================

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local CombatTab = Window:CreateTab("Combat", 4483362458)

local Combat = {
    Dot = false,
    AimHead = false,
    AimBody = false,
    POV = false,
    Radius = 150,
    Smooth = 0.18,
    Hitbox = false,
    HitboxSize = 5,
    TeamCheck = true,
    Priority = "Crosshair"
}

-- ================= DOT CROSSHAIR =================

local Dot
task.delay(1, function()
    pcall(function()
        Dot = Drawing.new("Circle")
        Dot.Filled = true
        Dot.Radius = 2
        Dot.Color = Color3.fromRGB(255,255,255)
        Dot.Visible = false
        Dot.Transparency = 1
    end)
end)

-- ================= POV CIRCLE =================

local POVCircle
task.delay(1, function()
    pcall(function()
        POVCircle = Drawing.new("Circle")
        POVCircle.Filled = false
        POVCircle.Thickness = 1
        POVCircle.NumSides = 64
        POVCircle.Color = Color3.fromRGB(255,255,255)
        POVCircle.Visible = false
        POVCircle.Transparency = 1
    end)
end)

-- ================= TARGET FIND =================

local function GetTarget()
    local closest, dist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local part = p.Character:FindFirstChild(Combat.AimHead and "Head" or "HumanoidRootPart")
            if hum and part and hum.Health > 0 then
                if Combat.TeamCheck and p.Team == LocalPlayer.Team then continue end

                local pos, onscreen = Camera:WorldToViewportPoint(part.Position)
                if onscreen then
                    local mag = (Vector2.new(pos.X,pos.Y) - center).Magnitude
                    if not Combat.POV or mag <= Combat.Radius then
                        if mag < dist then
                            dist = mag
                            closest = part
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- ================= AIM LOOP =================

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if Dot then
        Dot.Position = center
        Dot.Visible = Combat.Dot
    end

    if POVCircle then
        POVCircle.Position = center
        POVCircle.Radius = Combat.Radius
        POVCircle.Visible = Combat.POV
    end

    if Combat.AimHead or Combat.AimBody then
        local target = GetTarget()
        if target then
            local cf = Camera.CFrame
            Camera.CFrame = cf:Lerp(
                CFrame.new(cf.Position, target.Position),
                Combat.Smooth
            )
        end
    end
end)

-- ================= HITBOX =================

local function ApplyHitbox(p)
    if not Combat.Hitbox then return end
    if p == LocalPlayer then return end
    if Combat.TeamCheck and p.Team == LocalPlayer.Team then return end
    if not p.Character then return end

    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Size = Vector3.new(
            Combat.HitboxSize,
            Combat.HitboxSize,
            Combat.HitboxSize
        )
        hrp.Transparency = 0.7
        hrp.CanCollide = false
    end
end

for _,p in pairs(Players:GetPlayers()) do
    ApplyHitbox(p)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        ApplyHitbox(p)
    end)
end)

-- ================= UI COMBAT =================

CombatTab:CreateToggle({
    Name = "Dot Crosshair",
    Callback = function(v)
        Combat.Dot = v
    end
})

CombatTab:CreateToggle({
    Name = "Aim Head",
    Callback = function(v)
        Combat.AimHead = v
        if v then Combat.AimBody = false end
    end
})

CombatTab:CreateToggle({
    Name = "Aim Body",
    Callback = function(v)
        Combat.AimBody = v
        if v then Combat.AimHead = false end
    end
})

CombatTab:CreateToggle({
    Name = "Enable POV",
    Callback = function(v)
        Combat.POV = v
    end
})

CombatTab:CreateSlider({
    Name = "POV Radius",
    Range = {50,300},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(v)
        Combat.Radius = v
    end
})

CombatTab:CreateToggle({
    Name = "Hitbox Expander",
    Callback = function(v)
        Combat.Hitbox = v
    end
})

CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {2,12},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(v)
        Combat.HitboxSize = v
        for _,p in pairs(Players:GetPlayers()) do
            ApplyHitbox(p)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Team Check",
    Callback = function(v)
        Combat.TeamCheck = v
    end
})
