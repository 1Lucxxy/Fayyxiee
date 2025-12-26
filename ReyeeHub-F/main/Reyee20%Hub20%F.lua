-- Third Party Script Selector Executor (Scrollable)

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
Frame.Size = UDim2.new(0, 320, 0, 260)
Frame.Position = UDim2.new(0.5, -160, 0.5, -130)
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

-- ScrollingFrame
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarImageTransparency = 0
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.Parent = Frame

-- UIListLayout (auto rapih)
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 10)
Layout.Parent = Scroll

-- SCRIPT LIST (TAMBAH DI SINI)
local Scripts = {
    {
        Name = "Fly",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        end
    },
    {
        Name = "Violence District",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1Lucxxy/Fayyxiee/refs/heads/main/Script-Games/main/violencedistrict.lua"))()
        end
    },
    {
        Name = "Forsaken",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/34f3f/forsaken.github.io/refs/heads/main/ringtabublik.lua"))()
        end
    },
    {
        Name = "Duelling",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/NysaDanielle/loader/refs/heads/main/auth"))()
        end
    },
    {
        Name = "Gunung",
        Callback = function()
            loadstring(game:HttpGet("https://bantaigunung.my.id/script/BantaiXmarV.lua"))()
        end
    },
    {
        Name = "AimbotToggle",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1Lucxxy/Fayyxiee/refs/heads/main/Script-Games/main/toggleaimbot.lua"))()
        end
    },
    {
        Name = "Combat",
        Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/CZWxFoTG/raw"))()
        end
    },
    {
        Name = "Ink Game",
        Callback = function()
            shared.CustomCommit = "8dd5a2e401a7624d73c2fbf1cd3376ff9d363b89"
shared.TestingMode = true
shared.StagingMode = true
shared.BYPASS_VW_PROTECTION = true
loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/inkgame.lua", true))()
        end
    }
}

-- Create Buttons
for _, data in ipairs(Scripts) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.Text = data.Name
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Parent = Scroll

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

    Button.MouseButton1Click:Connect(function()
        pcall(data.Callback)
        ScreenGui:Destroy()
    end)
end

-- Auto resize canvas
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)
