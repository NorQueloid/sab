local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Function to hide Roblox UI elements
local function hideRobloxUI()
    -- Wait for the local player
    local player = Players.LocalPlayer
    if not player then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        player = Players.LocalPlayer
    end

    -- Disable all CoreGui elements
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        print("Attempted to disable all CoreGui elements")
    end)

    -- Target specific CoreGui elements
    pcall(function()
        -- List of known CoreGui elements to hide
        local uiElements = {
            "TopBarApp", -- Roblox logo and topbar
            "PlayerList", -- Leaderboard
            "Chat", -- Chat interface
            "RobloxGui", -- Legacy Roblox GUI
            "Menu", -- In-game menu
        }

        for _, elementName in ipairs(uiElements) do
            local element = CoreGui:FindFirstChild(elementName)
            if element then
                element.Enabled = false
                print("Hid element: " .. elementName)
            else
                print("Element not found: " .. elementName)
            end
        end

        -- Iterate through all CoreGui children to hide any ScreenGui or GuiMain
        local coreGuiChildren = CoreGui:GetChildren()
        for _, child in ipairs(coreGuiChildren) do
            if child:IsA("ScreenGui") or child:IsA("GuiMain") then
                pcall(function()
                    child.Enabled = false
                    print("Hid CoreGui child: " .. child.Name)
                end)
            end
        end
    end)

    -- Additional attempt to hide topbar via CoreGui properties
    pcall(function()
        local topbar = CoreGui:FindFirstChild("TopBarApp") or CoreGui:FindFirstChild("RobloxTopBar")
        if topbar then
            topbar.Enabled = false
            print("Topbar explicitly hidden")
        else
            print("Topbar not found")
        end
    end)

    -- Forcefully hide any remaining visible UI elements in CoreGui
    pcall(function()
        for _, gui in ipairs(CoreGui:GetDescendants()) do
            if gui:IsA("GuiObject") then
                gui.Visible = false
                print("Set Visible to false for: " .. gui.Name)
            end
        end
    end)
end

-- Function to hide game-specific UI (settings and backpack)
local function hideGameUI()
    pcall(function()
        -- Search PlayerGui for settings and backpack UI
        local guiElements = PlayerGui:GetChildren()
        for _, gui in ipairs(guiElements) do
            if gui:IsA("ScreenGui") then
                -- Check for settings or backpack by name or content
                local guiChildren = gui:GetDescendants()
                for _, element in ipairs(guiChildren) do
                    if element:IsA("GuiObject") and (element.Name:lower():find("setting") or element.Name:lower():find("backpack") or element.Text:lower():find("setting") or element.Text:lower():find("backpack")) then
                        element.Visible = false
                        element.Active = false
                        print("Hid game UI element: " .. element.Name .. " in " .. gui.Name)
                    end
                end
                -- Disable the entire ScreenGui if it seems related to settings/backpack
                if gui.Name:lower():find("setting") or gui.Name:lower():find("backpack") then
                    gui.Enabled = false
                    print("Disabled game ScreenGui: " .. gui.Name)
                end
            end
        end
    end)
end

-- Function to disable the Roblox menu as a fallback
local function disableMenu()
    pcall(function()
        local robloxGui = CoreGui:FindFirstChild("RobloxGui")
        if robloxGui then
            local menuNames = {"InGameMenu", "CoreScripts", "Menu", "SettingsMenu", "GameMenu", "CoreGuiMenu"}
            for _, menuName in ipairs(menuNames) do
                local menu = robloxGui:FindFirstChild(menuName)
                if menu then
                    if menu.Enabled then
                        menu.Enabled = false
                        print("Disabled menu: " .. menuName)
                    end
                    -- Hide all descendants to ensure menu is invisible
                    for _, descendant in ipairs(menu:GetDescendants()) do
                        if descendant:IsA("GuiObject") and descendant.Visible then
                            descendant.Visible = false
                            print("Hid menu element: " .. descendant.Name .. " in " .. menuName)
                        end
                    end
                else
                    print("Menu not found: " .. menuName)
                end
            end
        else
            print("RobloxGui not found")
        end
    end)
end

-- Function to detect Esc and simulate Esc + Enter
local function autoCloseMenu()
    pcall(function()
        UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
                print("Detected Esc press | GameProcessed: " .. tostring(gameProcessedEvent))
                -- Attempt to simulate Esc + Enter press
                pcall(function()
                    local VirtualInputManager = game:GetService("VirtualInputManager")
                    -- Simulate Esc press and release
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
                    wait(0.01) -- Small delay for key press
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
                    -- Simulate Enter press and release
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    print("Simulated Esc + Enter to close menu")
                end)
                -- Fallback: Disable menu UI elements
                disableMenu()
            end
        end)
        print("Esc handler set up")
    end)
end

-- Run the functions
hideRobloxUI()
hideGameUI()
autoCloseMenu()

-- Fast loop to ensure UI and menu stay disabled
RunService.RenderStepped:Connect(function()
    pcall(function()
        -- Re-hide topbar
        local topbar = CoreGui:FindFirstChild("TopBarApp")
        if topbar and topbar.Enabled then
            topbar.Enabled = false
            print("Re-hid TopBarApp")
        end
        -- Re-disable menu
        local robloxGui = CoreGui:FindFirstChild("RobloxGui")
        if robloxGui then
            local menuNames = {"InGameMenu", "CoreScripts", "Menu", "SettingsMenu", "GameMenu", "CoreGuiMenu"}
            for _, menuName in ipairs(menuNames) do
                local menu = robloxGui:FindFirstChild(menuName)
                if menu and menu.Enabled then
                    menu.Enabled = false
                    print("Re-disabled menu: " .. menuName .. " during RenderStepped")
                    for _, descendant in ipairs(menu:GetDescendants()) do
                        if descendant:IsA("GuiObject") and descendant.Visible then
                            descendant.Visible = false
                            print("Re-hid menu element: " .. descendant.Name .. " in " .. menuName)
                        end
                    end
                end
            end
        end
        -- Re-hide game-specific UI
        local guiElements = PlayerGui:GetChildren()
        for _, gui in ipairs(guiElements) do
            if gui:IsA("ScreenGui") and (gui.Name:lower():find("setting") or gui.Name:lower():find("backpack")) and gui.Enabled then
                gui.Enabled = false
                print("Re-disabled game ScreenGui: " .. gui.Name)
            end
            local guiChildren = gui:GetDescendants()
            for _, element in ipairs(guiChildren) do
                if element:IsA("GuiObject") and (element.Name:lower():find("setting") or element.Name:lower():find("backpack") or element.Text:lower():find("setting") or element.Text:lower():find("backpack")) and element.Visible then
                    element.Visible = false
                    element.Active = false
                    print("Re-hid game UI element: " .. element.Name .. " in " .. gui.Name)
                end
            end
        end
    end)
end)
