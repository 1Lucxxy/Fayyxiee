-- =========================
-- DELTA SAFE LOAD
-- =========================
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua",
    true
))()

local Window = Rayfield:CreateWindow({
    Name = "Visual Hub",
    LoadingTitle = "Loading",
    LoadingSubtitle = "Delta Fixed",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- =========================
-- SERVICES
-- =========================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- HIGHLIGHT STORAGE (DIPISAH)
-- =========================
local Highlights = {
    Player = {},
    NPC = {},
    Generator = {},
    Hook = {},
    Window = {},
    Gift = {}
}

-- =========================
-- HIGHLIGHT UTILS (FIXED)
-- =========================
local function createHighlight(model, color, store)
    if not model then return end
    if model:FindFirstChild("RF_HL") then return end
    if not model:FindFirstChildWhichIsA("BasePart") then return end

    local hl = Instance.new("Highlight")
    hl.Name = "RF_HL"
    hl.Adornee = model
    hl.FillColor = color
    hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = 0.45
    hl.OutlineTransparency = 0
    hl.Parent = model

    table.insert(store, hl)
end

local function removeHighlights(store)
    for _, hl in pairs(store) do
        if hl and hl.Parent then
            hl:Destroy()
        end
    end
    table.clear(store)
end

-- =========================
-- TEAM HIGHLIGHT (FIXED)
-- =========================
local function highlightTeams(state)
    removeHighlights(Highlights.Player)
    if not state then return end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Team then
            if plr.Team.Name == "Survivor" then
                createHighlight(plr.Character, Color3.fromRGB(0,255,0), Highlights.Player)
            elseif plr.Team.Name == "Killer" then
                createHighlight(plr.Character, Color3.fromRGB(255,0,0), Highlights.Player)
            end
        end
    end
end

-- =========================
-- MODEL NAME HIGHLIGHT (FIXED)
-- =========================
local function highlightByName(name, color, state, store)
    removeHighlights(store)
    if not state then return end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == name then
            createHighlight(obj, color, store)
        end
    end
end

-- =========================
-- AUTO REFRESH PLAYER
-- =========================
Players.PlayerAdded:Connect(function()
    task.wait(1)
    highlightTeams(true)
end)

Players.PlayerRemoving:Connect(function()
    highlightTeams(true)
end)

-- =========================
-- CROSSHAIR (FIXED)
-- =========================
local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "RF_Crosshair"
CrosshairGui.ResetOnSpawn = false
CrosshairGui.Enabled = false
CrosshairGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Dot = Instance.new("Frame")
Dot.Size = UDim2.fromOffset(6,6)
Dot.Position = UDim2.fromScale(0.5,0.5)
Dot.AnchorPoint = Vector2.new(0.5,0.5)
Dot.BackgroundColor3 = Color3.new(1,1,1)
Dot.BorderSizePixel = 0
Dot.Parent = CrosshairGui

Instance.new("UICorner", Dot).CornerRadius = UDim.new(1,0)

-- =========================
-- VISUAL TAB (ASLI, FIXED)
-- =========================
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateToggle({
    Name = "Highlight Survivor & Killer",
    CurrentValue = false,
    Callback = highlightTeams
})

VisualTab:CreateToggle({
    Name = "Highlight Generator",
    Callback = function(v)
        highlightByName("Generator", Color3.fromRGB(255,255,0), v, Highlights.Generator)
    end
})

VisualTab:CreateToggle({
    Name = "Highlight Hook",
    Callback = function(v)
        highlightByName("Hook", Color3.fromRGB(255,0,255), v, Highlights.Hook)
    end
})

VisualTab:CreateToggle({
    Name = "Highlight Window",
    Callback = function(v)
        highlightByName("Window", Color3.fromRGB(0,170,255), v, Highlights.Window)
    end
})

VisualTab:CreateToggle({
    Name = "Highlight Event / Gift",
    Callback = function(v)
        highlightByName("Gift", Color3.fromRGB(255,215,0), v, Highlights.Gift)
    end
})

VisualTab:CreateToggle({
    Name = "Crosshair",
    Callback = function(v)
        CrosshairGui.Enabled = v
    end
})
