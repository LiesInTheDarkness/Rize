local CustomModule = {}

function CustomModule.AddCustomStuff(UI)
    local player = game:GetService("Players").LocalPlayer
    if not player then
        warn("LocalPlayer is nil. CustomModule.AddCustomStuff requires a LocalScript with a valid LocalPlayer.")
        return
    end

    local character = player.Character or player.CharacterAdded:Wait()
    if not character then
        warn("Character not found for LocalPlayer")
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local defaultSpeed = (humanoid and humanoid.WalkSpeed) or 16

    -- Create a custom tab and add elements with custom names
    local Tab1 = UI:CreateTab("Test1")
    UI:CreateButton(Tab1, "Something", function() end)

    UI:CreateSlider(Tab1, "Walk Speed", 0, 100, defaultSpeed, function(val)
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