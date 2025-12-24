-- Third Party Script Selector Executor

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptSelectorGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 220)
Frame.Position = UDim2.new(0.5, -150, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Select Script"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)
Title.Parent = Frame

-- SCRIPT LIST (GANTI DI SINI)
local Scripts = {
    ["Violence District"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1Lucxxy/Fayyxiee/refs/heads/main/Script-Games/main/violencedistrict.lua"))()
    end,

    ["Aimbot"] = function()
        loadstring(game:HttpGet("https://pastefy.app/CZWxFoTG/raw"))()
    end,

    ["Script 3"] = function()
        print("Script 3 jalan")
        -- isi bebas
    end
}

-- Create Buttons
local y = 50
for name, callback in pairs(Scripts) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, y)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.Text = name
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Parent = Frame

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

    Button.MouseButton1Click:Connect(function()
        pcall(callback)
        ScreenGui:Destroy() -- GUI hilang setelah execute
    end)

    y = y + 50
end
