--==================================
-- RAYFIELD LOAD
--==================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--==================================
-- SERVICES
--==================================
local Players = game:GetService("Players")
local TeamsService = game:GetService("Teams")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================
-- WINDOW & TABS
--==================================
local Window = Rayfield:CreateWindow({
    Name = "ESP Highlight (Ultimate)",
    LoadingTitle = "ESP System",
    LoadingSubtitle = "Final + Debug Tools",
    ConfigurationSaving = { Enabled = false }
})

local ESPTab  = Window:CreateTab("ESP", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

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
-- PLAYER ESP (TEAM BASED ✔)
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
                addHighlight(plr.Character, Color3.fromRGB(255,0,0))
            elseif teamName == "survivors" then
                addHighlight(plr.Character, Color3.fromRGB(0,255,0))
            end
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        updatePlayers()
    end
end)

ESPTab:CreateToggle({
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
-- OBJECT ESP TOGGLES
--==================================
ESPTab:CreateToggle({
    Name = "Highlight Generator",
    Callback = function(v)
        if v then highlightCached("Generator", Color3.fromRGB(255,255,0))
        else clearHighlights() end
    end
})

ESPTab:CreateToggle({
    Name = "Highlight Hook",
    Callback = function(v)
        if v then highlightCached("Hook", Color3.fromRGB(255,0,255))
        else clearHighlights() end
    end
})

ESPTab:CreateToggle({
    Name = "Highlight Window",
    Callback = function(v)
        if v then highlightCached("Window", Color3.fromRGB(0,170,255))
        else clearHighlights() end
    end
})

ESPTab:CreateToggle({
    Name = "Highlight Event (Gift)",
    Callback = function(v)
        if v then highlightCached("Gift", Color3.fromRGB(255,140,0))
        else clearHighlights() end
    end
})

--==================================
-- CROSSHAIR DOT
--==================================
local CrosshairEnabled = false

local Crosshair = Drawing.new("Circle")
Crosshair.Radius = 2
Crosshair.Filled = true
Crosshair.Thickness = 1
Crosshair.Color = Color3.fromRGB(255,255,255)
Crosshair.Visible = false

ESPTab:CreateToggle({
    Name = "Crosshair Dot",
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

--==================================
-- MISC : CEK TEAM MAP
--==================================
MiscTab:CreateButton({
    Name = "Cek Team (Map)",
    Callback = function()
        local teams = TeamsService:GetTeams()
        local result = "Team di map ini:\n"

        if #teams == 0 then
            result = "Tidak ada TeamService di map ini"
        else
            for _,team in ipairs(teams) do
                local count = 0
                for _,plr in ipairs(Players:GetPlayers()) do
                    if plr.Team == team then
                        count += 1
                    end
                end
                result ..= "- " .. team.Name .. " : " .. count .. " player\n"
            end
        end

        Rayfield:Notify({
            Title = "Cek Team",
            Content = result,
            Duration = 8
        })

        print("===== TEAM MAP CHECK =====")
        print(result)
    end
})

--==================================
-- MISC : CEK MODEL SEKITAR PLAYER (5 STUDS)
--==================================
MiscTab:CreateButton({
    Name = "Cek Model Sekitar (5 studs)",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local found = {}
        local result = "Model sekitar (5 studs):\n"

        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.PrimaryPart then
                local dist = (v.PrimaryPart.Position - hrp.Position).Magnitude
                if dist <= 5 then
                    if not found[v.Name] then
                        found[v.Name] = true
                        result ..= "- " .. v.Name .. "\n"
                    end
                end
            end
        end

        if result == "Model sekitar (5 studs):\n" then
            result ..= "Tidak ada model"
        end

        Rayfield:Notify({
            Title = "Cek Model Sekitar",
            Content = result,
            Duration = 8
        })

        print("===== MODEL NEAR PLAYER =====")
        print(result)
    end
})
