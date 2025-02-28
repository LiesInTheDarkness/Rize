-- Rize UI Library (UI Handling Only) -- Provides a structured UI framework 

local RizeUILib = {}

-- Constructor for creating a new UI instance
function RizeUILib.new()
    local self = {}
    self.Elements = {}
    self.Tabs = {}
    self.TabContents = {}
    self.CurrentTab = nil
    self.Settings = {}
    
    -- Create the main UI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RizeUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 460, 0, 300)
    self.MainFrame.Position = UDim2.new(0.5, -230, 0.5, -150)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- Add UI Corner to MainFrame
    local mainFrameCorner = Instance.new("UICorner")
    mainFrameCorner.CornerRadius = UDim.new(0, 12)
    mainFrameCorner.Parent = self.MainFrame
    
    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Add UI Corner to TitleBar
    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 12)
    titleBarCorner.Parent = self.TitleBar
    
    -- Title text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.Text = "Rize UI"
    self.TitleText.Size = UDim2.new(1, -40, 1, 0)
    self.TitleText.Position = UDim2.new(0, 10, 0, 0)
    self.TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleText.TextSize = 20
    self.TitleText.Font = Enum.Font.GothamBold
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Parent = self.TitleBar
    
    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Text = "X"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -35, 0, 5)
    self.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseButton.TextSize = 18
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Parent = self.TitleBar
    
    -- Add UI Corner to CloseButton
    local closeButtonCorner = Instance.new("UICorner")
    closeButtonCorner.CornerRadius = UDim.new(0, 8)
    closeButtonCorner.Parent = self.CloseButton
    
    -- Click handler for close button
    self.CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- Tab bar
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 120, 1, -40)
    self.TabBar.Position = UDim2.new(0, 0, 0, 40)
    self.TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Parent = self.MainFrame
    
    -- Add UI List Layout to TabBar
    self.TabLayout = Instance.new("UIListLayout")
    self.TabLayout.Padding = UDim.new(0, 2)
    self.TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabLayout.Parent = self.TabBar
    
    -- Content frame
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -120, 1, -40)
    self.ContentFrame.Position = UDim2.new(0, 120, 0, 40)
    self.ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.MainFrame
    
    -- Add UI Corner to ContentFrame
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = self.ContentFrame
    
    -- Make the main frame draggable
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Method to create a tab
    function self:CreateTab(name)
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Text = name
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.TextSize = 16
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.BorderSizePixel = 0
        tabButton.Parent = self.TabBar
        
        -- Add UI Corner to tab button
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton
        
        -- Tab content frame
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Name = name .. "Content"
        contentFrame.Size = UDim2.new(1, -20, 1, -20)
        contentFrame.Position = UDim2.new(0, 10, 0, 10)
        contentFrame.BackgroundTransparency = 1
        contentFrame.BorderSizePixel = 0
        contentFrame.ScrollBarThickness = 6
        contentFrame.Visible = false
        contentFrame.Parent = self.ContentFrame
        contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        
        -- Add UI List Layout to content frame
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = contentFrame
        
        -- Store tab button and content frame
        self.Tabs[name] = tabButton
        self.TabContents[name] = contentFrame
        
        -- Click handler for tab button
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tab contents
            for _, content in pairs(self.TabContents) do
                content.Visible = false
            end
            
            -- Reset all tab button colors
            for _, tab in pairs(self.Tabs) do
                tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                tab.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            
            -- Show this tab's content
            contentFrame.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            self.CurrentTab = name
        end)
        
        -- If this is the first tab, show it by default
        if self.CurrentTab == nil then
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            contentFrame.Visible = true
            self.CurrentTab = name
        end
        
        return name
    end
    
    -- Method to create a button within a tab
    function self:CreateButton(tab, name, callback)
        if not self.TabContents[tab] then return end
        
        -- Create button element
        local button = Instance.new("TextButton")
        button.Name = name .. "Button"
        button.Text = name
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 16
        button.Font = Enum.Font.GothamSemibold
        button.BorderSizePixel = 0
        button.Parent = self.TabContents[tab]
        
        -- Add UI Corner to button
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Click handler
        button.MouseButton1Click:Connect(function()
            callback()
        end)
        
        return button
    end
    
    -- Method to create a toggle within a tab
    function self:CreateToggle(tab, name, default, callback)
        if not self.TabContents[tab] then return end
        
        -- Create toggle container
        local toggleContainer = Instance.new("Frame")
        toggleContainer.Name = name .. "Toggle"
        toggleContainer.Size = UDim2.new(1, 0, 0, 40)
        toggleContainer.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        toggleContainer.BorderSizePixel = 0
        toggleContainer.Parent = self.TabContents[tab]
        
        -- Add UI Corner to toggle container
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleContainer
        
        -- Toggle label
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Text = name
        toggleLabel.Size = UDim2.new(1, -70, 1, 0)
        toggleLabel.Position = UDim2.new(0, 10, 0, 0)
        toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleLabel.TextSize = 16
        toggleLabel.Font = Enum.Font.GothamSemibold
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Parent = toggleContainer
        
        -- Toggle button
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Text = default and "ON" or "OFF"
        toggleButton.Size = UDim2.new(0, 50, 0, 30)
        toggleButton.Position = UDim2.new(1, -60, 0.5, -15)
        toggleButton.BackgroundColor3 = default and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(100, 100, 100)
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.TextSize = 14
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.BorderSizePixel = 0
        toggleButton.Parent = toggleContainer
        
        -- Add UI Corner to toggle button
        local toggleButtonCorner = Instance.new("UICorner")
        toggleButtonCorner.CornerRadius = UDim.new(0, 6)
        toggleButtonCorner.Parent = toggleButton
        
        -- Set in settings
        self.Settings[name] = default
        
        -- Click handler
        local state = default
        toggleButton.MouseButton1Click:Connect(function()
            state = not state
            toggleButton.Text = state and "ON" or "OFF"
            toggleButton.BackgroundColor3 = state and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(100, 100, 100)
            self.Settings[name] = state
            callback(state)
        end)
        
        self.Elements[name] = {
            type = "toggle",
            toggleButton = toggleButton,
            update = function(value)
                state = value
                toggleButton.Text = state and "ON" or "OFF"
                toggleButton.BackgroundColor3 = state and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(100, 100, 100)
                callback(state)
            end
        }
        
        return toggleContainer
    end
    
    -- Method to create a slider within a tab
    function self:CreateSlider(tab, name, min, max, default, callback)
        if not self.TabContents[tab] then return end
        
        -- Create slider container
        local sliderContainer = Instance.new("Frame")
        sliderContainer.Name = name .. "Slider"
        sliderContainer.Size = UDim2.new(1, 0, 0, 60)
        sliderContainer.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        sliderContainer.BorderSizePixel = 0
        sliderContainer.Parent = self.TabContents[tab]
        
        -- Add UI Corner to slider container
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 6)
        sliderCorner.Parent = sliderContainer
        
        -- Slider label
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Text = name
        sliderLabel.Size = UDim2.new(1, -70, 0, 30)
        sliderLabel.Position = UDim2.new(0, 10, 0, 0)
        sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderLabel.TextSize = 16
        sliderLabel.Font = Enum.Font.GothamSemibold
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Parent = sliderContainer
        
        -- Value display
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.Text = tostring(default)
        valueLabel.Size = UDim2.new(0, 60, 0, 30)
        valueLabel.Position = UDim2.new(1, -70, 0, 0)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.TextSize = 16
        valueLabel.Font = Enum.Font.GothamSemibold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.BackgroundTransparency = 1
        valueLabel.Parent = sliderContainer
        
        -- Slider background
        local sliderBg = Instance.new("Frame")
        sliderBg.Name = "SliderBg"
        sliderBg.Size = UDim2.new(1, -20, 0, 10)
        sliderBg.Position = UDim2.new(0, 10, 0, 40)
        sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderContainer
        
        -- Add UI Corner to slider background
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(0, 6)
        sliderBgCorner.Parent = sliderBg
        
        -- Slider fill
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "SliderFill"
        local fillPercent = (default - min) / (max - min)
        sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        
        -- Add UI Corner to slider fill
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(0, 6)
        sliderFillCorner.Parent = sliderFill
        
        -- Set in settings
        self.Settings[name] = default
        
        -- Function to update slider
        local function updateSlider(value)
            value = math.clamp(value, min, max)
            local percent = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(math.floor(value * 10) / 10)
            self.Settings[name] = value
            callback(value)
        end
        
        -- Allow dragging the slider
        local dragging = false
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = min + (relativeX * (max - min))
                updateSlider(value)
            end
        end)
        
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = min + (relativeX * (max - min))
                updateSlider(value)
            end
        end)
        
        self.Elements[name] = {
            type = "slider",
            update = updateSlider
        }
        
        return sliderContainer
    end
    
    -- Method to create a notification
    function self:CreateNotification(message, duration)
        duration = duration or 3
        
        -- Notification container
        local notifContainer = Instance.new("Frame")
        notifContainer.Name = "Notification"
        notifContainer.Size = UDim2.new(0, 250, 0, 60)
        notifContainer.Position = UDim2.new(1, -260, 1, -70)
        notifContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        notifContainer.BorderSizePixel = 0
        notifContainer.Parent = self.ScreenGui
        
        -- Add UI Corner to notification
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notifContainer
        
        -- Notification label
        local notifLabel = Instance.new("TextLabel")
        notifLabel.Name = "Message"
        notifLabel.Text = message
        notifLabel.Size = UDim2.new(1, -20, 1, -10)
        notifLabel.Position = UDim2.new(0, 10, 0, 5)
        notifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        notifLabel.TextSize = 14
        notifLabel.Font = Enum.Font.GothamSemibold
        notifLabel.TextWrapped = true
        notifLabel.BackgroundTransparency = 1
        notifLabel.Parent = notifContainer
        
        -- Animate notification
        notifContainer:TweenPosition(UDim2.new(1, -260, 1, -70 - notifContainer.AbsoluteSize.Y), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
        
        -- Remove notification after duration
        task.spawn(function()
            task.wait(duration)
            notifContainer:TweenPosition(UDim2.new(1, 10, 1, -70 - notifContainer.AbsoluteSize.Y), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
            task.wait(0.5)
            notifContainer:Destroy()
        end)
        
        return notifContainer
    end
    
    -- Method to save settings
    function self:SaveSettings()
        -- This will be overridden in MainScript.lua
    end
    
    -- Method to load settings
    function self:LoadSettings()
        -- This will be overridden in MainScript.lua
    end
    
    return self
end

return RizeUILib