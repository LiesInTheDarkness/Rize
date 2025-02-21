-- MainScript.lua -- Entry point for your Rize UI system
local HttpService = game:GetService("HttpService")
local UiLibURL = "https://raw.githubusercontent.com/LiesInTheDarkness/Rize/refs/heads/main/UiLib.lua"
local CustomModuleURL = "https://raw.githubusercontent.com/LiesInTheDarkness/Rize/refs/heads/main/CustomModule.Lua"

local RizeUI = loadstring(game:HttpGet(UiLibURL))()
local CustomModule = loadstring(game:HttpGet(CustomModuleURL))()

if not RizeUI then
    error("[MainScript] Failed to load UI Library")
end

if not CustomModule then
    error("[MainScript] Failed to load Custom Module")
end

local UI = RizeUI.new()
print("[MainScript] UI instance created")

function UI:SaveSettings()
    local success, err = pcall(function() 
        writefile("Rize/Setting.json", HttpService:JSONEncode(self.Settings))
    end)
    if not success then
        warn("[MainScript] Could not save settings:", err)
    end
end

function UI:LoadSettings()
    if isfile and isfile("Rize/Setting.json") then
        local data = readfile("Rize/Setting.json")
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success and decoded then
            self.Settings = decoded
        end
    end
end

UI:LoadSettings()
print("[MainScript] Settings loaded")

CustomModule.AddCustomStuff(UI)
print("[MainScript] Custom module executed")
print("[MainScript] Rize UI loaded successfully!")