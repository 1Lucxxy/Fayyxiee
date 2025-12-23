-- BASIC ORION TEST
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "Orion Test",
    HidePremium = false,
    SaveConfig = false
})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "Hello World",
    Callback = function()
        print("ORION WORKING")
    end
})

OrionLib:Init()
