--==================================
-- RAYFIELD LOAD
--==================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--==================================
-- SERVICES
--==================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================
-- WINDOW
--==================================
local Window = Rayfield:CreateWindow({
    Name = "ESP Highlight (Team Based)",
    LoadingTitle = "ESP System",
    LoadingSubtitle = "Final & Stable",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("ESP", 4483362458)

--==================================
-- HIGHLIGHT CORE
--==================================
local Highlights = {}

local function addHighlight(obj, color)
    if not obj or Highlights[obj] then return end
    local h = Instance.new("Highlight")
    h.Adornee = obj
    h.FillColor = color
    h.FillTransparency = 0.8
    h.OutlineColor = Color3.new(0,0,0)
    h.OutlineTransparency = 0.2
    h.Parent = obj
    Highlights[obj] = h
end

local function clearHighlights()
    for _,h in pairs(Highlights) do
        if h then h:Destroy() end
    end
    table.clear(Highlights)
end

--==================================
-- PLAYER ESP (TEAM SYSTEM ✔)
--==================================
local PlayerESPEnabled = false

local function updatePlayers()
    if not PlayerESPEnabled then return end

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
        and plr.Team
        and plr.Character
        and plr.Character:FindFirstChild("HumanoidRootPart") then

            local teamName = string.lower(plr.Team.Name)

            if teamName == "killer" then
                addHighlight(plr.Character, Color3.fromRGB(255,0,0)) -- KILLER
            elseif teamName == "survivor" then
                addHighlight(plr.Character, Color3.fromRGB(0,255,0)) -- SURVIVOR
            end
        end
    end
end

-- update ringan
task.spawn(function()
    while task.wait(1) do
        updatePlayers()
    end
end)

Tab:CreateToggle({
    Name = "Highlight Survivor & Killer",
    CurrentValue = false,
    Callback = function(v)
        PlayerESPEnabled = v
        if not v then clearHighlights() end
    end
})

--==================================
-- MODEL CACHE (ANTI FPS DROP)
--==================================
local ModelCache = {
    Generator = {},
    Hook = {},
    Window = {},
    Gift = {}
}

-- scan SEKALI
for _,v in ipairs(workspace:GetDescendants()) do
    if v:IsA("Model") and ModelCache[v.Name] then
        table.insert(ModelCache[v.Name], v)
    end
end

local function highlightCached(name, color)
    for _,model in ipairs(ModelCache[name]) do
        addHighlight(model, color)
    end
end

--==================================
-- MODEL TOGGLES
--==================================
Tab:CreateToggle({
    Name = "Highlight Generator",
    Callback = function(v)
        if v then
            highlightCached("Generator", Color3.fromRGB(255,255,0))
        else
            clearHighlights()
        end
    end
})

Tab:CreateToggle({
    Name = "Highlight Hook",
    Callback = function(v)
        if v then
            highlightCached("Hook", Color3.fromRGB(255,0,255))
        else
            clearHighlights()
        end
    end
})

Tab:CreateToggle({
    Name = "Highlight Window",
    Callback = function(v)
        if v then
            highlightCached("Window", Color3.fromRGB(0,170,255))
        else
            clearHighlights()
        end
    end
})

Tab:CreateToggle({
    Name = "Highlight Event (Gift)",
    Callback = function(v)
        if v then
            highlightCached("Gift", Color3.fromRGB(255,140,0))
        else
            clearHighlights()
        end
    end
})

--==================================
-- CROSSHAIR DOT (TOGGLE)
--==================================
local CrosshairEnabled = false

local Crosshair = Drawing.new("Circle")
Crosshair.Radius = 2
Crosshair.Filled = true
Crosshair.Thickness = 1
Crosshair.Color = Color3.fromRGB(255,255,255)
Crosshair.Visible = false

Tab:CreateToggle({
    Name = "Crosshair Dot",
    CurrentValue = false,
    Callback = function(v)
        CrosshairEnabled = v
        Crosshair.Visible = v
    end
})

RunService.RenderStepped:Connect(function()
    if CrosshairEnabled then
        Crosshair.Position = Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )
    end
end)
