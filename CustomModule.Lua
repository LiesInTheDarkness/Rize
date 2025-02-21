-- CustomModule.lua -- Updated module with error checking and debug logs
local CustomModule = {}

function CustomModule.AddCustomStuff(UI)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    if not player then
        warn("[CustomModule] LocalPlayer is nil. Ensure this is run as a LocalScript.")
        return
    end

    local character = player.Character or player.CharacterAdded:Wait()
    if not character then
        warn("[CustomModule] Character not found for LocalPlayer.")
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local defaultSpeed = (humanoid and humanoid.WalkSpeed) or 16

    print("[CustomModule] Creating tab 'Test1'")
    local Tab1 = UI:CreateTab("Test1")
    UI:CreateButton(Tab1, "Something", function() 
        print("[CustomModule] 'Something' button clicked")
    end)
    
    UI:CreateSlider(Tab1, "Walk Speed", 0, 100, defaultSpeed, function(val)
        if humanoid then
            humanoid.WalkSpeed = val
            print("[CustomModule] Updated WalkSpeed to", val)
        end
    end)
    
    UI:CreateToggle(Tab1, "Tes", false, function(state)
        print("[CustomModule] Toggle 'Tes' state:", state)
    end)
    
    print("[CustomModule] Creating tab 'Test'")
    local Tab2 = UI:CreateTab("Test")
    UI:CreateButton(Tab2, "Another Custom Button", function()
        print("[CustomModule] 'Another Custom Button' clicked!")
    end)
end

return CustomModule