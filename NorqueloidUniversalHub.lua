-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NorqueloidUniversalHub"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 240)
frame.Position = UDim2.new(0.5, -140, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.ClipsDescendants = true

-- Add Corner Rounding
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- Add Gradient Background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
}
gradient.Rotation = 45
gradient.Parent = frame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Norqueloid Universal Hub"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 1, -40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Select a hub to load"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = frame

-- Function to create a WindUI-style TextButton
local function createButton(name, positionY, url, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 35)
    button.Position = UDim2.new(0.1, 0, 0, positionY)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.GothamSemibold
    button.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    -- Hover Animation
    local hoverTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, hoverTweenInfo, {BackgroundTransparency = 0.1, Size = UDim2.new(0.82, 0, 0, 38)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, hoverTweenInfo, {BackgroundTransparency = 0, Size = UDim2.new(0.8, 0, 0, 35)}):Play()
    end)

    -- Click Animation
    local clickTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, clickTweenInfo, {Size = UDim2.new(0.78, 0, 0, 33)}):Play()
    end)
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, clickTweenInfo, {Size = UDim2.new(0.8, 0, 0, 35)}):Play()
    end)

    -- Execution Logic
    button.MouseButton1Click:Connect(function()
        statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        statusLabel.Text = "Loading " .. name .. "..."
        
        spawn(function()
            local success, err = pcall(function()
                local scriptContent = game:HttpGet(url)
                if not scriptContent or scriptContent == "" then
                    error("Failed to fetch script from " .. name)
                end
                local func = loadstring(scriptContent)
                if not func then
                    error("Failed to compile script for " .. name)
                end
                func()
            end)
            
            if success then
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                statusLabel.Text = name .. " loaded successfully!"
            else
                statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                statusLabel.Text = "Failed to load " .. name .. "!"
                warn("Execution error for " .. name .. ": " .. tostring(err))
            end
            
            -- Reset status after 3 seconds
            wait(3)
            statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
            statusLabel.Text = "Select a hub to load"
        end)
    end)
end

-- Create buttons for each hub
createButton("Miranda Hub", 60, "https://pastefy.app/JJVhs3rK/raw", Color3.fromRGB(120, 80, 200))
createButton("Lennon Hub", 105, "https://pastefy.app/MJw2J4T6/raw", Color3.fromRGB(80, 200, 120))
createButton("Lemon Hub", 150, "https://api.luarmor.net/files/v3/loaders/2341c827712daf923191e93377656f67.lua", Color3.fromRGB(255, 180, 80))

-- Draggable Functionality
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState
