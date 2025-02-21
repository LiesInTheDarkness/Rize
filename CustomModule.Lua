-- CustomModule.lua
-- Example module to create custom UI elements using the Rize UI Library instance.
local CustomModule = {}

function CustomModule.AddCustomStuff(UI)
    local Tab1 = UI:CreateTab("Test1")
    UI:CreateButton(Tab1, "Something", function() end)
    
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local defaultSpeed = humanoid and humanoid.WalkSpeed or 16
    
    UI:CreateSlider(Tab1, "Walk Speed", 0, 100, defaultSpeed, function(val)
        if humanoid then
            humanoid.WalkSpeed = val
        end
    end)
    
    UI:CreateToggle(Tab1, "Tes", false, function(state)
        print("[CustomModule] My Custom Toggle state:", state)
    end)
    
    local Tab2 = UI:CreateTab("Test")
    UI:CreateButton(Tab2, "Another Custom Button", function()
        print("[CustomModule] Another Custom Button clicked!")
    end)
end