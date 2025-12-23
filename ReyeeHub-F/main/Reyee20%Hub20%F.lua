--// Text Select Map Loader
--// Click text -> GUI closes -> loadstring runs

local CoreGui = game:GetService("CoreGui")

-- Remove old GUI
pcall(function()
    CoreGui:FindFirstChild("TextMapSelector"):Destroy()
end)

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TextMapSelector"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 260, 0, 220)
Frame.Position = UDim2.new(0.5, -130, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
Frame.Active = true
Frame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SELECT MAP / GAME"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1

-- Container
local List = Instance.new("Frame", Frame)
List.Size = UDim2.new(1, -20, 1, -50)
List.Position = UDim2.new(0, 10, 0, 45)
List.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0, 12)

-- =========================
-- MAP / GAME LIST
-- =========================
local Maps = {
    {
        name = "Violence District",
        url = "https://raw.githubusercontent.com/1Lucxxy/Fayyxiee/refs/heads/main/Script-Games/main/violencedistrict.lua"
    },
    {
        name = "aimbot",
        url = "https://raw.githubusercontent.com/1Lucxxy/Fayyxiee/refs/heads/main/Script-Games/main/aimbot.lua"
    },
    {
        name = "Snow Map",
        url = "https://raw.githubusercontent.com/USERNAME/snow.lua"
    }
}

-- =========================
-- CREATE TEXT BUTTON
-- =========================
for _, map in ipairs(Maps) do
    local TextBtn = Instance.new("TextButton", List)
    TextBtn.Size = UDim2.new(1, 0, 0, 30)
    TextBtn.Text = map.name
    TextBtn.Font = Enum.Font.Gotham
    TextBtn.TextSize = 13
    TextBtn.TextColor3 = Color3.fromRGB(220,220,220)
    TextBtn.BackgroundTransparency = 1
    TextBtn.TextXAlignment = Enum.TextXAlignment.Left

    TextBtn.MouseEnter:Connect(function()
        TextBtn.TextColor3 = Color3.fromRGB(0,170,255)
    end)

    TextBtn.MouseLeave:Connect(function()
        TextBtn.TextColor3 = Color3.fromRGB(220,220,220)
    end)

    TextBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        task.wait(0.1)
        loadstring(game:HttpGet(map.url))()
    end)
end
