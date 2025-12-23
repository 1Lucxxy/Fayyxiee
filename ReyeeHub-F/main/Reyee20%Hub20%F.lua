--================================
-- TEXT MAP SELECTOR (BUG FIX)
--================================

local CoreGui = game:GetService("CoreGui")

pcall(function()
    CoreGui:FindFirstChild("TextMapSelector"):Destroy()
end)

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "TextMapSelector"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,280,0,240)
Frame.Position = UDim2.new(0.5,-140,0.5,-120)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
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
List.Position = UDim2.new(0,15,0,45)
List.Size = UDim2.new(1,-30,1,-55)
List.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0,12)

--========================
-- MAP LIST (CEK DISINI)
--========================
local Maps = {
    {
        name = "Violence Dsistrict",
        url  = "https://raw.githubusercontent.com/1Lucxxy/Fayyxiee/refs/heads/main/Script-Games/main/aimbot.lua"
    },
    {
        name = "Aimbot",
        url  = "https://raw.githubusercontent.com/1Lucxxy/Fayyxiee/refs/heads/main/Script-Games/main/aimbot.lua"
    }
}

--========================
-- CREATE BUTTON
--========================
for i, map in ipairs(Maps) do
    -- VALIDASI DATA
    if type(map.name) ~= "string" or type(map.url) ~= "string" then
        warn("Map data invalid at index:", i)
        continue
    end

    local Btn = Instance.new("TextButton", List)
    Btn.Size = UDim2.new(1,0,0,30)
    Btn.Text = map.name
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.TextColor3 = Color3.fromRGB(220,220,220)
    Btn.BackgroundTransparency = 1
    Btn.AutoButtonColor = false

    Btn.MouseEnter:Connect(function()
        Btn.TextColor3 = Color3.fromRGB(0,170,255)
    end)

    Btn.MouseLeave:Connect(function()
        Btn.TextColor3 = Color3.fromRGB(220,220,220)
    end)

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "Loading..."

        ScreenGui:Destroy()

        task.spawn(function()
            local ok, err = pcall(function()
                local src = game:HttpGet(map.url)
                loadstring(src)()
            end)

            if not ok then
                warn("Load error:", err)
            end
        end)
    end)
end
