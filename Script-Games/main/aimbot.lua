-- Load Rayfield (pastikan URL bisa diakses dari executor mu)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Membuat Window
local Window = Rayfield:CreateWindow({
    Name = "Camera Follow Script",
    LoadingTitle = "Camera Follow",
    LoadingSubtitle = "by Dafaaa",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "CameraFollowConfig"
    },
    Discord = {
       Enabled = false,
    },
    KeySystem = false
})

-- Tab Camera
local CameraTab = Window:CreateTab("Camera", 4483362458)

-- Variables
local CameraFollowToggle = false
local TargetPlayerName = nil
local SmoothSpeed = 0.1 -- semkin kecil semakin smooth

-- Input untuk nama player target
CameraTab:CreateInput({
    Name = "Target Player",
    PlaceholderText = "Masukkan nama player",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        TargetPlayerName = Value
    end
})

-- Toggle untuk mengaktifkan camera follow
CameraTab:CreateToggle({
    Name = "Follow Player",
    CurrentValue = false,
    Flag = "FollowToggle",
    Callback = function(Value)
        CameraFollowToggle = Value
        if not Value then
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom -- reset camera
        end
    end
})

-- Loop untuk update camera setiap frame
game:GetService("RunService").RenderStepped:Connect(function(delta)
    if CameraFollowToggle and TargetPlayerName then
        local targetPlayer = game.Players:FindFirstChild(TargetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local cam = workspace.CurrentCamera
            cam.CameraType = Enum.CameraType.Scriptable

            -- Smooth CFrame
            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            local currentPos = cam.CFrame.Position
            local direction = (targetPos - currentPos)
            local newPos = currentPos + direction * SmoothSpeed
            cam.CFrame = CFrame.new(newPos, targetPos)
        else
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    else
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end)

-- Optional: Label untuk test GUI muncul
CameraTab:CreateLabel("GUI aktif ✅")
