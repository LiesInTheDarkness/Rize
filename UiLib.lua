-- UiLib.lua
-- Rize UI Library for Roblox (Loadstring Version)
-- This library handles UI creation but does not implement saving.
local RizeUI = {}
RizeUI.__index = RizeUI

function RizeUI.new()
    local self = setmetatable({}, RizeUI)
    self.Settings = {}  -- table to store user settings

    local player = game:GetService("Players").LocalPlayer
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RizeScreenGui"
    self.ScreenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main panel
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 400, 0, 300)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(100, 60, 80)
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(80, 40, 60)
    TitleBar.Parent = self.MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Text = "RIZE"
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextScaled = true
    TitleLabel.Parent = TitleBar

    -- Toggle button for open/close
    self.ToggleButton = Instance.new("TextButton")
    self.ToggleButton.Name = "ToggleButton"
    self.ToggleButton.Text = "R"
    self.ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    self.ToggleButton.Position = UDim2.new(0, 20, 0, 20)
    self.ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 70, 90)
    self.ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.ToggleButton.Font = Enum.Font.SourceSansBold
    self.ToggleButton.TextScaled = true
    self.ToggleButton.Parent = self.ScreenGui

    self.UIOpen = true
    self.ToggleButton.MouseButton1Click:Connect(function()
        self.UIOpen = not self.UIOpen
        self.MainFrame.Visible = self.UIOpen
    end)

    self.Tabs = {} -- table to store created tabs

    return self
end

-- Create a new tab with a scrollable content frame
function RizeUI:CreateTab(tabName)
    local tabData = {}
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "TabButton_" .. tabName
    tabButton.Size = UDim2.new(0, 80, 0, 30)
    tabButton.Position = UDim2.new(0, #self.Tabs * 80, 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(120, 80, 100)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Text = tabName
    tabButton.Font = Enum.Font.SourceSansBold
    tabButton.TextScaled = true
    tabButton.Parent = self.MainFrame.TitleBar

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "Tab_" .. tabName
    scrollingFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.BackgroundColor3 = Color3.fromRGB(140, 100, 120)
    scrollingFrame.Visible = (#self.Tabs == 0) -- show first tab by default
    scrollingFrame.Parent = self.MainFrame

    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollingFrame
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    tabButton.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t.Frame.Visible = false
        end
        scrollingFrame.Visible = true
    end)

    tabData.Name = tabName
    tabData.Button = tabButton
    tabData.Frame = scrollingFrame
    table.insert(self.Tabs, tabData)
    return tabData
end

-- Create a button element with a custom name
function RizeUI:CreateButton(tabData, buttonName, callback)
    local btn = Instance.new("TextButton")
    btn.Name = buttonName
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.Text = buttonName
    btn.Parent = tabData.Frame

    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
end

-- Create a slider element with a custom name
function RizeUI:CreateSlider(tabData, sliderName, minValue, maxValue, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = sliderName
    sliderFrame.Size = UDim2.new(1, -10, 0, 40)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    sliderFrame.Parent = tabData.Frame

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(0, 80, 1, 0)
    sliderLabel.Position = UDim2.new(0, 5, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    sliderLabel.Font = Enum.Font.SourceSans
    sliderLabel.TextSize = 20
    sliderLabel.Text = sliderName
    sliderLabel.Parent = sliderFrame

    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "Bar"
    sliderBar.Size = UDim2.new(1, -100, 0, 10)
    sliderBar.Position = UDim2.new(0, 90, 0.5, -5)
    sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    sliderBar.Parent = sliderFrame

    local sliderHandle = Instance.new("Frame")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 10, 1, 0)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(120, 80, 100)
    sliderHandle.Parent = sliderBar

    local currentValue = defaultValue or 0
    local function updatePositionFromValue(val)
        local percent = (val - minValue) / (maxValue - minValue)
        sliderHandle.Position = UDim2.new(percent, -5, 0, 0)
    end
    updatePositionFromValue(currentValue)

    self.Settings[sliderName] = currentValue

    local UserInputService = game:GetService("UserInputService")
    local dragging = false

    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            if self.SaveSettings then self:SaveSettings() end
        end
    end)

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            if self.SaveSettings then self:SaveSettings() end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
            local percent = relativeX / sliderBar.AbsoluteSize.X
            local newValue = math.floor(minValue + (maxValue - minValue) * percent)
            currentValue = newValue
            self.Settings[sliderName] = newValue
            updatePositionFromValue(newValue)
            if callback then
                callback(newValue)
            end
        end
    end)
end

-- Create a toggle element with a custom name
function RizeUI:CreateToggle(tabData, toggleName, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = toggleName
    toggleFrame.Size = UDim2.new(1, -10, 0, 30)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    toggleFrame.Parent = tabData.Frame

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0, 100, 1, 0)
    toggleLabel.Position = UDim2.new(0, 5, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggleLabel.Font = Enum.Font.SourceSans
    toggleLabel.TextSize = 20
    toggleLabel.Text = toggleName
    toggleLabel.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0.8, 0)
    toggleButton.Position = UDim2.new(1, -70, 0.1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextScaled = true
    toggleButton.Text = defaultState and "ON" or "OFF"
    toggleButton.Parent = toggleFrame

    self.Settings[toggleName] = defaultState

    toggleButton.MouseButton1Click:Connect(function()
        local newState = not self.Settings[toggleName]
        self.Settings[toggleName] = newState
        toggleButton.Text = newState and "ON" or "OFF"
        toggleButton.BackgroundColor3 = newState and Color3.fromRGB(120, 180, 120) or Color3.fromRGB(100, 100, 100)
        if callback then
            callback(newState)
        end
        if self.SaveSettings then self:SaveSettings() end
    end)

    if defaultState then
        toggleButton.BackgroundColor3 = Color3.fromRGB(120, 180, 120)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end

return RizeUI
