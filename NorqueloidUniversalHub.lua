-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NorqueloidUniversalHub"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Norqueloid Universal Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 20)
statusLabel.Position = UDim2.new(0, 5, 1, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Select a hub to load"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = frame

-- Function to create a clean TextButton
local function createButton(name, positionY, url, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 30)
    button.Position = UDim2.new(0.1, 0, 0, positionY)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.SourceSans
    button.Parent = frame

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
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                statusLabel.Text = name .. " loaded!"
            else
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                statusLabel.Text = "Failed: " .. name
                warn("Error for " .. name .. ": " .. tostring(err))
            end
            
            -- Reset status after 3 seconds
            wait(3)
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            statusLabel.Text = "Select a hub to load"
        end)
    end)
end

-- Create buttons for each hub
createButton("Miranda Hub", 40, "https://pastefy.app/JJVhs3rK/raw", Color3.fromRGB(60, 60, 60))
createButton("Lennon Hub", 80, "https://pastefy.app/MJw2J4T6/raw", Color3.fromRGB(60, 60, 60))
createButton("Lemon Hub", 120, "https://api.luarmor.net/files/v3/loaders/2341c827712daf923191e93377656f67.lua", Color3.fromRGB(60, 60, 60))

-- Draggable Functionality
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle GUI visibility with RightShift
local toggleKey = Enum.KeyCode.RightShift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == toggleKey then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Initial status
statusLabel.Text = "Press RightShift to toggle"
