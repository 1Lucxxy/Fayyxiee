-- Pastikan Rayfield sudah disertakan di projectmu
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "Camera Follow Script",
    LoadingTitle = "Camera Follow",
    LoadingSubtitle = "by Dafaaa",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- folder penyimpanan
       FileName = "CameraFollowConfig"
    },
    Discord = {
       Enabled = false,
    },
    KeySystem = false
})

-- Toggle untuk mengaktifkan/mematikan camera follow
local CameraFollowToggle = false
local TargetPlayerName = nil

-- Tab Combat
local CombatTab = Window:CreateTab("Camera", 4483362458)

-- Input untuk memilih target player
CombatTab:CreateInput({
    Name = "Target Player",
    PlaceholderText = "Masukkan nama player",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        TargetPlayerName = Value
    end
})

-- Toggle untuk mengikuti player
CombatTab:CreateToggle({
    Name = "Follow Player",
    CurrentValue = false,
    Flag = "FollowToggle",
    Callback = function(Value)
        CameraFollowToggle = Value
    end
})

-- Loop untuk update camera
game:GetService("RunService").RenderStepped:Connect(function()
    if CameraFollowToggle and TargetPlayerName then
        local targetPlayer = game.Players:FindFirstChild(TargetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local cam = workspace.CurrentCamera
            cam.CameraType = Enum.CameraType.Scriptable
            cam.CFrame = CFrame.new(cam.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
        else
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    else
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end)
