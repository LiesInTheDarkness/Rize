-- CustomModule.lua
-- Example module to create custom UI elements using the Rize UI Library instance.
local CustomModule = {}

function CustomModule.AddCustomStuff(UI)
    -- Create a custom tab and add elements with custom names
    local Tab1 = UI:CreateTab("Custom Tab 1")
    UI:CreateButton(Tab1, "My Custom Button", function()
        print("[CustomModule] My Custom Button clicked!")
    end)
    UI:CreateSlider(Tab1, "My Custom Slider", 0, 100, 50, function(val)
        print("[CustomModule] My Custom Slider value:", val)
    end)
    UI:CreateToggle(Tab1, "My Custom Toggle", false, function(state)
        print("[CustomModule] My Custom Toggle state:", state)
    end)

    -- Create another custom tab with additional elements
    local Tab2 = UI:CreateTab("Custom Tab 2")
    UI:CreateButton(Tab2, "Another Custom Button", function()
        print("[CustomModule] Another Custom Button clicked!")
    end)
end

return CustomModule
