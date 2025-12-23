--// FIXED Text Map Loader

local CoreGui = game:GetService("CoreGui")

pcall(function()
    CoreGui:FindFirstChild("TextMapSelector"):Destroy()
end)

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "TextMapSelector"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,260,0,220)
Frame.Position = UDim2.new(0.5,-130,0.5,-110)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "SELECT MAP"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

local List = Instance.new("Frame", Frame)
List.Size = UDim2.new(1,-20,1,-50)
List.Position = UDim2.new(0,10,0,45)
List.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0,10)

-- ======================
-- MAP LIST (PASTIKAN RAW)
-- ======================
local Maps = {
    {
        name = "Map 1",
        url = "https://raw.githubusercontent.com/USER/REPO/main/map1.lua"
    },
    {
        name = "Map 2",
        url = "https://raw.githubusercontent.com/USER/REPO/main/map2.lua"
    },
    {
        name = "Map 3",
        url = "https://raw.githubusercontent.com/USER/REPO/main/map3.lua"
    }
}

-- ======================
-- CREATE TEXT SELECT
-- ======================
for _, map in ipairs(Maps) do
    local Btn = Instance.new("TextButton", List)
    Btn.Size = UDim2.new(1,0,0,30)
    Btn.Text = map.name
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.TextColor3 = Color3.fromRGB(220,220,220)
    Btn.BackgroundTransparency = 1

    Btn.MouseEnter:Connect(function()
        Btn.TextColor3 = Color3.fromRGB(0,170,255)
    end)

    Btn.MouseLeave:Connect(function()
        Btn.TextColor3 = Color3.fromRGB(220,220,220)
    end)

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "Loading..."

        local success, err = pcall(function()
            local src = game:HttpGet(map.url)
            loadstring(src)()
        end)

        if success then
            ScreenGui:Destroy()
        else
            Btn.Text = "ERROR (check link)"
            warn("Map load error:", err)
            task.wait(1.5)
            Btn.Text = map.name
        end
    end)
end
