-- MainScript.lua
local HttpService = game:GetService("HttpService")
local rizeFolder = "Rize"
local profilePath = rizeFolder .. "/MainProfile.txt"
local customModulePath = rizeFolder .. "/CustomModule.lua"
local uiLibPath = rizeFolder .. "/UiLib.lua"
local defaultCustomModuleURL = "https://raw.githubusercontent.com/LiesInTheDarkness/Rize/refs/heads/main/CustomModule.lua"
local uiLibURL = "https://raw.githubusercontent.com/LiesInTheDarkness/Rize/refs/heads/main/UiLib.lua"

-- Ensure the Rize folder exists.
if not isfolder(rizeFolder) then
    makefolder(rizeFolder)
end

-- Ensure the profile file exists with proper format.
if not isfile(profilePath) then
    writefile(profilePath, "{}")
end

-- Profile functions with extra safety.
local function loadProfileSettings()
    if not isfile(profilePath) then
        writefile(profilePath, "{}")
        return {}
    end
    
    local data = readfile(profilePath)
    if not data or data == "" then
        writefile(profilePath, "{}")
        return {}
    end
    
    local success, decoded = pcall(function() return HttpService:JSONDecode(data) end)
    if success and decoded then
        return decoded
    end
    
    -- If JSON decode fails, reset the profile
    writefile(profilePath, "{}")
    return {}
end

local function saveProfileSettings(settings)
    local success, encoded = pcall(function() return HttpService:JSONEncode(settings) end)
    if success and encoded then
        writefile(profilePath, encoded)
    end
end

-- Enhance the setup of profile functions for the UI instance
local function setupProfileFunctions(UI)
    -- Save settings method
    function UI:SaveSettings()
        saveProfileSettings(self.Settings)
    end
    
    -- Load settings method
    function UI:LoadSettings()
        local loaded = loadProfileSettings()
        if loaded then
            self.Settings = loaded
        end
    end
    
    -- Apply loaded settings to UI elements
    function UI:ApplyLoadedSettings()
        if not self.Elements then return end
        
        for name, element in pairs(self.Elements) do
            if self.Settings[name] ~= nil then
                if element.type == "slider" then
                    element.update(self.Settings[name])
                elseif element.type == "toggle" then
                    element.update(self.Settings[name])
                end
            end
        end
        
        -- Apply UI position if saved
        if self.Settings["UIPosition"] then
            local pos = self.Settings["UIPosition"]
            self.MainFrame.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
            self.LastPosition = self.MainFrame.Position
        end
        
        -- Apply toggle button position if saved
        if self.Settings["ToggleButtonPosition"] then
            local pos = self.Settings["ToggleButtonPosition"]
            self.ToggleButton.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
        end
    end
end  -- Fixed: Changed the curly brace to a parenthesis

-- Function to download or verify a file
local function getOrDownloadFile(filePath, url, defaultContent)
    -- Check if file exists
    if isfile(filePath) then
        local content = readfile(filePath)
        if content and content ~= "" then
            -- Verify content is not mixed up by checking for common identifiers
            if filePath:find("CustomModule") and not content:find("CustomModule") then
                warn("File content mismatch in " .. filePath .. ", redownloading...")
                -- Try to download the correct file
                local success, response = pcall(function() return game:HttpGet(url) end)
                if success and response and response ~= "" then
                    writefile(filePath, response)
                    return response
                else
                    -- If download fails, use default content
                    if defaultContent then
                        writefile(filePath, defaultContent)
                        return defaultContent
                    end
                end
            else
                return content
            end
        end
    end
    
    -- File doesn't exist or is empty, try to download
    local success, response = pcall(function() return game:HttpGet(url) end)
    if success and response and response ~= "" then
        writefile(filePath, response)
        return response
    end
    
    -- If download fails, use default content
    if defaultContent then
        writefile(filePath, defaultContent)
        return defaultContent
    end
    
    return nil
end

-- Create default CustomModule content for fallback
local defaultCustomModule = [[
-- CustomModule.lua
-- This module defines custom UI elements for the Rize UI framework

local CustomModule = {}

-- Function to add custom UI elements
function CustomModule.AddCustomStuff(UI)
    -- Create Main Tab
    local MainTab = UI:CreateTab("Main")
    
    -- Add some basic controls to the Main tab
    UI:CreateToggle(MainTab, "WalkSpeed Boost", false, function(state)
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character then
            if state then
                player.Character.Humanoid.WalkSpeed = 32
            else
                player.Character.Humanoid.WalkSpeed = 16
            end
        end
    end)
    
    UI:CreateSlider(MainTab, "Jump Power", 50, 200, 50, function(value)
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character then
            player.Character.Humanoid.JumpPower = value
        end
    end)
    
    UI:CreateButton(MainTab, "Reset Character", function()
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character then
            player.Character:BreakJoints()
        end
    end)
    
    -- Create Visual Tab
    local VisualTab = UI:CreateTab("Visual")
    
    UI:CreateToggle(VisualTab, "ESP", false, function(state)
        if state then
            UI:CreateNotification("ESP Enabled", 3)
            -- ESP implementation would go here
        else
            UI:CreateNotification("ESP Disabled", 3)
            -- ESP cleanup would go here
        end
    end)
    
    UI:CreateToggle(VisualTab, "Fullbright", false, function(state)
        if state then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").GlobalShadows = false
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").ClockTime = game:GetService("Lighting").TimeOfDay
            game:GetService("Lighting").FogEnd = 10000
            game:GetService("Lighting").GlobalShadows = true
        end
    end)
    
    -- Create Settings Tab
    local SettingsTab = UI:CreateTab("Settings")
    
    UI:CreateButton(SettingsTab, "Reset All Settings", function()
        for name, element in pairs(UI.Elements) do
            if element.type == "toggle" then
                element.update(false)
            elseif element.type == "slider" then
                -- Reset to default value (middle of range)
                local MainTab = UI.TabContents["Main"]
                if MainTab then
                    for _, child in pairs(MainTab:GetChildren()) do
                        if child.Name == name.."Slider" then
                            local min = 50  -- Default min
                            local max = 200 -- Default max
                            element.update((min + max) / 2)
                            break
                        end
                    end
                end
            end
        end
        UI:SaveSettings()
        UI:CreateNotification("All settings have been reset", 3)
    end)
    
    UI:CreateButton(SettingsTab, "Save Settings", function()
        UI:SaveSettings()
        UI:CreateNotification("Settings saved successfully!", 3)
    end)
    
    -- Create Credits Tab
    local CreditsTab = UI:CreateTab("Credits")
    
    UI:CreateButton(CreditsTab, "Made by LiesInTheDarkness", function()
        UI:CreateNotification("Thanks for using Rize UI!", 5)
    end)
    
    UI:CreateButton(CreditsTab, "Version 1.0.0", function()
        UI:CreateNotification("You are using the latest version!", 3)
    end)
    
    -- Welcome notification
    UI:CreateNotification("Welcome to Rize UI!", 5)
end

return CustomModule
]]

-- Attempt to get the CustomModule
local customModuleSource = getOrDownloadFile(customModulePath, defaultCustomModuleURL, defaultCustomModule)
local CustomModule = nil

if customModuleSource then
    local loadSuccess, loadedModule = pcall(loadstring, customModuleSource)
    if loadSuccess and loadedModule then
        local success, result = pcall(function() return loadedModule() end)
        if success and result then
            CustomModule = result
        else
            warn("Failed to execute CustomModule.lua: " .. tostring(result))
            -- Try to fix the file content
            writefile(customModulePath, defaultCustomModule)
            -- Try loading again
            loadSuccess, loadedModule = pcall(loadstring, defaultCustomModule)
            if loadSuccess and loadedModule then
                success, result = pcall(function() return loadedModule() end)
                if success and result then
                    CustomModule = result
                end
            end
        end
    else
        warn("Failed to load CustomModule.lua")
        -- Try to fix the file content
        writefile(customModulePath, defaultCustomModule)
        -- Try loading again
        loadSuccess, loadedModule = pcall(loadstring, defaultCustomModule)
        if loadSuccess and loadedModule then
            success, result = pcall(function() return loadedModule() end)
            if success and result then
                CustomModule = result
            end
        end
    end
end

if not CustomModule then
    CustomModule = {}
    function CustomModule.AddCustomStuff(UI)
        warn("CustomModule not available, using basic UI elements.")
        -- Create a basic UI with an error message
        local MainTab = UI:CreateTab("Main")
        UI:CreateButton(MainTab, "Error Loading Custom Elements", function()
            UI:CreateNotification("There was an error loading custom elements. Please check console.", 5)
        end)
    end
end

-- Load the UI Library
local uiLibSource = getOrDownloadFile(uiLibPath, uiLibURL)
local RizeUI = nil

if uiLibSource then
    local loadSuccess, loadedUI = pcall(loadstring, uiLibSource)
    if loadSuccess and loadedUI then
        RizeUI = loadedUI()
    else
        error("Failed to load UI Library (UiLib.lua). Please check console for errors.")
    end
else
    error("Failed to get UI Library source from file or URL.")
end

if not RizeUI then
    error("Failed to initialize UI Library.")
end

-- Create the UI instance, load settings, and set up profile persistence
local UI = RizeUI.new()
setupProfileFunctions(UI)
UI:LoadSettings()
UI:ApplyLoadedSettings() -- Apply saved settings to UI

-- Check if the AddCustomStuff function exists before calling it
if CustomModule and type(CustomModule.AddCustomStuff) == "function" then
    -- Use pcall to catch any errors when calling the function
    local success, errorMsg = pcall(function()
        CustomModule.AddCustomStuff(UI)
    end)
    
    if not success then
        warn("Error when calling AddCustomStuff: " .. tostring(errorMsg))
        UI:CreateNotification("Error loading custom elements. Check console for details.", 5)
    else
        -- Apply any newly loaded settings that need updating
        UI:ApplyLoadedSettings()
    end
else
    warn("AddCustomStuff function not found in CustomModule")
    UI:CreateNotification("Custom elements could not be loaded", 5)
end

-- Save settings periodically 
task.spawn(function()
    while task.wait(30) do -- Save every 30 seconds
        pcall(function()
            UI:SaveSettings()
        end)
    end
end)