-- UiLib.lua
-- Rize UI Library for Roblox (Loadstring Version)
-- This version adds gradients, round corners, and optional icons to look closer to your design.

local RizeUI = {}
RizeUI.__index = RizeUI

function RizeUI.new()
    local self = setmetatable({}, RizeUI)
    self.Settings = {}  -- table to store user settings

    local player = game:GetService("Players").LocalPlayer
    local UserInputService = game:GetService("UserInputService")

    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RizeScreenGui"
    self.ScreenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Panel
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 400, 0, 300)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(150, 80, 110) -- fallback color
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui

    -- Add round corners to MainFrame
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = self.MainFrame

    -- Add a vertical gradient to MainFrame
    local mainGradient = Instance.new("UIGradient")
    mainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(130, 90, 120)),  -- top color
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(180, 120, 150))  -- bottom color
    })
    mainGradient.Rotation = 90
    mainGradient.Parent = self.MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(80, 40, 60) -- fallback color
    TitleBar.Parent = self.MainFrame

    -- Round corners on TitleBar
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 8)
    barCorner.Parent = TitleBar

    -- Gradient on TitleBar
    local barGradient = Instance.new("UIGradient")
    barGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(90, 50, 70)),  -- left color
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(120, 70, 100)) -- right color
    })
    barGradient.Rotation = 0
    barGradient.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Text = "RIZE"
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextScaled = true
    TitleLabel.Parent = TitleBar

    -- Circle Toggle Button (the 'R' button)
    self.ToggleButton = Instance.new("TextButton")
    self.ToggleButton.Name = "ToggleButton"
    self.ToggleButton.Text = "R"
    self.ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    self.ToggleButton.Position = UDim2.new(0.5, -25, 0.5, -150 - 60) -- above the panel
    self.ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 70, 90)
    self.ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.ToggleButton.Font = Enum.Font.SourceSansBold
    self.ToggleButton.TextScaled = true
    self.ToggleButton.Parent = self.ScreenGui

    -- Make it round
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0) -- fully round
    toggleCorner.Parent = self.ToggleButton

    self.UIOpen = true
    self.ToggleButton.MouseButton1Click:Connect(function()
        self.UIOpen = not self.UIOpen
        self.MainFrame.Visible = self.UIOpen
    end)

    self.Tabs = {}
    return self
end

--------------------------------------------------------------------------------
-- Tab Creation (with optional icon)
--------------------------------------------------------------------------------

-- You can pass an icon asset ID if you want an icon on the tab button
function RizeUI:CreateTab(tabName, iconId)
    local tabData = {}

    -- Create a button on the title bar for switching to this tab
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "TabButton_" .. tabName
    tabButton.Size = UDim2.new(0, 120, 1, 0)  -- slightly taller to fit icon if needed
    tabButton.Position = UDim2.new(0, #self.Tabs * 120, 0, 0)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = ""
    tabButton.Parent = self.MainFrame.TitleBar

    -- (Optional) If you want a background for the tab button
    -- local tabBtnBg = Instance.new("Frame")
    -- tabBtnBg.Size = UDim2.new(1, 0, 1, 0)
    -- tabBtnBg.BackgroundColor3 = Color3.fromRGB(120, 80, 100)
    -- tabBtnBg.Parent = tabButton

    local icon = nil
    if iconId then
        icon = Instance.new("ImageLabel")
        icon.Name = "TabIcon"
        icon.Size = UDim2.new(0, 24, 0, 24)
        icon.Position = UDim2.new(0, 5, 0.5, -12)
        icon.BackgroundTransparency = 1
        icon.Image = iconId
        icon.Parent = tabButton
    end

    local tabText = Instance.new("TextLabel")
    tabText.Name = "TabText"
    tabText.Size = UDim2.new(1, iconId and -35 or 0, 1, 0)
    tabText.Position = UDim2.new(iconId and 0 or 0, iconId and 35 or 0, 0, 0)
    tabText.BackgroundTransparency = 1
    tabText.Text = tabName
    tabText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabText.Font = Enum.Font.SourceSansBold
    tabText.TextScaled = true
    tabText.Parent = tabButton

    -- Scrollable frame for tab content
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "Tab_" .. tabName
    scrollingFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.BackgroundColor3 = Color3.fromRGB(150, 90, 120)
    scrollingFrame.Visible = (#self.Tabs == 0)
    scrollingFrame.Parent = self.MainFrame

    -- Round corners on scrolling frame
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = scrollingFrame

    -- Layout
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollingFrame
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    -- Switch tabs on click
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

--------------------------------------------------------------------------------
-- Buttons, Sliders, Toggles
--------------------------------------------------------------------------------

function RizeUI:CreateButton(tabData, buttonName, callback)
    local btn = Instance.new("TextButton")
    btn.Name = buttonName
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.Text = buttonName
    btn.Parent = tabData.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
end

function RizeUI:CreateSlider(tabData, sliderName, minValue, maxValue, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = sliderName
    sliderFrame.Size = UDim2.new(1, -10, 0, 40)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    sliderFrame.Parent = tabData.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = sliderFrame

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(0, 100, 1, 0)
    sliderLabel.Position = UDim2.new(0, 5, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    sliderLabel.Font = Enum.Font.SourceSans
    sliderLabel.TextSize = 20
    sliderLabel.Text = sliderName
    sliderLabel.Parent = sliderFrame

    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "Bar"
    sliderBar.Size = UDim2.new(1, -110, 0, 8)
    sliderBar.Position = UDim2.new(0, 105, 0.5, -4)
    sliderBar.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    sliderBar.Parent = sliderFrame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = sliderBar

    local sliderHandle = Instance.new("Frame")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 12, 1, 0)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(100, 60, 80)
    sliderHandle.Parent = sliderBar

    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 6)
    handleCorner.Parent = sliderHandle

    local currentValue = defaultValue or 0
    local function updatePositionFromValue(val)
        local percent = (val - minValue) / (maxValue - minValue)
        sliderHandle.Position = UDim2.new(percent, -6, 0, 0)
    end
    updatePositionFromValue(currentValue)

    self.Settings[sliderName] = currentValue

    local UserInputService = game:GetService("UserInputService")
    local dragging = false

    local function endDrag()
        dragging = false
        if self.SaveSettings then self:SaveSettings() end
    end

    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
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

function RizeUI:CreateToggle(tabData, toggleName, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = toggleName
    toggleFrame.Size = UDim2.new(1, -10, 0, 35)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    toggleFrame.Parent = tabData.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toggleFrame

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
    toggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(120, 180, 120) or Color3.fromRGB(100, 100, 100)
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
end

return RizeUI
