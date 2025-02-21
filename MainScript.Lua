local HttpService = game:GetService("HttpService")
local rizeFolder = "Rize"
local profilePath = rizeFolder .. "/MainProfile.txt"

-- Ensure the Rize folder exists.
if not isfolder(rizeFolder) then
    makefolder(rizeFolder)
end

-- If MainProfile.txt doesn't exist, create it with an empty JSON object.
if not isfile(profilePath) then
    writefile(profilePath, "{}")
end

-- Function to load profile settings.
local function loadProfileSettings()
    local data = readfile(profilePath)
    local success, decoded = pcall(function()
        return HttpService:JSONDecode(data)
    end)
    if success and decoded then
        return decoded
    end
    return {}
end

-- Functions for loading and saving profile settings.
local function loadProfileSettings()
    local data = readfile(profilePath)
    local success, decoded = pcall(function() return HttpService:JSONDecode(data) end)
    if success and decoded then
        return decoded
    end
    return {}
end

local function saveProfileSettings(settings)
    writefile(profilePath, HttpService:JSONEncode(settings))
end

-- Override SaveSettings and LoadSettings in the UI instance.
local function setupProfileFunctions(UI)
    function UI:SaveSettings()
        saveProfileSettings(self.Settings)
    end

    function UI:LoadSettings()
        local loaded = loadProfileSettings()
        if loaded then
            self.Settings = loaded
            if self.Elements then
                for name, value in pairs(self.Settings) do
                    local element = self.Elements[name]
                    if element then
                        if element.type == "slider" then
                            element.update(value)
                        elseif element.type == "toggle" then
                            element.toggleButton.Text = value and "ON" or "OFF"
                            element.toggleButton.BackgroundColor3 = value and Color3.fromRGB(120,180,120) or Color3.fromRGB(120,120,120)
                        end
                    end
                end
            end
        end
    end
end

-- Check if CustomModule.lua exists locally; if not, download it from GitHub.
if not isfile(customModulePath) then
    local success, response = pcall(function()
        return game:HttpGet(githubCustomModuleURL)
    end)
    if success and response then
        writefile(customModulePath, response)
    else
        warn("Failed to download CustomModule.lua from GitHub.")
        return
    end
end

-- Load the UI Library from GitHub.
local RizeUI = loadstring(game:HttpGet(uiLibURL))()
if not RizeUI then
    error("[MainScript] Failed to load UI Library.")
end

-- Load the Custom Module from the local file.
local CustomModule = loadstring(readfile(customModulePath))()
if not CustomModule then
    error("[MainScript] Failed to load Custom Module.")
end

-- Create the UI instance.
local UI = RizeUI.new()
setupProfileFunctions(UI)
UI:LoadSettings()

-- Use the CustomModule to add your custom UI elements.
CustomModule.AddCustomStuff(UI)