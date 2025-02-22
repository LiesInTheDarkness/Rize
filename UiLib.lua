-- Rize UI Library (UI Handling Only) -- Provides a structured UI framework for Rize Executor

local RizeUILib = {}

-- Table to store UI elements RizeUILib.Elements = {} RizeUILib.Notifications = {}

-- Function to create the main UI frame function RizeUILib:CreateMainFrame() local mainScreenGui = Instance.new("ScreenGui") mainScreenGui.Name = "RizeUI" mainScreenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 460, 0, 560)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -280)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = mainScreenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

RizeUILib.MainFrame = mainFrame
return mainFrame

end

-- Function to create a tab system function RizeUILib:CreateTab(name) local tab = Instance.new("Frame") tab.Size = UDim2.new(1, 0, 0, 40) tab.BackgroundColor3 = Color3.fromRGB(20, 20, 20) tab.Parent = RizeUILib.MainFrame

local label = Instance.new("TextLabel")
label.Text = name
label.Size = UDim2.new(1, 0, 1, 0)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.BackgroundTransparency = 1
label.Parent = tab

return tab

end

-- Function to create a notification function RizeUILib:CreateNotification(message, duration) local notification = Instance.new("TextLabel") notification.Size = UDim2.new(0, 300, 0, 50) notification.Position = UDim2.new(0.5, -150, 0.05, #RizeUILib.Notifications * 55) notification.Text = message notification.TextColor3 = Color3.fromRGB(255, 255, 255) notification.Font = Enum.Font.GothamBold notification.TextScaled = true notification.BackgroundColor3 = Color3.fromRGB(50, 50, 50) notification.Parent = RizeUILib.MainFrame

table.insert(RizeUILib.Notifications, notification)
task.delay(duration or 3, function()
    notification:Destroy()
end)

end

return RizeUILib
