local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Test",
   LoadingTitle = "Loading UI",
   LoadingSubtitle = "by dafaaa",
   ConfigurationSaving = {
      Enabled = false
   }
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateButton({
   Name = "Hello",
   Callback = function()
      print("Rayfield works!")
   end,
})
