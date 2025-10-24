-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Debug: Confirm script is running
print("Norqueloid Universal Hub: Script started")

-- Load WindUI library
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success then
    warn("Norqueloid Universal Hub: Failed to load WindUI library: " .. tostring(WindUI))
    return
end
print("Norqueloid Universal Hub: WindUI library loaded")

-- Gradient text function (from example)
local function gradient(text, startColor, endColor)
    local result = ""
    local length = #text
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + ((endColor.R - startColor.R) * t)) * 255)
        local g = math.floor((startColor.G + ((endColor.G - startColor.G) * t)) * 255)
        local b = math.floor((startColor.B + ((endColor.B - startColor.B) * t)) * 255)
        local char = text:sub(i, i)
        result = result .. '<font color=\"rgb(' .. r .. ", " .. g .. ", " .. b .. ')\">' .. char .. "</font>"
    end
    return result
end

-- Create WindUI Window
local Window = WindUI:CreateWindow({
    Title = gradient("Norqueloid Universal Hub", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Icon = "rocket", -- Common icon for hubs
    Author = "Script Loader (2025)",
    Folder = "NorqueloidHub",
    Size = UDim2.fromOffset(400, 320),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 150,
    UserEnabled = true,
    HasOutline = true
})
print("Norqueloid Universal Hub: Window created")

-- Create Main Tab
local MainTab = Window:Tab({Title = "Scripts", Icon = "script"})

-- Function to create and handle script execution button
local function createScriptButton(name, url)
    MainTab:Button({
        Title = name,
        Callback = function()
            WindUI:Notify({
                Title = "Loading " .. name,
                Content = "Attempting to execute script...",
                Icon = "rocket",
                Duration = 3
            })
            print("Norqueloid Universal Hub: Attempting to load " .. name)
            
            spawn(function()
                local success, err = pcall(function()
                    local scriptContent = game:HttpGet(url)
                    if not scriptContent or scriptContent == "" then
                        error("Failed to fetch script for " .. name)
                    end
                    local func = loadstring(scriptContent)
                    if not func then
                        error("Failed to compile script for " .. name)
                    end
                    func()
                end)
                
                if success then
                    WindUI:Notify({
                        Title = name .. " Loaded",
                        Content = "Script executed successfully!",
                        Icon = "check-circle",
                        Duration = 3
                    })
                    print("Norqueloid Universal Hub: " .. name .. " loaded successfully")
                else
                    WindUI:Notify({
                        Title = name .. " Failed",
                        Content = "Error: " .. tostring(err),
                        Icon = "x-circle",
                        Duration = 5
                    })
                    print("Norqueloid Universal Hub: Error for " .. name .. ": " .. tostring(err))
                end
            end)
        end
    })
end

-- Create buttons for each script
createScriptButton("Miranda Hub", "https://pastefy.app/JJVhs3rK/raw")
createScriptButton("Lennon Hub", "https://pastefy.app/MJw2J4T6/raw")
createScriptButton("Lemon Hub", "https://api.luarmor.net/files/v3/loaders/2341c827712daf923191e93377656f67.lua")
print("Norqueloid Universal Hub: Buttons created")

-- Toggle GUI visibility with RightShift
local toggleKey = Enum.KeyCode.RightShift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == toggleKey then
        Window:Toggle()
        print("Norqueloid Universal Hub: Window toggled")
    end
end)

-- Initial notification
WindUI:Notify({
    Title = "Norqueloid Universal Hub",
    Content = "Press RightShift to toggle. Click a button to load a script.",
    Icon = "info",
    Duration = 5
})
print("Norqueloid Universal Hub: GUI initialized and should be visible")
