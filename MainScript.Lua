-- MainScript.lua -- Entry point for the Rize UI system.
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
            if self.Elements then
                for name, value in pairs(self.Settings) do
                    local element = self.Elements[name]
                    if element then
                        if element.type == "slider" then
                            element.update(value)
                        elseif element.type == "toggle" then
                            element.toggleButton.Text = value and "ON" or "OFF"
                            element.toggleButton.BackgroundColor3 = value and Color3.fromRGB(120, 180, 120) or Color3.fromRGB(120, 120, 120)
                        end
                    end
                end
            end
        end
    end
end

UI:LoadSettings()
CustomModule.AddCustomStuff(UI)