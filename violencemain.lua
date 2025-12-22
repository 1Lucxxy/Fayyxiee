--==================================
-- MAP LOCK : VIOLENCE DISTRICT ONLY
--==================================
local VALID_MAP = false

pcall(function()
    if string.find(string.lower(game.Name), "violence") then
        VALID_MAP = true
    end
end)

if not VALID_MAP then
    warn("[ESP] Script hanya berjalan di map: Violence District")
    return
end

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
    Name = "Violence District ESP",
    LoadingTitle = "Violence District",
    LoadingSubtitle = "ESP System Loaded",
    ConfigurationSaving = { Enabled = false }
})

local ESPTab    = Window:CreateTab("ESP", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab   = Window:CreateTab("Misc", 4483362458)

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
    h.OutlineTransparency = 1
    h.Parent = obj
    Highlights[obj] = h
end

local function removeHighlight(obj)
    if Highlights[obj] then
        Highlights[obj]:Destroy()
        Highlights[obj] = nil
    end
end

--==================================
-- PLAYER ESP
--==================================
local PlayerESPEnabled = false

task.spawn(function()
    while task.wait(1) do
        if not PlayerESPEnabled then continue end

        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer
            and plr.Team
            and plr.Character
            and plr.Character:FindFirstChild("HumanoidRootPart") then

                local team = string.lower(plr.Team.Name)
                if team == "killer" then
                    addHighlight(plr.Character, Color3.fromRGB(255,0,0))
                elseif team == "survivors" then
                    addHighlight(plr.Character, Color3.fromRGB(0,255,0))
                end
            end
        end
    end
end)

ESPTab:CreateToggle({
    Name = "Highlight Survivor & Killer",
    Callback = function(v)
        PlayerESPEnabled = v
        if not v then
            for obj,_ in pairs(Highlights) do
                if Players:GetPlayerFromCharacter(obj) then
                    removeHighlight(obj)
                end
            end
        end
    end
})

--==================================
-- OBJECT ESP CACHE
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

local function toggleModelESP(name, color, enabled)
    for _,model in ipairs(ModelCache[name]) do
        if enabled then
            addHighlight(model, color)
        else
            removeHighlight(model)
        end
    end
end

--==================================
-- OBJECT ESP TOGGLES
--==================================
ESPTab:CreateToggle({
    Name = "Highlight Generator",
    Callback = function(v)
        toggleModelESP("Generator", Color3.fromRGB(255,255,0), v)
    end
})

ESPTab:CreateToggle({
    Name = "Highlight Hook",
    Callback = function(v)
        toggleModelESP("Hook", Color3.fromRGB(255,0,255), v)
    end
})

ESPTab:CreateToggle({
    Name = "Highlight Window",
    Callback = function(v)
        toggleModelESP("Window", Color3.fromRGB(0,170,255), v)
    end
})

ESPTab:CreateToggle({
    Name = "Highlight Event (Gift)",
    Callback = function(v)
        toggleModelESP("Gift", Color3.fromRGB(255,140,0), v)
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
-- PLAYER TAB : WALKSPEED ONLY
--==================================
local WalkSpeedEnabled = false
local WalkSpeedValue = 16

local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16,150},
    Increment = 1,
    CurrentValue = WalkSpeedValue,
    Callback = function(v)
        WalkSpeedValue = v
    end
})

PlayerTab:CreateToggle({
    Name = "Enable WalkSpeed",
    Callback = function(v)
        WalkSpeedEnabled = v
        WalkSpeedSlider:SetDisabled(not v)
    end
})

task.defer(function()
    WalkSpeedSlider:SetDisabled(true)
end)

RunService.Heartbeat:Connect(function()
    if WalkSpeedEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = WalkSpeedValue end
    end
end)

--==================================
-- MISC : CEK TEAM MAP
--==================================
MiscTab:CreateButton({
    Name = "Cek Team (Map)",
    Callback = function()
        local teams = TeamsService:GetTeams()
        local text = "Team di map:\n"

        for _,team in ipairs(teams) do
            local count = 0
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr.Team == team then count += 1 end
            end
            text ..= "- "..team.Name.." : "..count.." player\n"
        end

        Rayfield:Notify({
            Title = "Violence District",
            Content = text,
            Duration = 8
        })
    end
})

--==================================
-- MISC : CEK MODEL 5 STUDS
--==================================
MiscTab:CreateButton({
    Name = "Cek Model Sekitar (5 studs)",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local found = {}
        local result = "Model sekitar:\n"

        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.PrimaryPart then
                if (v.PrimaryPart.Position - hrp.Position).Magnitude <= 5 and not found[v.Name] then
                    found[v.Name] = true
                    result ..= "- "..v.Name.."\n"
                end
            end
        end

        if result == "Model sekitar:\n" then
            result ..= "Tidak ada model"
        end

        Rayfield:Notify({
            Title = "Cek Model",
            Content = result,
            Duration = 8
        })
    end
})
