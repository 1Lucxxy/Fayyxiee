-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- LOAD RAYFIELD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Delta Visual SAFE",
    LoadingTitle = "Visual Loading",
    LoadingSubtitle = "by dafaaa",
    ConfigurationSaving = { Enabled = false }
})

local VisualTab = Window:CreateTab("Visual", 4483362458)

-- SETTINGS
local Settings = {
    Enabled = false,
    TeamCheck = true,
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

    -- 🔴 HIGHLIGHT BODY
    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.Parent = CoreGui
    hl.FillColor = Settings.Color
    hl.FillTransparency = 0.8
    hl.OutlineTransparency = 1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Cache[p].Highlight = hl

    -- 📦 BOX (SelectionBox)
    local box = Instance.new("SelectionBox")
    box.Adornee = char
    box.Color3 = Settings.Color
    box.LineThickness = 0.05
    box.SurfaceTransparency = 1
    box.Parent = char
    Cache[p].Box = box

    -- 🏷️ NAME + DISTANCE (BESAR)
    local gui = Instance.new("BillboardGui")
    gui.Adornee = hrp
    gui.Size = UDim2.fromScale(6, 2.5)
    gui.StudsOffset = Vector3.new(0, 4, 0)
    gui.AlwaysOnTop = true
    gui.Parent = CoreGui
    Cache[p].Gui = gui

    local txt = Instance.new("TextLabel")
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.fromScale(1, 1)
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBlack
    txt.TextStrokeTransparency = 0
    txt.TextColor3 = Settings.Color
    txt.Parent = gui
    Cache[p].Text = txt

    -- LOOP UPDATE
    task.spawn(function()
        while Settings.Enabled and hum.Health > 0 do
            if not IsEnemy(p) then break end

            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHRP then break end

            local dist = math.floor((myHRP.Position - hrp.Position).Magnitude)
            txt.Text = p.Name .. "\n[" .. dist .. "m]"

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
Players.PlayerRemoving:Connect(ClearESP)

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

VisualTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Settings.Color,
    Callback = function(c)
        Settings.Color = c
        ClearAll()
        if Settings.Enabled then
            for _,p in pairs(Players:GetPlayers()) do
                ApplyESP(p)
            end
        end
    end
})

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
