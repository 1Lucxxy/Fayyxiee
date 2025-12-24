--// Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Settings
local Settings = {
    Aimbot = false,
    SilentAim = false,
    POVLock = false,
    TeamCheck = true,

    FOV = 150,
    Smoothness = 0.15,
    TargetPart = "Head",
    Priority = "Closest Crosshair",

    Hitbox = false,
    HitboxSize = 6
}

--// FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 100
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0,255,0)
FOVCircle.Transparency = 1

--// UI
local Window = Rayfield:CreateWindow({
    Name = "Rayfield Combat System",
    LoadingTitle = "Loading",
    LoadingSubtitle = "Aimbot + Hitbox",
    ConfigurationSaving = {Enabled = false}
})

local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Aimbot",
    Callback = function(v) Settings.Aimbot = v end
})

CombatTab:CreateToggle({
    Name = "Silent Aim",
    Callback = function(v) Settings.SilentAim = v end
})

CombatTab:CreateToggle({
    Name = "POV Lock",
    Callback = function(v) Settings.POVLock = v end
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Callback = function(v) Settings.TeamCheck = v end
})

CombatTab:CreateSlider({
    Name = "FOV",
    Range = {50,500},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(v) Settings.FOV = v end
})

CombatTab:CreateSlider({
    Name = "Smooth Aim",
    Range = {0,1},
    Increment = 0.05,
    CurrentValue = 0.15,
    Callback = function(v) Settings.Smoothness = v end
})

CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head","HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(v) Settings.TargetPart = v end
})

CombatTab:CreateDropdown({
    Name = "Target Priority",
    Options = {"Closest Crosshair","Closest Distance","Lowest Health"},
    CurrentOption = "Closest Crosshair",
    Callback = function(v) Settings.Priority = v end
})

--// HITBOX TAB
local HitboxTab = Window:CreateTab("Hitbox", 4483362458)

HitboxTab:CreateToggle({
    Name = "Hitbox Extender",
    Callback = function(v) Settings.Hitbox = v end
})

HitboxTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {2,15},
    Increment = 1,
    CurrentValue = 6,
    Callback = function(v) Settings.HitboxSize = v end
})

--// Utility
local function ValidTarget(plr)
    if plr == LocalPlayer then return false end
    if Settings.TeamCheck and plr.Team == LocalPlayer.Team then return false end
    if not plr.Character then return false end
    local hum = plr.Character:FindFirstChild("Humanoid")
    local part = plr.Character:FindFirstChild(Settings.TargetPart)
    return hum and hum.Health > 0 and part
end

local function GetTarget()
    local best, bestValue = nil, math.huge

    for _,plr in pairs(Players:GetPlayers()) do
        if ValidTarget(plr) then
            local part = plr.Character[Settings.TargetPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end

            local crossDist = (Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
            if crossDist > Settings.FOV then continue end

            local value =
                Settings.Priority == "Closest Crosshair" and crossDist or
                Settings.Priority == "Closest Distance" and
                (Camera.CFrame.Position-part.Position).Magnitude or
                plr.Character.Humanoid.Health

            if value < bestValue then
                bestValue = value
                best = part
            end
        end
    end

    return best
end

--// Silent Aim
local old
old = hookmetamethod(game,"__namecall",function(self,...)
    local args = {...}
    if Settings.SilentAim and getnamecallmethod()=="FindPartOnRayWithIgnoreList" then
        local target = GetTarget()
        if target then
            args[1] = Ray.new(Camera.CFrame.Position,(target.Position-Camera.CFrame.Position).Unit*1000)
            return old(self,unpack(args))
        end
    end
    return old(self,...)
end)

--// Render
RunService.RenderStepped:Connect(function()
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Position = Vector2.new(Mouse.X,Mouse.Y)

    if Settings.Aimbot then
        local t = GetTarget()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position,t.Position),
                Settings.Smoothness
            )
        end
    end

    if Settings.POVLock then
        local t = GetTarget()
        if t then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position,t.Position)
        end
    end

    -- Hitbox Extender
    for _,plr in pairs(Players:GetPlayers()) do
        if ValidTarget(plr) then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Size = Settings.Hitbox and
                    Vector3.new(Settings.HitboxSize,Settings.HitboxSize,Settings.HitboxSize)
                    or Vector3.new(2,2,1)
                root.Transparency = Settings.Hitbox and 0.5 or 1
                root.CanCollide = false
            end
        end
    end
end)
