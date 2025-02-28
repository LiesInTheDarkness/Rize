-- MainScript.lua
-- Main script for Rize UI framework

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Configuration
local rizeFolder = "Rize"
local profilePath = rizeFolder .. "/MainProfile.txt"
local customModulePath = rizeFolder .. "/CustomModule.lua"
local defaultCustomModuleURL = "https://raw.githubusercontent.com/LiesInTheDarkness/Rize/refs/heads/main/CustomModule.lua"
local uiLibURL = "https://raw.githubusercontent.com/LiesInTheDarkness/Rize/refs/heads/main/UiLib.lua"

-- Version information
local VERSION = "1.0.0"

-- Create logger with timestamp and enhanced formatting
local Logger = {}
function Logger:Info(message)
    print(string.format("[Rize INFO] %s: %s", os.date("%H:%M:%S"), message))
end
function Logger:Warn(message)
    warn(string.format("[Rize WARN] %s: %s", os.date("%H:%M:%S"), message))
end
function Logger:Error(message)
    error(string.format("[Rize ERROR] %s: %s", os.date("%H:%M:%S"), message), 2)
end

-- Check execution environment
local function checkEnvironment()
    if not (getgenv or getsenv) then
        Logger:Error("Rize requires a proper executor with file system access.")
        return false
    end
    
    -- Check for essential file system functions
    local requiredFunctions = {"isfolder", "makefolder", "isfile", "readfile", "writefile"}
    for _, funcName in ipairs(requiredFunctions) do
        if not _G[funcName] then
            Logger:Error("Missing required function: " .. funcName)
            return false
        end
    end
    
    return true
end

-- Ensure the Rize folder exists
local function setupFolders()
    if not isfolder(rizeFolder) then
        Logger:Info("Creating Rize folder")
        makefolder(rizeFolder)
    end
end

-- File System Helpers
local FileSystem = {}

function FileSystem:ReadJSON(path, default)
    default = default or {}
    
    if not isfile(path) then
        Logger:Info("File does not exist, creating: " .. path)
        self:WriteJSON(path, default)
        return default
    end
    
    local data = readfile(path)
    local success, decoded = pcall(function() 
        return HttpService:JSONDecode(data) 
    end)
    
    if success and decoded then
        return decoded
    else
        Logger:Warn("Failed to decode JSON from: " .. path)
        self:WriteJSON(path, default)
        return default
    end
end

function FileSystem:WriteJSON(path, data)
    local success, encoded = pcall(function() 
        return HttpService:JSONEncode(data) 
    end)
    
    if success and encoded then
        writefile(path, encoded)
        return true
    else
        Logger:Warn("Failed to encode JSON for: " .. path)
        return false
    end
end

function FileSystem:DownloadFile(url, savePath)
    Logger:Info("Downloading file from: " .. url)
    
    local success, response = pcall(function() 
        return game:HttpGet(url) 
    end)
    
    if success and response and response ~= "" then
        writefile(savePath, response)
        Logger:Info("Successfully downloaded file to: " .. savePath)
        return true
    else
        Logger:Warn("Failed to download file from: " .. url)
        return false
    end
end

-- Load the CustomModule
local function loadCustomModule()
    -- Check if the custom module exists locally
    if isfile(customModulePath) then
        Logger:Info("Found CustomModule.lua")
    elseif isfile(rizeFolder .. "/CustomModule.Lua") then
        customModulePath = rizeFolder .. "/CustomModule.Lua"
        Logger:Info("Found CustomModule.Lua (capital extension)")
    else
        -- Download from GitHub if not found locally
        Logger:Info("CustomModule not found locally, downloading from GitHub")
        if not FileSystem:DownloadFile(defaultCustomModuleURL, customModulePath) then
            Logger:Warn("Failed to download CustomModule, using fallback")
            return {
                AddCustomStuff = function(UI)
                    UI:CreateNotification("CustomModule not available, using fallback", 5)
                    local Tab = UI:CreateTab("Fallback")
                    UI:CreateButton(Tab, "Reload CustomModule", function()
                        UI:CreateNotification("Attempting to reload CustomModule...", 3)
                        FileSystem:DownloadFile(defaultCustomModuleURL, customModulePath)
                        UI:CreateNotification("Please restart Rize to apply changes", 5)
                    end)
                end
            }
        end
    end
    
    -- Validate file content
    local content = readfile(customModulePath)
    if not content or content == "" then
        Logger:Warn("CustomModule.lua exists but is empty, using fallback")
        return {
            AddCustomStuff = function(UI)
                UI:CreateNotification("CustomModule is empty, using fallback", 5)
            end
        }
    end
    
    -- Load the module
    local loadSuccess, loadedModule = pcall(loadstring, content)
    if loadSuccess and loadedModule then
        local success, module = pcall(loadedModule)
        if success and module then
            Logger:Info("Successfully loaded CustomModule")
            return module
        end
    end
    
    Logger:Warn("Failed to load CustomModule.lua, using fallback")
    return {
        AddCustomStuff = function(UI)
            UI:CreateNotification("Error in CustomModule, using fallback", 5)
        end
    }
end

-- Load the UI Library
local function loadUILibrary()
    -- Try to download the latest UI library from GitHub
    local uiLibContent
    local success, response = pcall(function() 
        return game:HttpGet(uiLibURL) 
    end)
    
    if success and response and response ~= "" then
        Logger:Info("Downloaded UI Library from GitHub")
        uiLibContent = response
        -- Cache the UI Library for future use
        writefile(rizeFolder .. "/UiLib.lua", response)
    elseif isfile(rizeFolder .. "/UiLib.lua") then
        -- Use cached version if available
        Logger:Info("Using cached UI Library")
        uiLibContent = readfile(rizeFolder .. "/UiLib.lua")
    else
        Logger:Error("Failed to retrieve UI Library and no cached version available")
        return nil
    end
    
    -- Load the UI library
    local loadSuccess, loadedLib = pcall(loadstring, uiLibContent)
    if loadSuccess and loadedLib then
        local success, lib = pcall(loadedLib)
        if success and lib then
            Logger:Info("Successfully loaded UI Library")
            return lib
        end
    end
    
    Logger:Error("Failed to load UI Library")
    return nil
end

-- Setup the UI instance with profile persistence
local function setupUIInstance(RizeUI)
    local UI = RizeUI.new()
    
    -- Override SaveSettings function
    function UI:SaveSettings()
        Logger:Info("Saving settings")
        FileSystem:WriteJSON(profilePath, self.Settings)
    end
    
    -- Override LoadSettings function
    function UI:LoadSettings()
        Logger:Info("Loading settings")
        local loaded = FileSystem:ReadJSON(profilePath, {})
        if loaded then
            self.Settings = loaded
            
            -- Apply loaded settings to UI elements
            if self.Elements then
                for name, value in pairs(self.Settings) do
                    local element = self.Elements[name]
                    if element then
                        if element.type == "slider" then
                            element.update(value)
                        elseif element.type == "toggle" then
                            element.update(value)
                        end
                    end
                end
            end
        end
    end
    
    -- Add auto-save on close
    local oldDestroy = UI.ScreenGui.Destroy
    UI.ScreenGui.Destroy = function(...)
        UI:SaveSettings()
        return oldDestroy(...)
    end
    
    -- Setup auto-save every 30 seconds
    task.spawn(function()
        while true do
            task.wait(30)
            if UI and UI.ScreenGui and UI.ScreenGui.Parent then
                UI:SaveSettings()
            else
                break
            end
        end
    end)
    
    return UI
end

-- Main execution
local function main()
    -- Check execution environment
    if not checkEnvironment() then
        return
    end
    
    -- Setup folders and files
    setupFolders()
    
    -- Load UI Library
    local RizeUI = loadUILibrary()
    if not RizeUI then
        return
    end
    
    -- Create and setup UI instance
    local UI = setupUIInstance(RizeUI)
    
    -- Load settings
    UI:LoadSettings()
    
    -- Welcome notification
    UI:CreateNotification("Welcome to Rize UI v" .. VERSION, 5)
    
    -- Load Custom Module
    local CustomModule = loadCustomModule()
    
    -- Add custom UI elements
    task.spawn(function()
        local success, err = pcall(function()
            CustomModule.AddCustomStuff(UI)
        end)
        
        if not success then
            Logger:Warn("Error in CustomModule.AddCustomStuff: " .. tostring(err))
            UI:CreateNotification("Error in CustomModule: " .. tostring(err), 5)
            
            -- Create a fallback tab
            local Tab = UI:CreateTab("Error")
            UI:CreateButton(Tab, "Show Error", function()
                UI:CreateNotification(tostring(err), 10)
            end)
            UI:CreateButton(Tab, "Reload CustomModule", function()
                UI:CreateNotification("Attempting to reload CustomModule...", 3)
                FileSystem:DownloadFile(defaultCustomModuleURL, customModulePath)
                UI:CreateNotification("Please restart Rize to apply changes", 5)
            end)
        end
    end)
    
    return UI
end

-- Run the main function
return main()