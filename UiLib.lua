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
    self.Visible = true
    self.LastPosition = UDim2.new(0.5, 0, 0.8, 0) -- Default position near bottom
    
    -- Create the main UI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RizeUI"
    self.ScreenGui.ResetOnSpawn = false
    
    -- Use ZIndexBehavior to ensure proper layering
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui, fall back to PlayerGui for mobile
    local success, _ = pcall(function()
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0.6, 0, 0.6, 0)         -- Use scale-based sizing for responsiveness
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)       -- Set the pivot to the center
    self.MainFrame.Position = self.LastPosition              -- Start near bottom
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.BackgroundTransparency = 0
    self.MainFrame.Parent = self.ScreenGui

    -- Add UI Corner to MainFrame
    local mainFrameCorner = Instance.new("UICorner")
    mainFrameCorner.CornerRadius = UDim.new(0, 12)
    mainFrameCorner.Parent = self.MainFrame
    
    -- Add shadow effect
    local shadowFrame = Instance.new("Frame")
    shadowFrame.Name = "Shadow"
    shadowFrame.Size = UDim2.new(1, 10, 1, 10)
    shadowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.BackgroundTransparency = 0.6
    shadowFrame.BorderSizePixel = 0
    shadowFrame.ZIndex = -1
    shadowFrame.Parent = self.MainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 14)
    shadowCorner.Parent = shadowFrame
    
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
    
    -- Fix for the corner
    local titleBarFix = Instance.new("Frame")
    titleBarFix.Name = "TitleBarFix"
    titleBarFix.Size = UDim2.new(1, 0, 0, 20)
    titleBarFix.Position = UDim2.new(0, 0, 1, -10)
    titleBarFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBarFix.BorderSizePixel = 0
    titleBarFix.ZIndex = 0
    titleBarFix.Parent = self.TitleBar
    
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
        self:ToggleUI(false)
    end)
    
    -- Tab bar
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 120, 1, -40)
    self.TabBar.Position = UDim2.new(0, 0, 0, 40)
    self.TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Parent = self.MainFrame
    
    -- Add UI Corner to TabBar
    local tabBarCorner = Instance.new("UICorner")
    tabBarCorner.CornerRadius = UDim.new(0, 8)
    tabBarCorner.Parent = self.TabBar
    
    -- Fix for the TabBar corner
    local tabBarFix = Instance.new("Frame")
    tabBarFix.Name = "TabBarFix"
    tabBarFix.Size = UDim2.new(1, 0, 1, -8)
    tabBarFix.Position = UDim2.new(0, 0, 0, 0)
    tabBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabBarFix.BorderSizePixel = 0
    tabBarFix.ZIndex = 0
    tabBarFix.Parent = self.TabBar
    
    -- Create a ScrollingFrame for the tabs
    self.TabScrollFrame = Instance.new("ScrollingFrame")
    self.TabScrollFrame.Name = "TabScrollFrame"
    self.TabScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    self.TabScrollFrame.BackgroundTransparency = 1
    self.TabScrollFrame.BorderSizePixel = 0
    self.TabScrollFrame.ScrollBarThickness = 4
    self.TabScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 50, 50)
    self.TabScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    self.TabScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.TabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabScrollFrame.Parent = self.TabBar
    
    -- Add UI List Layout to TabScrollFrame
    self.TabLayout = Instance.new("UIListLayout")
    self.TabLayout.Padding = UDim.new(0, 4)
    self.TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.TabLayout.Parent = self.TabScrollFrame
    
    -- Add padding to the TabScrollFrame
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingBottom = UDim.new(0, 10)
    tabPadding.Parent = self.TabScrollFrame
    
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
    
    -- Improved toggle button
    self.ToggleButton = Instance.new("Frame")
    self.ToggleButton.Name = "ToggleButton"
    self.ToggleButton.Size = UDim2.new(0, 48, 0, 48)
    self.ToggleButton.Position = UDim2.new(0, 10, 0, 60) -- Position under Roblox logo
    self.ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.ToggleButton.BorderSizePixel = 0
    self.ToggleButton.Parent = self.ScreenGui
    self.ToggleButton.ZIndex = 10
    
    -- Add UI Corner to ToggleButton
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0) -- Make it completely round
    toggleButtonCorner.Parent = self.ToggleButton
    
    -- Add shadow to the toggle button
    local toggleShadow = Instance.new("Frame")
    toggleShadow.Name = "Shadow"
    toggleShadow.Size = UDim2.new(1, 8, 1, 8)
    toggleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    toggleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    toggleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toggleShadow.BackgroundTransparency = 0.6
    toggleShadow.BorderSizePixel = 0
    toggleShadow.ZIndex = 9
    toggleShadow.Parent = self.ToggleButton
    
    local toggleShadowCorner = Instance.new("UICorner")
    toggleShadowCorner.CornerRadius = UDim.new(1, 0)
    toggleShadowCorner.Parent = toggleShadow
    
    -- Add gradient to toggle button for better appearance
    local toggleGradient = Instance.new("UIGradient")
    toggleGradient.Rotation = 45
    toggleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 30, 30))
    })
    toggleGradient.Parent = self.ToggleButton
    
    -- Add icon to toggle button
    local toggleIcon = Instance.new("ImageLabel")
    toggleIcon.Name = "Icon"
    toggleIcon.Size = UDim2.new(0.6, 0, 0.6, 0)
    toggleIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    toggleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    toggleIcon.BackgroundTransparency = 1
    toggleIcon.Image = "rbxassetid://3926307971" -- Menu icon
    toggleIcon.ImageRectOffset = Vector2.new(604, 684)
    toggleIcon.ImageRectSize = Vector2.new(36, 36)
    toggleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    toggleIcon.ZIndex = 11
    toggleIcon.Parent = self.ToggleButton
    
    -- Add click detection for toggle button
    local toggleClickArea = Instance.new("TextButton")
    toggleClickArea.Name = "ClickArea"
    toggleClickArea.Size = UDim2.new(1, 0, 1, 0)
    toggleClickArea.Position = UDim2.new(0, 0, 0, 0)
    toggleClickArea.BackgroundTransparency = 1
    toggleClickArea.Text = ""
    toggleClickArea.ZIndex = 12
    toggleClickArea.Parent = self.ToggleButton
    
    -- Click handler for toggle button
    toggleClickArea.MouseButton1Click:Connect(function()
        self:ToggleUI()
    end)
    
    -- Make the toggle button draggable
    local toggleDragging = false
    local toggleDragInput
    local toggleDragStart
    local toggleStartPos
    
    toggleClickArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if input.UserInputState == Enum.UserInputState.Begin then
                toggleDragging = true
                toggleDragStart = input.Position
                toggleStartPos = self.ToggleButton.Position
            end
        end
    end)
    
    toggleClickArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleDragging = false
            
            -- Save toggle button position
            self.Settings["ToggleButtonPosition"] = {
                X = {Scale = self.ToggleButton.Position.X.Scale, Offset = self.ToggleButton.Position.X.Offset},
                Y = {Scale = self.ToggleButton.Position.Y.Scale, Offset = self.ToggleButton.Position.Y.Offset}
            }
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if toggleDragging then
                local delta = input.Position - toggleDragStart
                self.ToggleButton.Position = UDim2.new(
                    toggleStartPos.X.Scale, 
                    toggleStartPos.X.Offset + delta.X,
                    toggleStartPos.Y.Scale,
                    toggleStartPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    
    -- Make the main frame draggable
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            -- Save position when dragging ends
            self.LastPosition = self.MainFrame.Position
            -- Save position to settings
            self.Settings["UIPosition"] = {
                X = {Scale = self.MainFrame.Position.X.Scale, Offset = self.MainFrame.Position.X.Offset},
                Y = {Scale = self.MainFrame.Position.Y.Scale, Offset = self.MainFrame.Position.Y.Offset}
            }
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
function self:ToggleUI(state)
    -- First determine the requested state
    local newState
    if state ~= nil then
        newState = state
    else
        newState = not self.Visible
    end
    
    -- If new state is the same as current state, do nothing
    if newState == self.Visible then 
        return 
    end
    
    -- Update the state
    self.Visible = newState
    
    -- Change toggle button appearance based on state
    local colorSequence = self.Visible and 
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 30, 30))
        }) or 
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
        })
    toggleGradient.Color = colorSequence
    
    if self.Visible then
        -- SHOWING UI
        -- Make sure frame is visible first before animating
        self.MainFrame.Visible = true
        
        -- Use saved position
        self.MainFrame.Position = self.LastPosition
        
        -- Reset transparency for animation
        self.MainFrame.BackgroundTransparency = 1
        shadowFrame.BackgroundTransparency = 1
        
        -- Create the tweens
        local showTween1 = game:GetService("TweenService"):Create(
            self.MainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0}
        )
        
        local showTween2 = game:GetService("TweenService"):Create(
            shadowFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.6}
        )
        
        -- Play the tweens
        showTween1:Play()
        showTween2:Play()
    else
        -- HIDING UI
        -- Save position before hiding
        self.LastPosition = self.MainFrame.Position
        
        -- Create the tweens
        local hideTween1 = game:GetService("TweenService"):Create(
            self.MainFrame,
            TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {BackgroundTransparency = 1}
        )
        
        local hideTween2 = game:GetService("TweenService"):Create(
            shadowFrame,
            TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {BackgroundTransparency = 1}
        )
        
        -- Play the tweens
        hideTween1:Play()
        hideTween2:Play()
        
        -- Wait for animation to finish before hiding the frame
        spawn(function()
            wait(0.4) -- Match the tween duration
            if not self.Visible then -- Double check in case state changed
                self.MainFrame.Visible = false
            end
        end)
    end
end
    -- Method to create a tab
    function self:CreateTab(name)
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Text = name
        tabButton.Size = UDim2.new(0, 100, 0, 35)
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.TextSize = 16
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.BorderSizePixel = 0
        tabButton.Parent = self.TabScrollFrame  -- Add to the ScrollingFrame instead of TabBar directly
        tabButton.AutoButtonColor = false -- Disable default button color changing
        
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
        contentFrame.ScrollBarThickness = 4 -- Thinner scrollbar
        contentFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 50, 50) -- Custom scrollbar color
        contentFrame.Visible = false
        contentFrame.Parent = self.ContentFrame
        contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        
        -- Add UI List Layout to content frame
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        contentLayout.Parent = contentFrame
        
        -- Add padding to content frame
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 8)
        contentPadding.PaddingBottom = UDim.new(0, 8)
        contentPadding.Parent = contentFrame
        
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
                game:GetService("TweenService"):Create(
                    tab,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(45, 45, 45), TextColor3 = Color3.fromRGB(200, 200, 200)}
                ):Play()
            end
            
            -- Show this tab's content with animation
            contentFrame.Visible = true
            contentFrame.Position = UDim2.new(0.05, 0, 0, 10)
            contentFrame.BackgroundTransparency = 1
            
            game:GetService("TweenService"):Create(
                contentFrame,
                TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1}
            ):Play()
            
            -- Highlight selected tab with animation
            game:GetService("TweenService"):Create(
                tabButton,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(60, 60, 60), TextColor3 = Color3.fromRGB(255, 255, 255)}
            ):Play()
            
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
        button.Size = UDim2.new(1, -16, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 16
        button.Font = Enum.Font.GothamSemibold
        button.BorderSizePixel = 0
        button.Parent = self.TabContents[tab]
        button.AutoButtonColor = false -- Disable default button color changing
        
        -- Add UI Corner to button
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Hover and click effects
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}
            ):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}
            ):Play()
        end)
        
        button.MouseButton1Down:Connect(function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(75, 75, 75)}
            ):Play()
        end)
        
        button.MouseButton1Up:Connect(function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}
            ):Play()
        end)
        
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
        toggleContainer.Size = UDim2.new(1, -16, 0, 40)
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
        
        -- Modern toggle switch background
        local switchBg = Instance.new("Frame")
        switchBg.Name = "SwitchBackground"
        switchBg.Size = UDim2.new(0, 44, 0, 22)
        switchBg.Position = UDim2.new(1, -54, 0.5, -11)
        switchBg.BackgroundColor3 = default and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(100, 100, 100)
        switchBg.BorderSizePixel = 0
        switchBg.Parent = toggleContainer
        
        -- Add UI Corner to switch background
        local switchBgCorner = Instance.new("UICorner")
        switchBgCorner.CornerRadius = UDim.new(1, 0) -- Fully rounded corners
        switchBgCorner.Parent = switchBg
        
        -- Toggle switch knob
        local switchKnob = Instance.new("Frame")
        switchKnob.Name = "SwitchKnob"
        switchKnob.Size = UDim2.new(0, 18, 0, 18)
        switchKnob.Position = UDim2.new(default and 1 or 0, default and -20 or 2, 0.5, -9)
        switchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        switchKnob.BorderSizePixel = 0
        switchKnob.Parent = switchBg
        
        -- Add UI Corner to switch knob
        local switchKnobCorner = Instance.new("UICorner")
        switchKnobCorner.CornerRadius = UDim.new(1, 0) -- Fully rounded corners
        switchKnobCorner.Parent = switchKnob
        
        -- Set in settings
        self.Settings[name] = default
        
        -- Make the entire container clickable
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Text = ""
        toggleButton.Size = UDim2.new(1, 0, 1, 0)
        toggleButton.BackgroundTransparency = 1
        toggleButton.Parent = toggleContainer
        
        -- Click handler
        local state = default
        toggleButton.MouseButton1Click:Connect(function()
            state = not state
            
            -- Animate the switch
            game:GetService("TweenService"):Create(
                switchBg,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = state and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(100, 100, 100)}
            ):Play()
            
            game:GetService("TweenService"):Create(
                switchKnob,
                TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
                {Position = UDim2.new(state and 1 or 0, state and -20 or 2, 0.5, -9)}
            ):Play()
            
            self.Settings[name] = state
            callback(state)
        end)
        
        -- Hover effect
        toggleButton.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(
                toggleContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}
            ):Play()
        end)
        
        toggleButton.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(
                toggleContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}
            ):Play()
        end)
        
        self.Elements[name] = {
            type = "toggle",
            update = function(value)
                state = value
                game:GetService("TweenService"):Create(
                    switchBg,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    {BackgroundColor3 = state and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(100, 100, 100)}
                ):Play()
                
                game:GetService("TweenService"):Create(
                    switchKnob,
                    TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
                    {Position = UDim2.new(state and 1 or 0, state and -20 or 2, 0.5, -9)}
                ):Play()
                
                self.Settings[name] = state
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
        sliderContainer.Size = UDim2.new(1, -16, 0, 60)
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
        
        -- Slider knob
        local sliderKnob = Instance.new("Frame")
        sliderKnob.Name = "SliderKnob"
        sliderKnob.Size = UDim2.new(0, 16, 0, 16)
        sliderKnob.Position = UDim2.new(fillPercent, -8, 0.5, -8)
        sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderKnob.BorderSizePixel = 0
        sliderKnob.ZIndex = 2
        sliderKnob.Parent = sliderBg
        
        -- Add UI Corner to slider knob
        local sliderKnobCorner = Instance.new("UICorner")
        sliderKnobCorner.CornerRadius = UDim.new(1, 0)
        sliderKnobCorner.Parent = sliderKnob
        
        -- Set in settings
        self.Settings[name] = default
        
        -- Clickable slider area
        local sliderButton = Instance.new("TextButton")
        sliderButton.Name = "SliderButton"
        sliderButton.Text = ""
        sliderButton.Size = UDim2.new(1, 0, 1, 0)
        sliderButton.BackgroundTransparency = 1
        sliderButton.Parent = sliderBg
        
        -- Function to update slider
        local function updateSlider(value)
            value = math.clamp(value, min, max)
            local percent = (value - min) / (max - min)
            
            -- Animate slider components
            game:GetService("TweenService"):Create(
                sliderFill,
                TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Size = UDim2.new(percent, 0, 1, 0)}
            ):Play()
            
            game:GetService("TweenService"):Create(
                sliderKnob,
                TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Position = UDim2.new(percent, -8, 0.5, -8)}
            ):Play()
            
            -- Update value label with formatted number (1 decimal place)
            local formattedValue = math.floor(value * 10) / 10
            valueLabel.Text = tostring(formattedValue)
            
            self.Settings[name] = value
            callback(value)
        end
        
        -- Allow dragging the slider
        local dragging = false
        
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                
                -- Handle the initial click position
                local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = min + (relativeX * (max - min))
                updateSlider(value)
            end
        end)
        
        sliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        -- Extend the touch/click area
        sliderContainer.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                -- Only process if clicked in the lower part of the container (where the slider is)
                local yPos = input.Position.Y - sliderContainer.AbsolutePosition.Y
                if yPos > 30 then  -- Only if clicked in the lower part
                    dragging = true
                    
                    -- Handle the initial click position
                    local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local value = min + (relativeX * (max - min))
                    updateSlider(value)
                end
            end
        end)
        
        sliderContainer.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        -- Update during dragging
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = min + (relativeX * (max - min))
                updateSlider(value)
            end
        end)
        
        -- Hover effect for container
        sliderContainer.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(
                sliderContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}
            ):Play()
        end)
        
        sliderContainer.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(
                sliderContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}
            ):Play()
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
        notifContainer.Position = UDim2.new(1, 10, 1, -70 - notifContainer.AbsoluteSize.Y)
        notifContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        notifContainer.BorderSizePixel = 0
        notifContainer.Parent = self.ScreenGui
        notifContainer.BackgroundTransparency = 1 -- Start transparent for animation
        
        -- Add UI Corner to notification
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notifContainer
        
        -- Add shadow to notification
        local notifShadow = Instance.new("Frame")
        notifShadow.Name = "Shadow"
        notifShadow.Size = UDim2.new(1, 10, 1, 10)
        notifShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        notifShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        notifShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        notifShadow.BackgroundTransparency = 1 -- Start transparent for animation
        notifShadow.BorderSizePixel = 0
        notifShadow.ZIndex = -1
        notifShadow.Parent = notifContainer
        
        local notifShadowCorner = Instance.new("UICorner")
        notifShadowCorner.CornerRadius = UDim.new(0, 8)
        notifShadowCorner.Parent = notifShadow
        
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
        notifLabel.TextTransparency = 1 -- Start transparent for animation
        notifLabel.Parent = notifContainer
        
        -- Animate notification in
        game:GetService("TweenService"):Create(
            notifContainer,
            TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, -260, 1, -70), BackgroundTransparency = 0}
        ):Play()
        
        game:GetService("TweenService"):Create(
            notifShadow,
            TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.6}
        ):Play()
        
        game:GetService("TweenService"):Create(
            notifLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {TextTransparency = 0}
        ):Play()
        
        -- Remove notification after duration
        task.spawn(function()
            task.wait(duration)
            
            -- Animate notification out
            game:GetService("TweenService"):Create(
                notifContainer,
                TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                {Position = UDim2.new(1, 10, 1, -70), BackgroundTransparency = 1}
            ):Play()
            
            game:GetService("TweenService"):Create(
                notifShadow,
                TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                {BackgroundTransparency = 1}
            ):Play()
            
            game:GetService("TweenService"):Create(
                notifLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                {TextTransparency = 1}
            ):Play()
            
            -- Remove after animation
            task.wait(0.6)
            notifContainer:Destroy()
        end)
    end
    
    -- Method to apply saved settings
    function self:ApplySettings()
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
        
        -- Apply element-specific settings
        for name, element in pairs(self.Elements) do
            if self.Settings[name] ~= nil then
                element.update(self.Settings[name])
            end
        end
    end
    
    -- Initialize UI position based on device
    local function initializeUIPosition()
        local isMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled
        
        if isMobile then
            -- Mobile-specific adjustments
            self.MainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)  -- Larger relative size for mobile
            
            -- Position is already set to bottom with LastPosition
            
            -- Reposition toggle button to avoid overlap with Roblox mobile UI
            self.ToggleButton.Position = UDim2.new(0, 10, 0, 120) 
        end
    end
    
    -- Call the initialization function
    initializeUIPosition()
    
    -- Show initial animation
    self.MainFrame.BackgroundTransparency = 1
    shadowFrame.BackgroundTransparency = 1
        
    -- Run the animation
    game:GetService("TweenService"):Create(
        self.MainFrame,
        TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}  -- Move to saved position
    ):Play()
        
    game:GetService("TweenService"):Create(
        shadowFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.6}
    ):Play()
    
    return self
end

return RizeUILib
