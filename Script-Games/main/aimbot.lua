-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- LOAD RAYFIELD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Delta Visual Clean",
    LoadingTitle = "Loading",
    LoadingSubtitle = "by dafaaa",
    ConfigurationSaving = { Enabled = false }
})

local VisualTab = Window:CreateTab("Visual", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)

-- ================= SETTINGS =================

local Visual = {
    Enabled = false,
    TeamCheck = true,
    Color = Color3.fromRGB(255, 0, 0)
}

local Hitbox = {
    Enabled = false,
    Size = Vector3.new(6,6,6)
}

local ESP = {}
local HitboxCache = {}

-- ================= UTILS =================

local function IsEnemy(p)
    if not Visual.TeamCheck then return true end
    if not p.Team or not LocalPlayer.Team then return true end
    return p.Team ~= LocalPlayer.Team
end

local function ClearESP(p)
    if ESP[p] then
        for _,v in pairs(ESP[p]) do
            if typeof(v) == "Instance" then
                v:Destroy()
            end
        end
        ESP[p] = nil
    end
end

local function ClearAllESP()
    for _,p in pairs(Players:GetPlayers()) do
        ClearESP(p)
    end
end

-- ================= VISUAL =================

local function ApplyESP(p)
    if not Visual.Enabled then return end
    if p == LocalPlayer then return end
    if not IsEnemy(p) then return end
    if not p.Character then return end

    ClearESP(p)
    ESP[p] = {}

    local char = p.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    -- Highlight Body
    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.Parent = CoreGui
    hl.FillColor = Visual.Color
    hl.FillTransparency = 0.8
    hl.OutlineTransparency = 1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    ESP[p].Highlight = hl

    -- Name + Distance (KECIL)
    local gui = Instance.new("BillboardGui")
    gui.Adornee = hrp
    gui.Size = UDim2.fromScale(3, 1.2)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.AlwaysOnTop = true
    gui.Parent = CoreGui
    ESP[p].Gui = gui

    local txt = Instance.new("TextLabel")
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.fromScale(1,1)
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true
    txt.TextStrokeTransparency = 0.5
    txt.TextColor3 = Visual.Color
    txt.Parent = gui
    ESP[p].Text = txt

    task.spawn(function()
        while Visual.Enabled and hum.Health > 0 do
            if not IsEnemy(p) then break end
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myHRP then break end
            local dist = math.floor((myHRP.Position - hrp.Position).Magnitude)
            txt.Text = p.Name .. " [" .. dist .. "m]"
            task.wait(0.25)
        end
        ClearESP(p)
    end)
end

-- ================= HITBOX =================

local function ClearHitbox(p)
    if HitboxCache[p] then
        local hrp = HitboxCache[p]
        if hrp then
            hrp.Size = Vector3.new(2,2,1)
            hrp.Transparency = 1
            hrp.Material = Enum.Material.Plastic
        end
        HitboxCache[p] = nil
    end
end

local function ApplyHitbox(p)
    if not Hitbox.Enabled then return end
    if p == LocalPlayer then return end
    if not IsEnemy(p) then return end
    if not p.Character then return end

    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.Size = Hitbox.Size
    hrp.Transparency = 0.5
    hrp.Material = Enum.Material.Neon
    hrp.CanCollide = false

    HitboxCache[p] = hrp
end

-- ================= PLAYER EVENTS =================

local function SetupPlayer(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.4)
        if Visual.Enabled then ApplyESP(p) end
        if Hitbox.Enabled then ApplyHitbox(p) end
    end)
end

for _,p in pairs(Players:GetPlayers()) do
    SetupPlayer(p)
end

Players.PlayerRemoving:Connect(function(p)
    ClearESP(p)
    ClearHitbox(p)
end)

-- ================= UI =================

VisualTab:CreateToggle({
    Name = "Enable Highlight",
    Callback = function(v)
        Visual.Enabled = v
        ClearAllESP()
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
        Visual.TeamCheck = v
        ClearAllESP()
        if Visual.Enabled then
            for _,p in pairs(Players:GetPlayers()) do
                ApplyESP(p)
            end
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "Highlight Color",
    Color = Visual.Color,
    Callback = function(c)
        Visual.Color = c
        ClearAllESP()
        if Visual.Enabled then
            for _,p in pairs(Players:GetPlayers()) do
                ApplyESP(p)
            end
        end
    end
})

VisualTab:CreateButton({
    Name = "Refresh Highlight",
    Callback = function()
        if Visual.Enabled then
            ClearAllESP()
            for _,p in pairs(Players:GetPlayers()) do
                ApplyESP(p)
            end
        end
    end
})

CombatTab:CreateToggle({
    Name = "Hitbox Expander",
    Callback = function(v)
        Hitbox.Enabled = v
        if not v then
            for p,_ in pairs(HitboxCache) do
                ClearHitbox(p)
            end
        else
            for _,p in pairs(Players:GetPlayers()) do
                ApplyHitbox(p)
            end
        end
    end
})
