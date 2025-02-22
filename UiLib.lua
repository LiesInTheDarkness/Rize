-- Rize UI Library (UI Handling Only) -- Provides a structured UI framework for Rize Executor

local RizeUILib = {}

-- Table to store UI elements RizeUILib.Elements = {} RizeUILib.Notifications = {}

-- Function to create the main UI frame function RizeUILib:CreateMainFrame() local mainFrame = Instance.new("ScreenGui") mainFrame.Name = "RizeUI" mainFrame.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 460, 0, 560)
frame.Position = UDim2.new(0.5, -230, 0.5, -280)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = mainFrame

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(120, 120, 120)
uiStroke.Parent = frame

self.MainFrame = frame
return frame

end

-- Function to create a tab system function RizeUILib:CreateTab(name) local tab = Instance.new("Frame") tab.Size = UDim2.new(1, 0, 0, 40) tab.BackgroundColor3 = Color3.fromRGB(20, 20, 20) tab.Parent = self.MainFrame

local label = Instance.new("TextLabel")
label.Text = name
label.Size = UDim2.new(1, 0, 1, 0)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.BackgroundTransparency = 1
label.Parent = tab

table.insert(self.Elements, tab)
return tab

end

-- Function to create a notification function RizeUILib:CreateNotification(message, duration) local notification = Instance.new("TextLabel") notification.Size = UDim2.new(0, 300, 0, 50) notification.Position = UDim2.new(0.5, -150, 0.05, #self.Notifications * 55) notification.Text = message notification.TextColor3 = Color3.fromRGB(255, 255, 255) notification.Font = Enum.Font.GothamBold notification.TextScaled = true notification.BackgroundColor3 = Color3.fromRGB(50, 50, 50) notification.Parent = self.MainFrame

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = notification

table.insert(self.Notifications, notification)
task.delay(duration or 3, function()
    notification:Destroy()
end)

end

-- Function to create a slider function RizeUILib:CreateSlider(tab, name, min, max, default, callback) local sliderFrame = Instance.new("Frame") sliderFrame.Size = UDim2.new(1, -10, 0, 40) sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60) sliderFrame.Parent = tab

local label = Instance.new("TextLabel")
label.Text = name .. " (" .. default .. ")"
label.Size = UDim2.new(1, 0, 0.5, 0)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.Gotham
label.TextScaled = true
label.Parent = sliderFrame

local slider = Instance.new("TextButton")
slider.Size = UDim2.new(0, 200, 0, 10)
slider.Position = UDim2.new(0.5, -100, 0.7, 0)
slider.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
slider.Parent = sliderFrame

local function updateSlider(value)
    label.Text = name .. " (" .. value .. ")"
    callback(value)
end

slider.MouseButton1Click:Connect(function()
    updateSlider(math.random(min, max)) -- Placeholder for real slider movement
end)

table.insert(self.Elements, sliderFrame)
return sliderFrame

end

-- Function to create a toggle button function RizeUILib:CreateToggle(tab, name, default, callback) local toggleFrame = Instance.new("Frame") toggleFrame.Size = UDim2.new(1, -10, 0, 35) toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60) toggleFrame.Parent = tab

local label = Instance.new("TextLabel")
label.Text = name
label.Size = UDim2.new(1, -40, 1, 0)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.Gotham
label.TextScaled = true
label.Parent = toggleFrame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 30, 0, 30)
button.Position = UDim2.new(1, -35, 0.5, -15)
button.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
button.Parent = toggleFrame

local state = default
button.MouseButton1Click:Connect(function()
    state = not state
    button.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    callback(state)
end)

table.insert(self.Elements, toggleFrame)
return toggleFrame

end

return RizeUILib
