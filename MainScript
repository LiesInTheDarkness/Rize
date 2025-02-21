-- MainScript.lua
-- Entry point for your Rize UI system.
-- Replace the URLs with your actual GitHub raw URLs if needed.
local HttpService = game:GetService("HttpService")

local UiLibURL = "https://raw.githubusercontent.com/LiesInTheDarkness/YourRepo/main/UiLib.lua"
local CustomModuleURL = "https://raw.githubusercontent.com/LiesInTheDarkness/YourRepo/main/CustomModule.lua"

local RizeUI = loadstring(game:HttpGet(UiLibURL))()
local CustomModule = loadstring(game:HttpGet(CustomModuleURL))()

-- Create the UI instance
local UI = RizeUI.new()

-- Define saving and loading functions in MainScript
function UI:SaveSettings()
    local success, err = pcall(function()
        writefile("RizeSetting.json", HttpService:JSONEncode(self.Settings))
    end)
    if not success then
        warn("[MainScript] Could not save settings:", err)
    end
end

function UI:LoadSettings()
    if isfile and isfile("RizeSetting.json") then
        local data = readfile("RizeSetting.json")
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success and decoded then
            self.Settings = decoded
        end
    end
end

-- Load previously saved settings, if any
UI:LoadSettings()

-- Use the CustomModule to add your custom UI elements
CustomModule.AddCustomStuff(UI)

print("[MainScript] Rize UI loaded successfully!")
