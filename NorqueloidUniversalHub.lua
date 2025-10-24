-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NorqueloidUniversalHub"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Create Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 280)
frame.Position = UDim2.new(0.5, -160, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.ClipsDescendants = true

-- Add Corner Rounding
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

-- Add Gradient Background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
gradient.Rotation = 45
gradient.Parent = frame

-- Add Shadow
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = -1
shadow.Parent = frame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Norqueloid Universal Hub"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- Add Glow Effect to Title
local titleGlow = Instance.new("Frame")
titleGlow.Size = UDim2.new(1, -20, 0, 3)
titleGlow.Position = UDim2.new(0, 10, 1, -3)
titleGlow.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
titleGlow.BackgroundTransparency = 0.5
titleGlow.BorderSizePixel = 0
titleGlow.ZIndex = title.ZIndex - 1
titleGlow.Parent = frame

local titleGlowCorner = Instance.new("UICorner")
titleGlowCorner.CornerRadius = UDim.new(0, 2)
titleGlowCorner.Parent = titleGlow

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 1, -30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Select a hub to load"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = frame

-- Function to create a WindHub-style button
local function createButton(name, positionY, url, color)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0.85, 0, 0, 45)
    buttonFrame.Position = UDim2.new(0.075, 0, 0, positionY)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = buttonFrame

    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 80))
    }
    buttonGradient.Rotation = 90
    buttonGradient.Parent = buttonFrame

    local buttonText = Instance.new("TextLabel")
    buttonText.Size = UDim2.new(1, 0, 1, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = name
    buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonText.TextSize = 16
    buttonText.Font = Enum.Font.GothamSemibold
    buttonText.TextXAlignment = Enum.TextXAlignment.Center
    buttonText.TextYAlignment = Enum.TextYAlignment.Center
    buttonText.Parent = buttonFrame

    -- Hover Animation
    local hoverTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local hoverScale = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local originalSize = buttonFrame.Size

    buttonFrame.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, hoverTweenInfo, {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(buttonFrame, hoverScale, {Size = UDim2.new(originalSize.X.Scale * 1.02, 0, originalSize.Y.Scale * 1.02, 0)}):Play()
    end)

    buttonFrame.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, hoverTweenInfo, {BackgroundTransparency = 0}):Play()
        TweenService:Create(buttonFrame, hoverScale, {Size = originalSize}):Play()
    end)

    -- Click Animation
    local clickTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
    buttonFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            TweenService:Create(buttonFrame, clickTweenInfo, {Size = UDim2.new(originalSize.X.Scale * 0.95, 0, originalSize.Y.Scale * 0.95, 0)}):Play()
            wait(0.1)
            TweenService:Create(buttonFrame, clickTweenInfo, {Size = originalSize}):Play()
        end
    end)

    -- Execution Logic
    buttonFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            statusLabel.Text = "Loading " .. name .. "..."
            
            spawn(function()
                local success, err = pcall(function()
                    loadstring(game:HttpGet(url))()
                end)
                
                if success then
                    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                    statusLabel.Text = name .. " loaded successfully!"
                    
                    -- Success animation: brief glow
                    local successGlow = TweenService:Create(buttonFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {BackgroundTransparency = 0.3})
                    successGlow:Play()
                else
                    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                    statusLabel.Text = "Failed to load " .. name .. "!"
                    warn("Execution error for " .. name .. ": " .. tostring(err))
                    
                    -- Error animation: shake
                    local shakeTween = TweenInfo.new(0.05, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    for i = 1, 3 do
                        TweenService:Create(buttonFrame, shakeTween, {Position = UDim2.new(buttonFrame.Position.X.Scale + 0.01, 0, buttonFrame.Position.Y.Scale, 0)}):Play()
                        wait(0.05)
                        TweenService:Create(buttonFrame, shakeTween, {Position = UDim2.new(buttonFrame.Position.X.Scale - 0.01, 0, buttonFrame.Position.Y.Scale, 0)}):Play()
                        wait(0.05)
                    end
                end
                
                -- Reset status after 3 seconds
                wait(3)
                statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
                statusLabel.Text = "Select a hub to load
