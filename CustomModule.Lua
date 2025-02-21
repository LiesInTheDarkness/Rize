-- CustomModule.lua
-- Example module to create custom UI elements using the Rize UI Library instance.
local CustomModule = {}

function CustomModule.AddCustomStuff(UI)
    -- Create a custom tab and add elements with custom names
    local Tab1 = UI:CreateTab("Test1")
    
UI:CreateButton(Tab1, "Something", function()
    end)
    
UI:CreateSlider(Tab1, "Walk speed ", 0, 100, 50, function(val)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = val
    end
end)
    
UI:CreateToggle(Tab1, "Tes", false, function(state)
        print("[CustomModule] My Custom Toggle state:", state)
    end)

    -- Create another custom tab with additional elements
    local Tab2 = UI:CreateTab("Test")
    
UI:CreateButton(Tab2, "Another Custom Button", function()
        print("[CustomModule] Another Custom Button clicked!")
    end)
end

return CustomModule
