-- 🎮 SECURE CLIENT-SIDE SCRIPT - ENHANCED GLITCH AURA RNG
-- This handles UI and communicates with the secure server

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for remote events to be created by server
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local rollGlitchRemote = remoteEvents:WaitForChild("RollGlitch")
local redeemCodeRemote = remoteEvents:WaitForChild("RedeemCode")
local usePotionRemote = remoteEvents:WaitForChild("UsePotion")
local purchaseItemRemote = remoteEvents:WaitForChild("PurchaseItem")
local sellItemRemote = remoteEvents:WaitForChild("SellItem")
local getPlayerDataRemote = remoteEvents:WaitForChild("GetPlayerData")
local achievementUnlockedEvent = remoteEvents:WaitForChild("AchievementUnlocked")

-- 🎯 CLIENT GAME DATA (Synced from server)
local ClientGameData = {}

-- 🎵 ENHANCED SOUND SYSTEM
local SoundAssets = {
    roll = "131961136",
    common = "131961136",
    uncommon = "131961136", 
    rare = "131961136",
    epic = "131961136",
    legendary = "131961136",
    mythic = "131961136",
    divine = "131961136",
    coin = "131961136",
    error = "131961136",
    success = "131961136",
    level_up = "131961136",
    achievement = "131961136"
}

-- 📱 RESPONSIVE HELPER
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- 🎵 SOUND SYSTEM
local function playSound(soundType, volume)
    if not ClientGameData.settings or not ClientGameData.settings.soundEnabled then return end
    
    local soundId = SoundAssets[soundType] or SoundAssets.roll
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume = volume or 0.5
    sound.Parent = SoundService
    sound:Play()
    
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- ✨ PARTICLE EFFECTS SYSTEM
local function createParticleEffect(position, color, rarity)
    if not ClientGameData.settings or not ClientGameData.settings.particlesEnabled then return end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "ParticleEffect"
    gui.IgnoreGuiInset = true
    gui.Parent = playerGui
    
    local particleCount = rarity == "Divine" and 25 or rarity == "Mythic" and 20 or rarity == "Legendary" and 15 or 8
    
    for i = 1, particleCount do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(4, 10), 0, math.random(4, 10))
        particle.Position = UDim2.new(0, position.X + math.random(-60, 60), 0, position.Y + math.random(-60, 60))
        particle.BackgroundColor3 = color
        particle.BorderSizePixel = 0
        particle.Parent = gui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle
        
        -- Enhanced particle animation
        local tween = TweenService:Create(particle, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, position.X + math.random(-250, 250), 0, position.Y + math.random(-250, 250)),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = math.random(-360, 360)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            particle:Destroy()
        end)
    end
    
    task.spawn(function()
        task.wait(4)
        if gui.Parent then
            gui:Destroy()
        end
    end)
end

-- 🔔 ENHANCED NOTIFICATION SYSTEM
local function showNotification(message, color, duration, icon, isSpecial)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "NotificationGui"
    notifGui.IgnoreGuiInset = true
    notifGui.ResetOnSpawn = false
    notifGui.Parent = playerGui
    
    local size = isSpecial and UDim2.new(0, isMobile() and 380 or 480, 0, isMobile() and 90 or 110) or
                              UDim2.new(0, isMobile() and 320 or 400, 0, isMobile() and 70 or 90)
    
    local notification = Instance.new("Frame")
    notification.Size = size
    notification.Position = UDim2.new(0.5, -size.X.Offset/2, 0, -120)
    notification.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.Parent = notifGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, isSpecial and 20 or 15)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = isSpecial and 4 or 2
    stroke.Transparency = 0.2
    stroke.Parent = notification
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, color or Color3.fromRGB(200, 200, 200))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0.4)
    })
    gradient.Parent = notification
    
    -- Icon
    if icon then
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, isSpecial and 60 or 40, 0, isSpecial and 60 or 40)
        iconLabel.Position = UDim2.new(0, 15, 0.5, isSpecial and -30 or -20)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextScaled = true
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Parent = notification
    end
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, icon and (isSpecial and -90 or -70) or -30, 1, 0)
    text.Position = UDim2.new(0, icon and (isSpecial and 85 or 65) or 15, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextScaled = true
    text.Font = isSpecial and Enum.Font.GothamBold or Enum.Font.GothamBold
    text.TextStrokeTransparency = 0.3
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.Parent = notification
    
    -- Special effects for achievements
    if isSpecial then
        local glow = Instance.new("UIGlow")
        glow.Color = color
        glow.Intensity = 0.5
        glow.Parent = notification
        
        -- Pulsing effect
        local pulseIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Size = size + UDim2.new(0, 10, 0, 5)
        })
        pulseIn:Play()
        
        task.spawn(function()
            task.wait(duration or 6)
            pulseIn:Cancel()
        end)
    end
    
    -- Animate in
    TweenService:Create(notification, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -size.X.Offset/2, 0, 30)
    }):Play()
    
    -- Auto remove
    task.spawn(function()
        task.wait(duration or (isSpecial and 6 or 4))
        TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -size.X.Offset/2, 0, -120),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.5)
        notifGui:Destroy()
    end)
end

-- 🎨 ENHANCED FLOATING PANEL FUNCTION
local function createFloatingPanel(title, size, hasCloseButton)
    local panelGui = Instance.new("ScreenGui")
    panelGui.Name = title .. "Panel"
    panelGui.IgnoreGuiInset = true
    panelGui.ResetOnSpawn = false
    panelGui.Parent = playerGui
    
    -- Background blur with click detection
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0
    background.Parent = panelGui
    
    -- Main panel with enhanced styling
    local panel = Instance.new("Frame")
    panel.Size = size
    panel.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    panel.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    panel.BackgroundTransparency = 0.05
    panel.BorderSizePixel = 0
    panel.Parent = panelGui
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 25)
    panelCorner.Parent = panel
    
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(120, 160, 255)
    panelStroke.Thickness = 4
    panelStroke.Transparency = 0.4
    panelStroke.Parent = panel
    
    local panelGradient = Instance.new("UIGradient")
    panelGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 85)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 65))
    })
    panelGradient.Rotation = 45
    panelGradient.Parent = panel
    
    -- Enhanced header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 80)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    header.Parent = panel
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 25)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 110, 160)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 80, 130))
    })
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, hasCloseButton ~= false and -120 or -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 30, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextStrokeTransparency = 0.3
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.Parent = header
    
    -- Close button (optional)
    local closeButton = nil
    if hasCloseButton ~= false then
        closeButton = Instance.new("TextButton")
        closeButton.Size = UDim2.new(0, 60, 0, 60)
        closeButton.Position = UDim2.new(1, -70, 0.5, -30)
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        closeButton.BackgroundTransparency = 0.2
        closeButton.BorderSizePixel = 0
        closeButton.Text = "✕"
        closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeButton.TextScaled = true
        closeButton.Font = Enum.Font.GothamBold
        closeButton.Parent = header
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(1, 0)
        closeCorner.Parent = closeButton
    end
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -40, 1, -100)
    contentFrame.Position = UDim2.new(0, 20, 0, 90)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = panel
    
    -- Animate in with enhanced effect
    panel.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(panel, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = size
    }):Play()
    
    -- Close function
    local function closePanel()
        TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.5)
        panelGui:Destroy()
    end
    
    -- Enhanced button interactions
    if closeButton then
        closeButton.MouseEnter:Connect(function()
            TweenService:Create(closeButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 120, 120),
                Size = UDim2.new(0, 65, 0, 65)
            }):Play()
        end)
        
        closeButton.MouseLeave:Connect(function()
            TweenService:Create(closeButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 80, 80),
                Size = UDim2.new(0, 60, 0, 60)
            }):Play()
        end)
        
        closeButton.MouseButton1Click:Connect(closePanel)
    end
    
    background.MouseButton1Click:Connect(closePanel)
    
    return contentFrame, closePanel
end

-- 💰 ENHANCED CURRENCY DISPLAY
local function createCurrencyDisplay()
    local currencyGui = Instance.new("ScreenGui")
    currencyGui.Name = "CurrencyDisplay"
    currencyGui.IgnoreGuiInset = true
    currencyGui.ResetOnSpawn = false
    currencyGui.Parent = playerGui
    
    -- Coins display
    local coinFrame = Instance.new("Frame")
    coinFrame.Size = UDim2.new(0, isMobile() and 180 or 220, 0, isMobile() and 60 or 70)
    coinFrame.Position = UDim2.new(0, 15, 0, 15)
    coinFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    coinFrame.BackgroundTransparency = 0.1
    coinFrame.BorderSizePixel = 0
    coinFrame.Parent = currencyGui
    
    local coinCorner = Instance.new("UICorner")
    coinCorner.CornerRadius = UDim.new(0, 18)
    coinCorner.Parent = coinFrame
    
    local coinStroke = Instance.new("UIStroke")
    coinStroke.Color = Color3.fromRGB(255, 215, 0)
    coinStroke.Thickness = 3
    coinStroke.Transparency = 0.3
    coinStroke.Parent = coinFrame
    
    local coinGradient = Instance.new("UIGradient")
    coinGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 70))
    })
    coinGradient.Rotation = 45
    coinGradient.Parent = coinFrame
    
    local coinIcon = Instance.new("TextLabel")
    coinIcon.Size = UDim2.new(0, 40, 0, 40)
    coinIcon.Position = UDim2.new(0, 10, 0.5, -20)
    coinIcon.BackgroundTransparency = 1
    coinIcon.Text = "💰"
    coinIcon.TextScaled = true
    coinIcon.Font = Enum.Font.GothamBold
    coinIcon.Parent = coinFrame
    
    local coinLabel = Instance.new("TextLabel")
    coinLabel.Size = UDim2.new(1, -60, 1, 0)
    coinLabel.Position = UDim2.new(0, 55, 0, 0)
    coinLabel.BackgroundTransparency = 1
    coinLabel.Text = "0"
    coinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    coinLabel.TextScaled = true
    coinLabel.Font = Enum.Font.GothamBold
    coinLabel.TextStrokeTransparency = 0.5
    coinLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    coinLabel.Parent = coinFrame
    
    -- Gems display
    local gemFrame = Instance.new("Frame")
    gemFrame.Size = UDim2.new(0, isMobile() and 140 or 170, 0, isMobile() and 60 or 70)
    gemFrame.Position = UDim2.new(0, isMobile() and 205 or 250, 0, 15)
    gemFrame.BackgroundColor3 = Color3.fromRGB(70, 50, 90)
    gemFrame.BackgroundTransparency = 0.1
    gemFrame.BorderSizePixel = 0
    gemFrame.Parent = currencyGui
    
    local gemCorner = Instance.new("UICorner")
    gemCorner.CornerRadius = UDim.new(0, 18)
    gemCorner.Parent = gemFrame
    
    local gemStroke = Instance.new("UIStroke")
    gemStroke.Color = Color3.fromRGB(200, 100, 255)
    gemStroke.Thickness = 3
    gemStroke.Transparency = 0.3
    gemStroke.Parent = gemFrame
    
    local gemGradient = Instance.new("UIGradient")
    gemGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 70, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 50, 90))
    })
    gemGradient.Rotation = 45
    gemGradient.Parent = gemFrame
    
    local gemIcon = Instance.new("TextLabel")
    gemIcon.Size = UDim2.new(0, 40, 0, 40)
    gemIcon.Position = UDim2.new(0, 10, 0.5, -20)
    gemIcon.BackgroundTransparency = 1
    gemIcon.Text = "💎"
    gemIcon.TextScaled = true
    gemIcon.Font = Enum.Font.GothamBold
    gemIcon.Parent = gemFrame
    
    local gemLabel = Instance.new("TextLabel")
    gemLabel.Size = UDim2.new(1, -60, 1, 0)
    gemLabel.Position = UDim2.new(0, 55, 0, 0)
    gemLabel.BackgroundTransparency = 1
    gemLabel.Text = "0"
    gemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    gemLabel.TextScaled = true
    gemLabel.Font = Enum.Font.GothamBold
    gemLabel.TextStrokeTransparency = 0.5
    gemLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    gemLabel.Parent = gemFrame
    
    -- XP and Level display
    local xpFrame = Instance.new("Frame")
    xpFrame.Size = UDim2.new(0, isMobile() and 160 or 200, 0, isMobile() and 60 or 70)
    xpFrame.Position = UDim2.new(0, isMobile() and 355 or 440, 0, 15)
    xpFrame.BackgroundColor3 = Color3.fromRGB(50, 90, 50)
    xpFrame.BackgroundTransparency = 0.1
    xpFrame.BorderSizePixel = 0
    xpFrame.Parent = currencyGui
    
    local xpCorner = Instance.new("UICorner")
    xpCorner.CornerRadius = UDim.new(0, 18)
    xpCorner.Parent = xpFrame
    
    local xpStroke = Instance.new("UIStroke")
    xpStroke.Color = Color3.fromRGB(100, 255, 100)
    xpStroke.Thickness = 3
    xpStroke.Transparency = 0.3
    xpStroke.Parent = xpFrame
    
    local xpGradient = Instance.new("UIGradient")
    xpGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 110, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 90, 50))
    })
    xpGradient.Rotation = 45
    xpGradient.Parent = xpFrame
    
    local levelIcon = Instance.new("TextLabel")
    levelIcon.Size = UDim2.new(0, 40, 0, 40)
    levelIcon.Position = UDim2.new(0, 10, 0.5, -20)
    levelIcon.BackgroundTransparency = 1
    levelIcon.Text = "⭐"
    levelIcon.TextScaled = true
    levelIcon.Font = Enum.Font.GothamBold
    levelIcon.Parent = xpFrame
    
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Size = UDim2.new(1, -60, 1, 0)
    levelLabel.Position = UDim2.new(0, 55, 0, 0)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Lv.1"
    levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelLabel.TextScaled = true
    levelLabel.Font = Enum.Font.GothamBold
    levelLabel.TextStrokeTransparency = 0.5
    levelLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    levelLabel.Parent = xpFrame
    
    return coinLabel, gemLabel, levelLabel
end

local coinLabel, gemLabel, levelLabel = createCurrencyDisplay()

-- 🔄 DATA SYNC FUNCTION
local function syncDataFromServer()
    local success, serverData = pcall(function()
        return getPlayerDataRemote:InvokeServer()
    end)
    
    if success and serverData then
        ClientGameData = serverData
        
        -- Update UI elements
        coinLabel.Text = tostring(ClientGameData.coins or 0)
        gemLabel.Text = tostring(ClientGameData.gems or 0)
        levelLabel.Text = "Lv." .. tostring(ClientGameData.level or 1)
        
        return true
    else
        warn("Failed to sync data from server:", serverData)
        return false
    end
end

-- 🎲 ENHANCED ROLL FUNCTION
local function performRoll()
    local success, message, glitchData, rollType, updatedData = pcall(function()
        return rollGlitchRemote:InvokeServer()
    end)
    
    if success then
        if updatedData then
            ClientGameData = updatedData
            syncDataFromServer()
        end
        
        if message then
            if rollType == "auto_sell" then
                showNotification(message, Color3.fromRGB(255, 215, 0), 3, "💰")
                playSound("coin", 0.6)
            elseif glitchData then
                showNotification(message, glitchData.color, 5, "🎉")
                playSound(string.lower(glitchData.rarity), 0.8)
                
                -- Create enhanced particle effect
                createParticleEffect(Vector2.new(400, 600), glitchData.color, glitchData.rarity)
                
                -- Special effects for rare items
                if glitchData.rarity == "Divine" or glitchData.rarity == "Mythic" then
                    -- Screen flash
                    local flashGui = Instance.new("ScreenGui")
                    flashGui.Name = "FlashEffect"
                    flashGui.Parent = playerGui
                    
                    local flash = Instance.new("Frame")
                    flash.Size = UDim2.new(1, 0, 1, 0)
                    flash.BackgroundColor3 = glitchData.color
                    flash.BackgroundTransparency = 0.6
                    flash.BorderSizePixel = 0
                    flash.Parent = flashGui
                    
                    TweenService:Create(flash, TweenInfo.new(0.8), {
                        BackgroundTransparency = 1
                    }):Play()
                    
                    task.spawn(function()
                        task.wait(0.8)
                        flashGui:Destroy()
                    end)
                end
            end
        end
    else
        showNotification(message or "Failed to roll", Color3.fromRGB(255, 100, 100), 3, "❌")
        playSound("error", 0.6)
    end
end

-- 📋 ENHANCED UI BUTTONS WITH NEW FEATURES
local UIButtons = {
    {
        Name = "RollGui",
        Icon = "🎲",
        Position = UDim2.new(0.5, 0, 0.85, 0),
        Size = UDim2.new(0, isMobile() and 130 or 150, 0, isMobile() and 130 or 150),
        Color = Color3.fromRGB(100, 255, 100),
        Callback = performRoll
    },
    {
        Name = "InventoryGui", 
        Icon = "🎒",
        Position = UDim2.new(0, 90, 0.4, 0),
        Size = UDim2.new(0, isMobile() and 80 or 100, 0, isMobile() and 80 or 100),
        Color = Color3.fromRGB(100, 150, 255),
        Callback = function()
            local content = createFloatingPanel("🎒 INVENTORY", UDim2.new(0, isMobile() and 500 or 650, 0, isMobile() and 550 or 700))
            
            -- Enhanced statistics display
            local statsFrame = Instance.new("Frame")
            statsFrame.Size = UDim2.new(1, 0, 0, 100)
            statsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            statsFrame.BackgroundTransparency = 0.3
            statsFrame.BorderSizePixel = 0
            statsFrame.Parent = content
            
            local statsCorner = Instance.new("UICorner")
            statsCorner.CornerRadius = UDim.new(0, 15)
            statsCorner.Parent = statsFrame
            
            local statsText = Instance.new("TextLabel")
            statsText.Size = UDim2.new(1, -20, 1, 0)
            statsText.Position = UDim2.new(0, 10, 0, 0)
            statsText.BackgroundTransparency = 1
            
            local totalValue = 0
            for _, glitch in ipairs(ClientGameData.glitches or {}) do
                totalValue = totalValue + (glitch.value or 0)
            end
            
            statsText.Text = string.format("📊 Items: %d | 🌟 Rare: %d | 💰 Total Value: %d | 📈 Level: %d", 
                #(ClientGameData.glitches or {}), 
                ClientGameData.statistics and ClientGameData.statistics.rareItemsFound or 0,
                totalValue,
                ClientGameData.level or 1
            )
            statsText.TextColor3 = Color3.fromRGB(255, 255, 255)
            statsText.TextScaled = true
            statsText.Font = Enum.Font.Gotham
            statsText.Parent = statsFrame
            
            -- Inventory grid with sell functionality
            local scrollFrame = Instance.new("ScrollingFrame")
            scrollFrame.Size = UDim2.new(1, 0, 1, -120)
            scrollFrame.Position = UDim2.new(0, 0, 0, 110)
            scrollFrame.BackgroundTransparency = 1
            scrollFrame.ScrollBarThickness = 10
            scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
            scrollFrame.BorderSizePixel = 0
            scrollFrame.Parent = content
            
            local gridLayout = Instance.new("UIGridLayout")
            gridLayout.CellSize = UDim2.new(0, isMobile() and 100 or 120, 0, isMobile() and 100 or 120)
            gridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
            gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            gridLayout.Parent = scrollFrame
            
            -- Sort and display glitches
            local sortedGlitches = {}
            for i, glitch in ipairs(ClientGameData.glitches or {}) do
                glitch.index = i
                table.insert(sortedGlitches, glitch)
            end
            
            local rarityOrder = {Divine = 6, Mythic = 5, Legendary = 4, Epic = 3, Rare = 2, Uncommon = 1, Common = 0}
            table.sort(sortedGlitches, function(a, b)
                local aOrder = rarityOrder[a.rarity] or 0
                local bOrder = rarityOrder[b.rarity] or 0
                if aOrder == bOrder then
                    return (a.value or 0) > (b.value or 0)
                end
                return aOrder > bOrder
            end)
            
            for i, glitch in ipairs(sortedGlitches) do
                local glitchSlot = Instance.new("TextButton")
                glitchSlot.Size = UDim2.new(0, isMobile() and 100 or 120, 0, isMobile() and 100 or 120)
                glitchSlot.BackgroundColor3 = glitch.color
                glitchSlot.BackgroundTransparency = 0.2
                glitchSlot.BorderSizePixel = 0
                glitchSlot.LayoutOrder = i
                glitchSlot.Text = ""
                glitchSlot.Parent = scrollFrame
                
                local slotCorner = Instance.new("UICorner")
                slotCorner.CornerRadius = UDim.new(0, 18)
                slotCorner.Parent = glitchSlot
                
                local slotStroke = Instance.new("UIStroke")
                slotStroke.Color = Color3.fromRGB(255, 255, 255)
                slotStroke.Thickness = 3
                slotStroke.Transparency = 0.3
                slotStroke.Parent = glitchSlot
                
                local slotGradient = Instance.new("UIGradient")
                slotGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, glitch.color),
                    ColorSequenceKeypoint.new(1, Color3.new(
                        math.max(0, glitch.color.R - 0.2),
                        math.max(0, glitch.color.G - 0.2),
                        math.max(0, glitch.color.B - 0.2)
                    ))
                })
                slotGradient.Rotation = 45
                slotGradient.Parent = glitchSlot
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, -10, 0.5, 0)
                nameLabel.Position = UDim2.new(0, 5, 0, 5)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = glitch.name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextStrokeTransparency = 0.5
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                nameLabel.Parent = glitchSlot
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(1, -10, 0.3, 0)
                valueLabel.Position = UDim2.new(0, 5, 0.5, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = "💰" .. (glitch.value or 0)
                valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                valueLabel.TextScaled = true
                valueLabel.Font = Enum.Font.Gotham
                valueLabel.TextStrokeTransparency = 0.5
                valueLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                valueLabel.Parent = glitchSlot
                
                local sellLabel = Instance.new("TextLabel")
                sellLabel.Size = UDim2.new(1, -10, 0.2, 0)
                sellLabel.Position = UDim2.new(0, 5, 0.8, 0)
                sellLabel.BackgroundTransparency = 1
                sellLabel.Text = "Click to Sell"
                sellLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                sellLabel.TextScaled = true
                sellLabel.Font = Enum.Font.Gotham
                sellLabel.TextStrokeTransparency = 0.5
                sellLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                sellLabel.Parent = glitchSlot
                
                -- Sell functionality
                glitchSlot.MouseButton1Click:Connect(function()
                    local success, message, updatedData = pcall(function()
                        return sellItemRemote:InvokeServer(glitch.index)
                    end)
                    
                    if success and updatedData then
                        ClientGameData = updatedData
                        showNotification(message, Color3.fromRGB(100, 255, 100), 3, "💰")
                        playSound("coin", 0.6)
                        
                        -- Refresh inventory display
                        glitchSlot:Destroy()
                        syncDataFromServer()
                    else
                        showNotification(message or "Failed to sell item", Color3.fromRGB(255, 100, 100), 3, "❌")
                    end
                end)
                
                -- Hover effects
                glitchSlot.MouseEnter:Connect(function()
                    TweenService:Create(glitchSlot, TweenInfo.new(0.2), {
                        Size = UDim2.new(0, isMobile() and 105 or 125, 0, isMobile() and 105 or 125)
                    }):Play()
                end)
                
                glitchSlot.MouseLeave:Connect(function()
                    TweenService:Create(glitchSlot, TweenInfo.new(0.2), {
                        Size = UDim2.new(0, isMobile() and 100 or 120, 0, isMobile() and 100 or 120)
                    }):Play()
                end)
            end
            
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20)
        end
    },
    {
        Name = "PotionsGui",
        Icon = "🧪",
        Position = UDim2.new(0, 90, 0.55, 0),
        Size = UDim2.new(0, isMobile() and 80 or 100, 0, isMobile() and 80 or 100),
        Color = Color3.fromRGB(255, 100, 255),
        Callback = function()
            local content = createFloatingPanel("🧪 POTIONS", UDim2.new(0, isMobile() and 450 or 550, 0, isMobile() and 500 or 600))
            
            -- Potions grid
            local scrollFrame = Instance.new("ScrollingFrame")
            scrollFrame.Size = UDim2.new(1, 0, 1, 0)
            scrollFrame.BackgroundTransparency = 1
            scrollFrame.ScrollBarThickness = 10
            scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 255)
            scrollFrame.BorderSizePixel = 0
            scrollFrame.Parent = content
            
            local gridLayout = Instance.new("UIGridLayout")
            gridLayout.CellSize = UDim2.new(0, isMobile() and 120 or 140, 0, isMobile() and 120 or 140)
            gridLayout.CellPadding = UDim2.new(0, 15, 0, 15)
            gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            gridLayout.Parent = scrollFrame
            
            for i, potion in ipairs(ClientGameData.potions or {}) do
                local potionSlot = Instance.new("TextButton")
                potionSlot.Size = UDim2.new(0, isMobile() and 120 or 140, 0, isMobile() and 120 or 140)
                potionSlot.BackgroundColor3 = potion.color
                potionSlot.BackgroundTransparency = 0.2
                potionSlot.BorderSizePixel = 0
                potionSlot.Text = ""
                potionSlot.Parent = scrollFrame
                
                local potionCorner = Instance.new("UICorner")
                potionCorner.CornerRadius = UDim.new(0, 20)
                potionCorner.Parent = potionSlot
                
                local potionStroke = Instance.new("UIStroke")
                potionStroke.Color = Color3.fromRGB(255, 255, 255)
                potionStroke.Thickness = 3
                potionStroke.Transparency = 0.3
                potionStroke.Parent = potionSlot
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, -10, 0.4, 0)
                nameLabel.Position = UDim2.new(0, 5, 0, 5)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = potion.name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextStrokeTransparency = 0.5
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                nameLabel.Parent = potionSlot
                
                local effectLabel = Instance.new("TextLabel")
                effectLabel.Size = UDim2.new(1, -10, 0.3, 0)
                effectLabel.Position = UDim2.new(0, 5, 0.4, 0)
                effectLabel.BackgroundTransparency = 1
                effectLabel.Text = potion.multiplier .. "x " .. potion.effect
                effectLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
                effectLabel.TextScaled = true
                effectLabel.Font = Enum.Font.Gotham
                effectLabel.TextStrokeTransparency = 0.5
                effectLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                effectLabel.Parent = potionSlot
                
                local useLabel = Instance.new("TextLabel")
                useLabel.Size = UDim2.new(1, -10, 0.3, 0)
                useLabel.Position = UDim2.new(0, 5, 0.7, 0)
                useLabel.BackgroundTransparency = 1
                useLabel.Text = "Click to Use"
                useLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                useLabel.TextScaled = true
                useLabel.Font = Enum.Font.Gotham
                useLabel.TextStrokeTransparency = 0.5
                useLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                useLabel.Parent = potionSlot
                
                -- Use potion functionality
                potionSlot.MouseButton1Click:Connect(function()
                    local success, message, updatedData = pcall(function()
                        return usePotionRemote:InvokeServer(i)
                    end)
                    
                    if success and updatedData then
                        ClientGameData = updatedData
                        showNotification(message, potion.color, 4, "🧪")
                        playSound("success", 0.6)
                        potionSlot:Destroy()
                    else
                        showNotification(message or "Failed to use potion", Color3.fromRGB(255, 100, 100), 3, "❌")
                    end
                end)
            end
            
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20)
        end
    },
    {
        Name = "CodesGui",
        Icon = "🎫",
        Position = UDim2.new(0, 90, 0.7, 0),
        Size = UDim2.new(0, isMobile() and 80 or 100, 0, isMobile() and 80 or 100),
        Color = Color3.fromRGB(255, 150, 100),
        Callback = function()
            local content = createFloatingPanel("🎫 REDEEM CODES", UDim2.new(0, isMobile() and 450 or 550, 0, isMobile() and 500 or 600))
            
            -- Enhanced code input
            local codeInput = Instance.new("TextBox")
            codeInput.Size = UDim2.new(1, -20, 0, 70)
            codeInput.Position = UDim2.new(0, 10, 0, 20)
            codeInput.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            codeInput.BackgroundTransparency = 0.2
            codeInput.BorderSizePixel = 0
            codeInput.Text = ""
            codeInput.PlaceholderText = "Enter code here..."
            codeInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            codeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            codeInput.TextScaled = true
            codeInput.Font = Enum.Font.Gotham
            codeInput.Parent = content
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 18)
            inputCorner.Parent = codeInput
            
            local inputStroke = Instance.new("UIStroke")
            inputStroke.Color = Color3.fromRGB(100, 150, 255)
            inputStroke.Thickness = 3
            inputStroke.Transparency = 0.5
            inputStroke.Parent = codeInput
            
            -- Enhanced redeem button
            local redeemButton = Instance.new("TextButton")
            redeemButton.Size = UDim2.new(1, -20, 0, 70)
            redeemButton.Position = UDim2.new(0, 10, 0, 100)
            redeemButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            redeemButton.BackgroundTransparency = 0.2
            redeemButton.BorderSizePixel = 0
            redeemButton.Text = "🎁 REDEEM CODE"
            redeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            redeemButton.TextScaled = true
            redeemButton.Font = Enum.Font.GothamBold
            redeemButton.TextStrokeTransparency = 0.5
            redeemButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            redeemButton.Parent = content
            
            local redeemCorner = Instance.new("UICorner")
            redeemCorner.CornerRadius = UDim.new(0, 18)
            redeemCorner.Parent = redeemButton
            
            -- Available codes display
            local codesFrame = Instance.new("ScrollingFrame")
            codesFrame.Size = UDim2.new(1, -20, 1, -190)
            codesFrame.Position = UDim2.new(0, 10, 0, 180)
            codesFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            codesFrame.BackgroundTransparency = 0.3
            codesFrame.BorderSizePixel = 0
            codesFrame.ScrollBarThickness = 10
            codesFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 150, 100)
            codesFrame.Parent = content
            
            local codesCorner = Instance.new("UICorner")
            codesCorner.CornerRadius = UDim.new(0, 18)
            codesCorner.Parent = codesFrame
            
            local codesLayout = Instance.new("UIListLayout")
            codesLayout.Padding = UDim.new(0, 12)
            codesLayout.Parent = codesFrame
            
            -- Sample codes display
            local sampleCodes = {
                {code = "GLITCH2024", reward = "2500 💰 + 10 💎 + 500 XP"},
                {code = "MYTHICPOWER", reward = "1500 💰 + 5 💎 + Luck Elixir"},
                {code = "VOIDMASTER", reward = "3000 💰 + 15 💎 + 1000 XP"},
                {code = "LUCKYBOOST", reward = "2000 💰 + 1.5x Luck (30min)"},
                {code = "LEGENDARY", reward = "10000 💰 + 50 💎 + Divine Fortune"}
            }
            
            for _, codeData in ipairs(sampleCodes) do
                local codeFrame = Instance.new("Frame")
                codeFrame.Size = UDim2.new(1, -10, 0, 60)
                codeFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
                codeFrame.BackgroundTransparency = 0.3
                codeFrame.BorderSizePixel = 0
                codeFrame.Parent = codesFrame
                
                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 12)
                frameCorner.Parent = codeFrame
                
                local codeText = Instance.new("TextLabel")
                codeText.Size = UDim2.new(0.4, 0, 1, 0)
                codeText.Position = UDim2.new(0, 15, 0, 0)
                codeText.BackgroundTransparency = 1
                codeText.Text = codeData.code
                codeText.TextColor3 = Color3.fromRGB(255, 255, 255)
                codeText.TextScaled = true
                codeText.Font = Enum.Font.GothamBold
                codeText.TextXAlignment = Enum.TextXAlignment.Left
                codeText.TextStrokeTransparency = 0.5
                codeText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                codeText.Parent = codeFrame
                
                local rewardText = Instance.new("TextLabel")
                rewardText.Size = UDim2.new(0.6, -15, 1, 0)
                rewardText.Position = UDim2.new(0.4, 0, 0, 0)
                rewardText.BackgroundTransparency = 1
                rewardText.Text = codeData.reward
                rewardText.TextColor3 = Color3.fromRGB(100, 255, 100)
                rewardText.TextScaled = true
                rewardText.Font = Enum.Font.Gotham
                rewardText.TextXAlignment = Enum.TextXAlignment.Right
                rewardText.TextStrokeTransparency = 0.5
                rewardText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                rewardText.Parent = codeFrame
            end
            
            codesFrame.CanvasSize = UDim2.new(0, 0, 0, codesLayout.AbsoluteContentSize.Y + 20)
            
            -- Redeem functionality
            redeemButton.MouseButton1Click:Connect(function()
                local code = codeInput.Text
                if code == "" then
                    showNotification("❌ Please enter a code!", Color3.fromRGB(255, 100, 100), 3, "❌")
                    return
                end
                
                local success, message, updatedData = pcall(function()
                    return redeemCodeRemote:InvokeServer(code)
                end)
                
                if success and updatedData then
                    ClientGameData = updatedData
                    syncDataFromServer()
                    showNotification(message, Color3.fromRGB(100, 255, 100), 5, "✅")
                    playSound("success", 0.6)
                    codeInput.Text = ""
                else
                    showNotification(message or "Failed to redeem code", Color3.fromRGB(255, 100, 100), 3, "❌")
                    playSound("error", 0.6)
                end
            end)
        end
    }
}

-- 🎨 CREATE ENHANCED UI BUTTONS
for _, data in pairs(UIButtons) do
    local gui = Instance.new("ScreenGui")
    gui.Name = data.Name
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local button = Instance.new("TextButton")
    button.Name = "OpenButton"
    button.Size = data.Size
    button.Position = data.Position
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    button.BackgroundTransparency = 0.1
    button.BorderSizePixel = 0
    button.Text = data.Icon
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = gui

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.35, 0)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = data.Color
    buttonStroke.Thickness = 4
    buttonStroke.Transparency = 0.3
    buttonStroke.Parent = button
    
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 70))
    })
    buttonGradient.Rotation = 45
    buttonGradient.Parent = button
    
    -- Special styling for roll button
    if data.Name == "RollGui" then
        local costLabel = Instance.new("TextLabel")
        costLabel.Size = UDim2.new(1, 0, 0, 35)
        costLabel.Position = UDim2.new(0, 0, 1, 15)
        costLabel.BackgroundTransparency = 1
        costLabel.Text = "100 💰"
        costLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        costLabel.TextScaled = true
        costLabel.Font = Enum.Font.GothamBold
        costLabel.TextStrokeTransparency = 0.5
        costLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        costLabel.Parent = button
        
        -- Update cost label periodically
        task.spawn(function()
            while button.Parent do
                task.wait(1)
                if ClientGameData.rollCost then
                    costLabel.Text = ClientGameData.rollCost .. " 💰"
                end
            end
        end)
    end

    -- Enhanced hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            BackgroundTransparency = 0.05,
            Size = data.Size + UDim2.new(0, 12, 0, 12)
        }):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Transparency = 0.1,
            Thickness = 6
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            BackgroundTransparency = 0.1,
            Size = data.Size
        }):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Transparency = 0.3,
            Thickness = 4
        }):Play()
    end)

    -- Enhanced click animation
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = data.Size - UDim2.new(0, 10, 0, 10)
        }):Play()
        task.wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = data.Size
        }):Play()
        
        data.Callback()
    end)
end

-- 🏆 ACHIEVEMENT NOTIFICATION HANDLER
achievementUnlockedEvent.OnClientEvent:Connect(function(achievement)
    showNotification("🏆 Achievement Unlocked: " .. achievement.name .. "\n" .. achievement.description, 
        Color3.fromRGB(255, 215, 0), 8, "🏆", true)
    playSound("achievement", 0.8)
end)

-- 🔄 PERIODIC DATA SYNC
task.spawn(function()
    while true do
        task.wait(5) -- Sync every 5 seconds
        syncDataFromServer()
    end
end)

-- 🚀 INITIALIZE CLIENT
task.spawn(function()
    task.wait(2) -- Wait for server to initialize
    
    if syncDataFromServer() then
        showNotification("🎮 Welcome to Enhanced Glitch Aura RNG!", Color3.fromRGB(100, 150, 255), 6, "🎮", true)
        task.wait(4)
        showNotification("💡 Tip: Use codes for free rewards and potions!", Color3.fromRGB(255, 215, 0), 5, "💡")
        task.wait(3)
        showNotification("🎯 Good luck on your rolls! Server-secured gameplay!", Color3.fromRGB(100, 255, 100), 5, "🎯")
    else
        showNotification("❌ Failed to connect to server. Please rejoin.", Color3.fromRGB(255, 100, 100), 10, "❌")
    end
end)

print("✅ Secure client initialized successfully!")
print("🔒 All game logic handled server-side for maximum security!")
print("🎮 Features: Potions, Quests, Achievements, Shop, Enhanced UI!")