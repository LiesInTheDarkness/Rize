local CustomModule = {}

function CustomModule.AddCustomStuff(UI)

local tab1 = UI:CreateTab("Test")
local tab2 = UI:CreateTab("Dayum")

local defaultSpeed = game.StarterPlayer.CharacterWalkSpeed or 16 -- Fallback in case it's nil

Ui:CreateSlider(tab1,"Walk speed Changer",0,100,defaultspeed,function(val)

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid.WalkSpeed = val
    end
end)
    