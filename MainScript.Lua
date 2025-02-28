-- MainScript.lua
local HttpService = game:GetService("HttpService")
local rizeFolder = "Rize"
local profilePath = rizeFolder .. "/MainProfile.txt"
local defaultCustomModuleURL = "https://raw.githubusercontent.com/LiesInTheDarkness/Rize/refs/heads/main/CustomModule.lua"
local uiLibURL = "https://raw.githubusercontent.com/LiesInTheDarkness/Rize/refs/heads/main/UiLib.lua"

-- Ensure the Rize folder exists.
if not isfolder(rizeFolder) then
    makefolder(rizeFolder)
end

-- Ensure the profile file exists.
if not isfile(profilePath) then
    writefile(profilePath, "{}")
end

-- Profile functions with extra safety.
local function loadProfileSettings()
    if not isfile(profilePath) then
        writefile(profilePath, "{}")
    end
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

-- Override SaveSettings and LoadSettings for the UI instance.
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
                            element.toggleButton.BackgroundColor3 = value and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(100, 100, 100)
                        end
                    end
                end
            end
        end
    end
end

-- Attempt to locate or download CustomModule.
local customModulePath = rizeFolder .. "/CustomModule.lua"
local customModuleFound = false

if isfile(customModulePath) then
    customModuleFound = true
elseif isfile(rizeFolder .. "/CustomModule.lua") then
    customModulePath = rizeFolder .. "/CustomModule.lua"
    customModuleFound = true
else
    local success, response = pcall(function() return game:HttpGet(defaultCustomModuleURL) end)
    if success and response and response ~= "" then
        writefile(customModulePath, response)
        customModuleFound = true
    else
        warn("Failed to download CustomModule.lua from GitHub, using fallback default module.")
        customModuleFound = false
    end
end

-- Validate file contents if the file exists.
if customModuleFound then
    local content = readfile(customModulePath)
    if not content or content == "" then
        warn("CustomModule.lua exists but is empty. Using fallback default module.")
        customModuleFound = false
    end
end

-- Load or create a fallback for the CustomModule.
local CustomModule = nil
if customModuleFound then
    local customModuleSource = readfile(customModulePath)
    local loadSuccess, loadedModule = pcall(loadstring, customModuleSource)
    if loadSuccess and loadedModule then
        CustomModule = loadedModule
    else
        warn("Failed to load CustomModule.lua, using fallback default module.")
        customModuleFound = false
    end
end

if not customModuleFound then
    CustomModule = {}
    function CustomModule.AddCustomStuff(UI)
        warn("CustomModule not available, skipping custom UI elements.")
    end
end

-- Load the UI Library from GitHub.
local uiLibSource = game:HttpGet(uiLibURL)
if not uiLibSource or uiLibSource == "" then
    error("Failed to retrieve UiLib.lua from GitHub.")
end
local RizeUI = loadstring(uiLibSource)
if not RizeUI then
    error("Failed to load UI Library (UiLib.lua).")
end
RizeUI = RizeUI()

-- Create the UI instance and set up profile persistence.
local UI = RizeUI.new()
setupProfileFunctions(UI)
UI:LoadSettings()

-- Use the Custom Module to add your custom UI elements.
CustomModule.AddCustomStuff(UI)