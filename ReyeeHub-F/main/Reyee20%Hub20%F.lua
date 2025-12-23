--========================================
-- SIMPLE TEXT MAP SELECTOR (RESET TOTAL)
--========================================

local CoreGui = game:GetService("CoreGui")

-- hapus gui lama
pcall(function()
    CoreGui:FindFirstChild("MapSelectorGui"):Destroy()
end)

--====================
-- GUI
--====================
local gui = Instance.new("ScreenGui")
gui.Name = "MapSelectorGui"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 200)
frame.Position = UDim2.new(0.5, -130, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "SELECT MAP"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1

local list = Instance.new("Frame", frame)
list.Position = UDim2.new(0,10,0,40)
list.Size = UDim2.new(1,-20,1,-50)
list.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,8)

--====================
-- MAP DATA (INI SAJA YANG DI EDIT)
--====================
local Maps = {
    ["MAP A"] = "https://raw.githubusercontent.com/USER/REPO/main/mapA.lua",
    ["MAP B"] = "https://raw.githubusercontent.com/USER/REPO/main/mapB.lua",
    ["MAP C"] = "https://raw.githubusercontent.com/USER/REPO/main/mapC.lua",
}

-- DEBUG (WAJIB ADA)
print("MAP COUNT:", 0)
for _ in pairs(Maps) do
    print("MAP FOUND")
end

--====================
-- BUAT TEXT BUTTON
--====================
for mapName, mapUrl in pairs(Maps) do
    local btn = Instance.new("TextButton", list)
    btn.Size = UDim2.new(1,0,0,28)
    btn.Text = mapName
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.BackgroundTransparency = 1
    btn.AutoButtonColor = false

    btn.MouseButton1Click:Connect(function()
        -- CLOSE GUI DULU
        gui:Destroy()

        -- LOAD SCRIPT
        task.spawn(function()
            local ok, err = pcall(function()
                local src = game:HttpGet(mapUrl)
                loadstring(src)()
            end)

            if not ok then
                warn("LOAD ERROR:", err)
            end
        end)
    end)
end
