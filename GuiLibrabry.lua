-- Extended GuiLibrary.lua

local GuiLibrary = {}

-- Create a new GUI Window
function GuiLibrary:CreateWindow(windowTitle)
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")

    ScreenGui.Name = "CustomGUI"
    ScreenGui.Parent = game.CoreGui

    Frame.Name = "MainFrame"
    Frame.Size = UDim2.new(0, 300, 0, 200)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Text = windowTitle or "Window"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.Parent = Frame

    return {
        Window = Frame,
        ScreenGui = ScreenGui
    }
end

-- Add a Button
function GuiLibrary:CreateButton(parent, buttonText, callback)
    local Button = Instance.new("TextButton")

    Button.Name = buttonText .. "Button"
    Button.Size = UDim2.new(0, 100, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.BorderSizePixel = 0
    Button.Text = buttonText or "Button"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    Button.Parent = parent

    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return Button
end

-- Add a Label
function GuiLibrary:CreateLabel(parent, labelText)
    local Label = Instance.new("TextLabel")

    Label.Name = labelText .. "Label"
    Label.Size = UDim2.new(0, 100, 0, 30)
    Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Label.BorderSizePixel = 0
    Label.Text = labelText or "Label"
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.Parent = parent

    return Label
end

-- Add a Toggle
function GuiLibrary:CreateToggle(parent, toggleText, callback)
    local ToggleFrame = Instance.new("Frame")
    local ToggleButton = Instance.new("TextButton")
    local ToggleState = false

    ToggleFrame.Size = UDim2.new(0, 100, 0, 30)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent

    ToggleButton.Size = UDim2.new(0, 30, 0, 30)
    ToggleButton.Position = UDim2.new(0, 5, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0, 60, 0, 30)
    ToggleLabel.Position = UDim2.new(0, 40, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = toggleText or "Toggle"
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.Font = Enum.Font.SourceSans
    ToggleLabel.TextSize = 14
    ToggleLabel.Parent = ToggleFrame

    ToggleButton.MouseButton1Click:Connect(function()
        ToggleState = not ToggleState
        ToggleButton.BackgroundColor3 = ToggleState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        if callback then
            callback(ToggleState)
        end
    end)

    return ToggleFrame
end

-- Add a Slider
function GuiLibrary:CreateSlider(parent, sliderText, min, max, callback)
    local SliderFrame = Instance.new("Frame")
    local SliderBar = Instance.new("Frame")
    local SliderButton = Instance.new("TextButton")
    local SliderLabel = Instance.new("TextLabel")

    SliderFrame.Size = UDim2.new(0, 200, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent

    SliderBar.Size = UDim2.new(0, 150, 0, 10)
    SliderBar.Position = UDim2.new(0, 25, 0, 20)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.Parent = SliderFrame

    SliderButton.Size = UDim2.new(0, 10, 0, 20)
    SliderButton.Position = UDim2.new(0, 25, 0, 15)
    SliderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SliderButton.Text = ""
    SliderButton.Parent = SliderFrame

    SliderLabel.Size = UDim2.new(0, 200, 0, 20)
    SliderLabel.Position = UDim2.new(0, 0, 0, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = sliderText .. ": " .. min
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.Font = Enum.Font.SourceSans
    SliderLabel.TextSize = 14
    SliderLabel.Parent = SliderFrame

    local function UpdateSlider(input)
        local value = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderButton.Position = UDim2.new(value, -5, 0, 15)
        local sliderValue = math.floor(min + (max - min) * value)
        SliderLabel.Text = sliderText .. ": " .. sliderValue
        if callback then
            callback(sliderValue)
        end
    end

    SliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                UpdateSlider(input)
            end
        end)
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)

    return SliderFrame
end

return GuiLibrary
