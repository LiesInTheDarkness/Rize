-- UiLib.lua -- Rize UI Library with persistent settings support.
local RizeUi = {}
RizeUi.__index = RizeUi
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

function RizeUi.new()
    local self = setmetatable({}, RizeUi)
    self.Settings = {}      -- Current setting values.
    self.Tabs = {}          -- Tab data.
    self.Elements = {}      -- References to UI elements for updating.
    self.UIOpen = true

    local player = Players.LocalPlayer
    if not player then
        error("[UiLib] LocalPlayer is nil. This must run in a LocalScript.")
    end

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RizeUI"
    self.ScreenGui.ResetOnSpawn = false  -- Persist after death.
    local playerGui = player:WaitForChild("PlayerGui")
    self.ScreenGui.Parent = playerGui

    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 400, 0, 300)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(140, 90, 110)
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = self.MainFrame

    local mainGradient = Instance.new("UIGradient")
    mainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(141, 105, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 120, 150))
    })
    mainGradient.Rotation = 90
    mainGradient.Parent = self.MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(100, 60, 80)
    TitleBar.Parent = self.MainFrame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 12)
    barCorner.Parent = TitleBar

    local barGradient = Instance.new("UIGradient")
    barGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 70, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 90, 110))
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

    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, 0, 0, 40)
    TabBar.Position = UDim2.new(0, 0, 0, 40)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = self.MainFrame
    self.TabBar = TabBar

    -- Toggle button for open/close; positioned under Roblox icon.
    self.ToggleButton = Instance.new("TextButton")
    self.ToggleButton.Name = "ToggleButton"
    self.ToggleButton.Text = "R"
    self.ToggleButton.Position = UDim2.new(0, 10, 0, 50)
    self.ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    self.ToggleButton.BackgroundColor3 = Color3.fromRGB(130, 60, 85)
    self.ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.ToggleButton.Font = Enum.Font.SourceSansBold
    self.ToggleButton.TextScaled = true
    self.ToggleButton.Parent = self.ScreenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = self.ToggleButton
    self.ToggleButton.MouseButton1Click:Connect(function()
        self.UIOpen = not self.UIOpen
        self.MainFrame.Visible = self.UIOpen
    end)
    
    return self
end

function RizeUi:CreateTab(tabName, iconId)
    local tabData = {}
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "TabButton_" .. tabName
    tabButton.Size = UDim2.new(0, 120, 1, 0)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = ""
    tabButton.Parent = self.TabBar
    local tabCount = #self.Tabs
    tabButton.Position = UDim2.new(0, tabCount * 120, 0, 0)

    if iconId then
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 24, 0, 24)
        icon.Position = UDim2.new(0, 5, 0.5, -12)
        icon.BackgroundTransparency = 1
        icon.Image = iconId
        icon.Parent = tabButton
    end

    local tabText = Instance.new("TextLabel")
    tabText.Name = "TabText"
    tabText.BackgroundTransparency = 1
    tabText.Size = UDim2.new(1, iconId and -30 or 0, 1, 0)
    tabText.Position = UDim2.new(0, iconId and 30 or 0, 0, 0)
    tabText.Text = tabName
    tabText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabText.Font = Enum.Font.SourceSansBold
    tabText.TextScaled = true
    tabText.Parent = tabButton

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "Tab_" .. tabName
    scrollingFrame.Size = UDim2.new(1, -10, 1, -80)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 80)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.BackgroundColor3 = Color3.fromRGB(160, 90, 110)
    scrollingFrame.Visible = (tabCount == 0)
    scrollingFrame.Parent = self.MainFrame

    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 12)
    scrollCorner.Parent = scrollingFrame

    local scrollGradient = Instance.new("UIGradient")
    scrollGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 110, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 130, 150))
    })
    scrollGradient.Rotation = 90
    scrollGradient.Parent = scrollingFrame

    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollingFrame
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)

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

function RizeUi:CreateButton(tabData, buttonName, callback)
    local btn = Instance.new("TextButton")
    btn.Name = buttonName
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.Text = buttonName
    btn.Parent = tabData.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

function RizeUi:CreateSlider(tabData, sliderName, minValue, maxValue, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = sliderName
    sliderFrame.Size = UDim2.new(1, -10, 0, 45)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    sliderFrame.Parent = tabData.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = sliderFrame

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(0, 130, 1, 0)
    sliderLabel.Position = UDim2.new(0, 10, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    sliderLabel.Font = Enum.Font.SourceSans
    sliderLabel.TextSize = 20
    sliderLabel.Text = sliderName
    sliderLabel.Parent = sliderFrame

    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "Bar"
    sliderBar.Size = UDim2.new(1, -150, 0, 8)
    sliderBar.Position = UDim2.new(0, 140, 0.5, -4)
    sliderBar.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
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

    -- Save reference for later updates.
    self.Elements[sliderName] = {
        type = "slider",
        update = updatePositionFromValue,
        sliderHandle = sliderHandle
    }

    local dragging = false
    local function startDrag() dragging = true end
    local function endDrag()
        dragging = false
        if self.SaveSettings then
            self:SaveSettings()
        end
    end

    local function isInputSupported(input)
        return input.UserInputType == Enum.UserInputType.Touch or 
               input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.MouseMovement
    end

    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag()
        end
    end)
    sliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag()
        end
    end)
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and isInputSupported(input) then
            if sliderBar and sliderBar.AbsolutePosition and sliderBar.AbsoluteSize then
                local relativeX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
                local percent = relativeX / sliderBar.AbsoluteSize.X
                local newValue = math.floor(minValue + (maxValue - minValue) * percent)
                if newValue ~= currentValue then
                    currentValue = newValue
                    self.Settings[sliderName] = newValue
                    updatePositionFromValue(newValue)
                    if callback then callback(newValue) end
                    if self.SaveSettings then
                        self:SaveSettings()
                    end
                end
            end
        end
    end)
    return sliderFrame
end

function RizeUi:CreateToggle(tabData, toggleName, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = toggleName
    toggleFrame.Size = UDim2.new(1, -10, 0, 40)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    toggleFrame.Parent = tabData.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleFrame

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0, 130, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggleLabel.Font = Enum.Font.SourceSans
    toggleLabel.TextSize = 20
    toggleLabel.Text = toggleName
    toggleLabel.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0.8, 0)
    toggleButton.Position = UDim2.new(1, -70, 0.1, 0)
    toggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(120, 180, 120) or Color3.fromRGB(120, 120, 120)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextScaled = true
    toggleButton.Text = defaultState and "ON" or "OFF"
    toggleButton.Parent = toggleFrame

    self.Settings[toggleName] = defaultState
    self.Elements[toggleName] = {
        type = "toggle",
        toggleButton = toggleButton
    }
    
    toggleButton.MouseButton1Click:Connect(function()
        local newState = not self.Settings[toggleName]
        self.Settings[toggleName] = newState
        toggleButton.Text = newState and "ON" or "OFF"
        toggleButton.BackgroundColor3 = newState and Color3.fromRGB(120, 180, 120) or Color3.fromRGB(120, 120, 120)
        if callback then callback(newState) end
        if self.SaveSettings then
            self:SaveSettings()
        end
    end)
end

return RizeUi