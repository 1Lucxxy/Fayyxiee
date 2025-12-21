--==================================================
-- RAYFIELD
--==================================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local TeamsService = game:GetService("Teams")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- WINDOW & TABS
--==================================================
local Window = Rayfield:CreateWindow({
    Name = "ESP FINAL (FIXED)",
    LoadingTitle = "Loading",
    LoadingSubtitle = "No FPS Drop",
    ConfigurationSaving = {Enabled=false}
})

local ESPTab    = Window:CreateTab("ESP", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab   = Window:CreateTab("Misc", 4483362458)

--==================================================
-- PLAYER ESP (EVENT BASED)
--==================================================
local PlayerESPEnabled = false
local PlayerHighlights = {}

local function clearPlayerESP()
    for _,h in pairs(PlayerHighlights) do
        if h then h:Destroy() end
    end
    table.clear(PlayerHighlights)
end

local function applyPlayerESP(plr)
    if plr == LocalPlayer then return end

    plr.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        if not PlayerESPEnabled or not plr.Team then return end

        local h = Instance.new("Highlight")
        h.Adornee = char
        h.FillTransparency = 0.8
        h.OutlineTransparency = 1

        if string.lower(plr.Team.Name) == "killer" then
            h.FillColor = Color3.fromRGB(255,0,0)
        elseif string.lower(plr.Team.Name) == "survivors" then
            h.FillColor = Color3.fromRGB(0,255,0)
        else
            return
        end

        h.Parent = char
        PlayerHighlights[plr] = h
    end)
end

for _,p in ipairs(Players:GetPlayers()) do
    applyPlayerESP(p)
end
Players.PlayerAdded:Connect(applyPlayerESP)

ESPTab:CreateToggle({
    Name = "ESP Survivor & Killer",
    Callback = function(v)
        PlayerESPEnabled = v
        if not v then clearPlayerESP() end
    end
})

--==================================================
-- OBJECT ESP (FIXED TOTAL)
--==================================================
local ObjectESP = {
    Generator = {Color=Color3.fromRGB(255,255,0), Items={}},
    Hook      = {Color=Color3.fromRGB(255,0,255), Items={}},
    Window    = {Color=Color3.fromRGB(0,170,255), Items={}},
    Gift      = {Color=Color3.fromRGB(255,165,0), Items={}}
}

local function clearObjectESP(name)
    for _,h in ipairs(ObjectESP[name].Items) do
        if h then h:Destroy() end
    end
    ObjectESP[name].Items = {}
end

local function scanObjectESP(name)
    clearObjectESP(name)

    for _,v in ipairs(workspace:GetDescendants()) do
        if (v:IsA("Model") or v:IsA("MeshPart")) and v.Name == name then
            local h = Instance.new("Highlight")
            h.Adornee = v
            h.FillColor = ObjectESP[name].Color
            h.FillTransparency = 0.8
            h.OutlineTransparency = 1
            h.Parent = v
            table.insert(ObjectESP[name].Items, h)
        end
    end
end

ESPTab:CreateToggle({
    Name = "Generator",
    Callback = function(v)
        if v then scanObjectESP("Generator") else clearObjectESP("Generator") end
    end
})

ESPTab:CreateToggle({
    Name = "Hook",
    Callback = function(v)
        if v then scanObjectESP("Hook") else clearObjectESP("Hook") end
    end
})

ESPTab:CreateToggle({
    Name = "Window",
    Callback = function(v)
        if v then scanObjectESP("Window") else clearObjectESP("Window") end
    end
})

ESPTab:CreateToggle({
    Name = "Event / Gift",
    Callback = function(v)
        if v then scanObjectESP("Gift") else clearObjectESP("Gift") end
    end
})

--==================================================
-- CROSSHAIR
--==================================================
local Crosshair = Drawing.new("Circle")
Crosshair.Radius = 2
Crosshair.Filled = true
Crosshair.Color = Color3.fromRGB(255,255,255)
Crosshair.Visible = false
local CrosshairEnabled = false

ESPTab:CreateToggle({
    Name="Crosshair Dot",
    Callback=function(v)
        CrosshairEnabled=v
        Crosshair.Visible=v
    end
})

RunService.RenderStepped:Connect(function()
    if CrosshairEnabled then
        Crosshair.Position = Vector2.new(
            Camera.ViewportSize.X/2,
            Camera.ViewportSize.Y/2
        )
    end
end)

--==================================================
-- PLAYER : WALKSPEED TOGGLE
--==================================================
local WalkSpeedEnabled = false
local SpeedValue = 32

local function applySpeed(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = WalkSpeedEnabled and SpeedValue or 16
    end
end

PlayerTab:CreateToggle({
    Name="WalkSpeed",
    Callback=function(v)
        WalkSpeedEnabled=v
        applySpeed(LocalPlayer.Character)
    end
})

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    applySpeed(char)
end)

--==================================================
-- NOCLIP (NO LOOP)
--==================================================
local NoclipEnabled = false
local CachedParts = {}

local function cacheParts(char)
    CachedParts = {}
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(CachedParts, v)
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    cacheParts(char)
end)

MiscTab:CreateToggle({
    Name="Noclip",
    Callback=function(v)
        NoclipEnabled=v
        for _,p in ipairs(CachedParts) do
            p.CanCollide = not v
        end
    end
})

--==================================================
-- MISC : CEK TEAM MAP
--==================================================
MiscTab:CreateButton({
    Name="Cek Team di Map",
    Callback=function()
        local txt="Team di map:\n"
        for _,t in ipairs(TeamsService:GetTeams()) do
            local c=0
            for _,p in ipairs(Players:GetPlayers()) do
                if p.Team==t then c+=1 end
            end
            txt..="- "..t.Name.." : "..c.." player\n"
        end
        Rayfield:Notify({Title="Team Info",Content=txt,Duration=8})
        print(txt)
    end
})

--==================================================
-- MISC : CEK MODEL SEKITAR (5 STUDS)
--==================================================
MiscTab:CreateButton({
    Name="Cek Model Sekitar",
    Callback=function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local found,txt={}, "Model sekitar:\n"
        for _,v in ipairs(workspace:GetChildren()) do
            if v:IsA("Model") and v.PrimaryPart then
                if (v.PrimaryPart.Position-hrp.Position).Magnitude<=5 and not found[v.Name] then
                    found[v.Name]=true
                    txt..="- "..v.Name.."\n"
                end
            end
        end
        Rayfield:Notify({Title="Nearby",Content=txt,Duration=8})
        print(txt)
    end
})
