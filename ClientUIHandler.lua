-- 🎮 GLITCH AURA - MODERN CLIENT UI HANDLER 🎮
-- Place in StarterPlayerScripts as LocalScript
-- Auto-generates separate, clean, transparent GUIs

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🎯 GAME DATA
local GameData = {
    coins = 1000,
    glitches = {},
    potions = {},
    coinMultiplier = 1,
    usedCodes = {},
    rollCost = 100
}

-- 🌟 GLITCH DATABASE
local GlitchDatabase = {
    {name = "Shadow Phantom", rarity = "Common", chance = 35, coinBonus = 1.3, color = Color3.fromRGB(45, 45, 65)},
    {name = "Neon Surge", rarity = "Uncommon", chance = 25, coinBonus = 1.6, color = Color3.fromRGB(0, 255, 150)},
    {name = "Inferno Core", rarity = "Rare", chance = 20, coinBonus = 2.2, color = Color3.fromRGB(255, 100, 0)},
    {name = "Prismatic Void", rarity = "Epic", chance = 12, coinBonus = 3.5, color = Color3.fromRGB(255, 0, 255)},
    {name = "Void Reaper", rarity = "Legendary", chance = 6, coinBonus = 6.0, color = Color3.fromRGB(100, 0, 200)},
    {name = "Cosmic Genesis", rarity = "Mythic", chance = 2, coinBonus = 12.0, color = Color3.fromRGB(255, 215, 0)}
}

-- 💎 CODES DATABASE
local CodesDatabase = {
    ["GLITCH2024"] = {coins = 2500, active = true},
    ["MYTHICPOWER"] = {coins = 1500, active = true},
    ["VOIDMASTER"] = {coins = 3000, active = true},
    ["NEWPLAYER"] = {coins = 1000, active = true},
    ["WELCOME"] = {coins = 500, active = true}
}

-- 📱 RESPONSIVE HELPER
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- 🎵 SOUND SYSTEM
local function playSound(soundId, volume)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume = volume or 0.5
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- 🔔 NOTIFICATION SYSTEM
local function showNotification(message, color, duration)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "NotificationGui"
    notifGui.IgnoreGuiInset = true
    notifGui.ResetOnSpawn = false
    notifGui.Parent = playerGui
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, isMobile() and 280 or 350, 0, isMobile() and 60 or 80)
    notification.Position = UDim2.new(0.5, isMobile() and -140 or -175, 0, -100)
    notification.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.Parent = notifGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = notification
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 1, 0)
    text.Position = UDim2.new(0, 10, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = Color3.fromRGB(0, 0, 0)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = notification
    
    -- Animate in
    TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, isMobile() and -140 or -175, 0, 20)
    }):Play()
    
    -- Auto remove
    task.spawn(function()
        task.wait(duration or 3)
        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, isMobile() and -140 or -175, 0, -100),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        notifGui:Destroy()
    end)
end

-- 🎨 CREATE FLOATING PANEL FUNCTION
local function createFloatingPanel(title, size, content)
    local panelGui = Instance.new("ScreenGui")
    panelGui.Name = title .. "Panel"
    panelGui.IgnoreGuiInset = true
    panelGui.ResetOnSpawn = false
    panelGui.Parent = playerGui
    
    -- Background blur
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.BorderSizePixel = 0
    background.Parent = panelGui
    
    -- Main panel
    local panel = Instance.new("Frame")
    panel.Size = size
    panel.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    panel.BackgroundTransparency = 0.05
    panel.BorderSizePixel = 0
    panel.Parent = panelGui
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 16)
    panelCorner.Parent = panel
    
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(255, 255, 255)
    panelStroke.Thickness = 2
    panelStroke.Transparency = 0.7
    panelStroke.Parent = panel
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 60)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    header.BackgroundTransparency = 0.8
    header.BorderSizePixel = 0
    header.Parent = panel
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Close button
    local closeButton = Instance.new("ImageButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0.5, -20)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.BackgroundTransparency = 0.2
    closeButton.BorderSizePixel = 0
    closeButton.Image = "rbxassetid://17368208589"
    closeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -80)
    contentFrame.Position = UDim2.new(0, 10, 0, 70)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = panel
    
    -- Animate in
    panel.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = size
    }):Play()
    
    -- Close function
    local function closePanel()
        TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.3)
        panelGui:Destroy()
    end
    
    closeButton.MouseButton1Click:Connect(closePanel)
    background.MouseButton1Click:Connect(closePanel)
    
    return contentFrame, closePanel
end

-- 💰 COIN DISPLAY GUI
local coinGui = Instance.new("ScreenGui")
coinGui.Name = "CoinDisplay"
coinGui.IgnoreGuiInset = true
coinGui.ResetOnSpawn = false
coinGui.Parent = playerGui

local coinFrame = Instance.new("Frame")
coinFrame.Size = UDim2.new(0, isMobile() and 200 or 250, 0, isMobile() and 60 or 70)
coinFrame.Position = UDim2.new(0, 20, 0, 20)
coinFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
coinFrame.BackgroundTransparency = 0.1
coinFrame.BorderSizePixel = 0
coinFrame.Parent = coinGui

local coinCorner = Instance.new("UICorner")
coinCorner.CornerRadius = UDim.new(0, 12)
coinCorner.Parent = coinFrame

local coinStroke = Instance.new("UIStroke")
coinStroke.Color = Color3.fromRGB(255, 215, 0)
coinStroke.Thickness = 2
coinStroke.Transparency = 0.3
coinStroke.Parent = coinFrame

local coinIcon = Instance.new("ImageLabel")
coinIcon.Size = UDim2.new(0, 40, 0, 40)
coinIcon.Position = UDim2.new(0, 15, 0.5, -20)
coinIcon.BackgroundTransparency = 1
coinIcon.Image = "rbxassetid://17368084284"
coinIcon.ImageColor3 = Color3.fromRGB(255, 215, 0)
coinIcon.Parent = coinFrame

local coinLabel = Instance.new("TextLabel")
coinLabel.Size = UDim2.new(1, -70, 1, 0)
coinLabel.Position = UDim2.new(0, 65, 0, 0)
coinLabel.BackgroundTransparency = 1
coinLabel.Text = tostring(GameData.coins)
coinLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
coinLabel.TextScaled = true
coinLabel.Font = Enum.Font.GothamBold
coinLabel.Parent = coinFrame

-- 📋 UI BUTTONS CONFIGURATION
local UIButtons = {
    {
        Name = "RollGui",
        ImageId = "rbxassetid://125264363254178",
        Position = UDim2.new(0.5, 0, 0.85, 0),
        Size = UDim2.new(0, isMobile() and 90 or 110, 0, isMobile() and 90 or 110),
        Color = Color3.fromRGB(100, 255, 100),
        Callback = function()
            -- Roll logic
            if GameData.coins < GameData.rollCost then
                showNotification("❌ Not enough coins to roll!", Color3.fromRGB(255, 100, 100))
                return
            end
            
            GameData.coins = GameData.coins - GameData.rollCost
            coinLabel.Text = tostring(GameData.coins)
            
            playSound("131961136", 0.6)
            
            -- Roll for glitch
            local roll = math.random(1, 100)
            local cumulativeChance = 0
            local rolledGlitch = nil
            
            for _, glitch in ipairs(GlitchDatabase) do
                cumulativeChance = cumulativeChance + glitch.chance
                if roll <= cumulativeChance then
                    rolledGlitch = glitch
                    break
                end
            end
            
            if rolledGlitch then
                table.insert(GameData.glitches, rolledGlitch)
                GameData.coinMultiplier = math.max(GameData.coinMultiplier, rolledGlitch.coinBonus)
                showNotification("🎉 " .. rolledGlitch.rarity .. " " .. rolledGlitch.name .. " obtained!", rolledGlitch.color)
            end
        end
    },
    {
        Name = "InventoryGui",
        ImageId = "rbxassetid://18209609229",
        Position = UDim2.new(0, 60, 0.45, 0),
        Size = UDim2.new(0, isMobile() and 70 or 85, 0, isMobile() and 70 or 85),
        Color = Color3.fromRGB(100, 150, 255),
        Callback = function()
            local content = createFloatingPanel("🎒 INVENTORY", UDim2.new(0, isMobile() and 400 or 500, 0, isMobile() and 450 or 550))
            
            -- Glitch display
            local scrollFrame = Instance.new("ScrollingFrame")
            scrollFrame.Size = UDim2.new(1, 0, 1, 0)
            scrollFrame.Position = UDim2.new(0, 0, 0, 0)
            scrollFrame.BackgroundTransparency = 1
            scrollFrame.ScrollBarThickness = 8
            scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
            scrollFrame.BorderSizePixel = 0
            scrollFrame.Parent = content
            
            local gridLayout = Instance.new("UIGridLayout")
            gridLayout.CellSize = UDim2.new(0, isMobile() and 80 or 100, 0, isMobile() and 80 or 100)
            gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
            gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            gridLayout.Parent = scrollFrame
            
            -- Display glitches
            for _, glitch in ipairs(GameData.glitches) do
                local glitchSlot = Instance.new("Frame")
                glitchSlot.Size = UDim2.new(0, isMobile() and 80 or 100, 0, isMobile() and 80 or 100)
                glitchSlot.BackgroundColor3 = glitch.color
                glitchSlot.BackgroundTransparency = 0.3
                glitchSlot.BorderSizePixel = 0
                glitchSlot.Parent = scrollFrame
                
                local slotCorner = Instance.new("UICorner")
                slotCorner.CornerRadius = UDim.new(0, 12)
                slotCorner.Parent = glitchSlot
                
                local slotStroke = Instance.new("UIStroke")
                slotStroke.Color = Color3.fromRGB(255, 255, 255)
                slotStroke.Thickness = 2
                slotStroke.Transparency = 0.5
                slotStroke.Parent = glitchSlot
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = glitch.name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.Parent = glitchSlot
            end
            
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20)
        end
    },
    {
        Name = "CodesGui",
        ImageId = "rbxassetid://18209599690",
        Position = UDim2.new(0, 60, 0.6, 0),
        Size = UDim2.new(0, isMobile() and 70 or 85, 0, isMobile() and 70 or 85),
        Color = Color3.fromRGB(255, 150, 100),
        Callback = function()
            local content = createFloatingPanel("🎫 REDEEM CODES", UDim2.new(0, isMobile() and 350 or 450, 0, isMobile() and 400 or 500))
            
            -- Code input
            local codeInput = Instance.new("TextBox")
            codeInput.Size = UDim2.new(1, -20, 0, 50)
            codeInput.Position = UDim2.new(0, 10, 0, 20)
            codeInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            codeInput.BackgroundTransparency = 0.2
            codeInput.BorderSizePixel = 0
            codeInput.Text = ""
            codeInput.PlaceholderText = "Enter code here..."
            codeInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
            codeInput.TextColor3 = Color3.fromRGB(0, 0, 0)
            codeInput.TextScaled = true
            codeInput.Font = Enum.Font.Gotham
            codeInput.Parent = content
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 12)
            inputCorner.Parent = codeInput
            
            -- Redeem button
            local redeemButton = Instance.new("TextButton")
            redeemButton.Size = UDim2.new(1, -20, 0, 50)
            redeemButton.Position = UDim2.new(0, 10, 0, 80)
            redeemButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            redeemButton.BackgroundTransparency = 0.2
            redeemButton.BorderSizePixel = 0
            redeemButton.Text = "🎁 REDEEM CODE"
            redeemButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            redeemButton.TextScaled = true
            redeemButton.Font = Enum.Font.GothamBold
            redeemButton.Parent = content
            
            local redeemCorner = Instance.new("UICorner")
            redeemCorner.CornerRadius = UDim.new(0, 12)
            redeemCorner.Parent = redeemButton
            
            -- Available codes
            local codesFrame = Instance.new("ScrollingFrame")
            codesFrame.Size = UDim2.new(1, -20, 1, -150)
            codesFrame.Position = UDim2.new(0, 10, 0, 140)
            codesFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            codesFrame.BackgroundTransparency = 0.8
            codesFrame.BorderSizePixel = 0
            codesFrame.ScrollBarThickness = 6
            codesFrame.Parent = content
            
            local codesCorner = Instance.new("UICorner")
            codesCorner.CornerRadius = UDim.new(0, 12)
            codesCorner.Parent = codesFrame
            
            local codesLayout = Instance.new("UIListLayout")
            codesLayout.Padding = UDim.new(0, 8)
            codesLayout.Parent = codesFrame
            
            -- Populate codes
            for code, data in pairs(CodesDatabase) do
                local codeFrame = Instance.new("Frame")
                codeFrame.Size = UDim2.new(1, -10, 0, 40)
                codeFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                codeFrame.BackgroundTransparency = 0.5
                codeFrame.BorderSizePixel = 0
                codeFrame.Parent = codesFrame
                
                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 8)
                frameCorner.Parent = codeFrame
                
                local codeText = Instance.new("TextLabel")
                codeText.Size = UDim2.new(0.6, 0, 1, 0)
                codeText.Position = UDim2.new(0, 10, 0, 0)
                codeText.BackgroundTransparency = 1
                codeText.Text = code
                codeText.TextColor3 = Color3.fromRGB(0, 0, 0)
                codeText.TextScaled = true
                codeText.Font = Enum.Font.GothamBold
                codeText.TextXAlignment = Enum.TextXAlignment.Left
                codeText.Parent = codeFrame
                
                local rewardText = Instance.new("TextLabel")
                rewardText.Size = UDim2.new(0.4, -10, 1, 0)
                rewardText.Position = UDim2.new(0.6, 0, 0, 0)
                rewardText.BackgroundTransparency = 1
                rewardText.Text = data.coins .. " 💰"
                rewardText.TextColor3 = Color3.fromRGB(0, 150, 0)
                rewardText.TextScaled = true
                rewardText.Font = Enum.Font.Gotham
                rewardText.TextXAlignment = Enum.TextXAlignment.Right
                rewardText.Parent = codeFrame
            end
            
            codesFrame.CanvasSize = UDim2.new(0, 0, 0, codesLayout.AbsoluteContentSize.Y + 10)
            
            -- Redeem function
            redeemButton.MouseButton1Click:Connect(function()
                local code = string.upper(codeInput.Text:gsub("%s", ""))
                local codeData = CodesDatabase[code]
                
                if codeData and codeData.active and not GameData.usedCodes[code] then
                    GameData.coins = GameData.coins + codeData.coins
                    GameData.usedCodes[code] = true
                    coinLabel.Text = tostring(GameData.coins)
                    
                    showNotification("✅ Code redeemed! +" .. codeData.coins .. " coins", Color3.fromRGB(100, 255, 100))
                    codeInput.Text = ""
                else
                    showNotification("❌ Invalid or already used code!", Color3.fromRGB(255, 100, 100))
                    codeInput.Text = ""
                end
            end)
        end
    },
    {
        Name = "IndexGui",
        ImageId = "rbxassetid://76367970334970",
        Position = UDim2.new(0, 60, 0.75, 0),
        Size = UDim2.new(0, isMobile() and 70 or 85, 0, isMobile() and 70 or 85),
        Color = Color3.fromRGB(150, 255, 150),
        Callback = function()
            local content = createFloatingPanel("📖 GLITCH INDEX", UDim2.new(0, isMobile() and 400 or 550, 0, isMobile() and 500 or 650))
            
            local scrollFrame = Instance.new("ScrollingFrame")
            scrollFrame.Size = UDim2.new(1, 0, 1, 0)
            scrollFrame.Position = UDim2.new(0, 0, 0, 0)
            scrollFrame.BackgroundTransparency = 1
            scrollFrame.ScrollBarThickness = 8
            scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 255, 150)
            scrollFrame.BorderSizePixel = 0
            scrollFrame.Parent = content
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 12)
            listLayout.Parent = scrollFrame
            
            -- Display all glitches
            for _, glitch in ipairs(GlitchDatabase) do
                local glitchEntry = Instance.new("Frame")
                glitchEntry.Size = UDim2.new(1, -20, 0, isMobile() and 80 or 100)
                glitchEntry.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                glitchEntry.BackgroundTransparency = 0.8
                glitchEntry.BorderSizePixel = 0
                glitchEntry.Parent = scrollFrame
                
                local entryCorner = Instance.new("UICorner")
                entryCorner.CornerRadius = UDim.new(0, 12)
                entryCorner.Parent = glitchEntry
                
                local entryStroke = Instance.new("UIStroke")
                entryStroke.Color = glitch.color
                entryStroke.Thickness = 2
                entryStroke.Transparency = 0.3
                entryStroke.Parent = glitchEntry
                
                local glitchIcon = Instance.new("Frame")
                glitchIcon.Size = UDim2.new(0, isMobile() and 60 or 80, 0, isMobile() and 60 or 80)
                glitchIcon.Position = UDim2.new(0, 10, 0.5, isMobile() and -30 or -40)
                glitchIcon.BackgroundColor3 = glitch.color
                glitchIcon.BackgroundTransparency = 0.3
                glitchIcon.BorderSizePixel = 0
                glitchIcon.Parent = glitchEntry
                
                local iconCorner = Instance.new("UICorner")
                iconCorner.CornerRadius = UDim.new(0, 12)
                iconCorner.Parent = glitchIcon
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, isMobile() and -80 or -100, 0, 30)
                nameLabel.Position = UDim2.new(0, isMobile() and 80 or 100, 0, 10)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = glitch.name
                nameLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = glitchEntry
                
                local rarityLabel = Instance.new("TextLabel")
                rarityLabel.Size = UDim2.new(1, isMobile() and -80 or -100, 0, 25)
                rarityLabel.Position = UDim2.new(0, isMobile() and 80 or 100, 0, 40)
                rarityLabel.BackgroundTransparency = 1
                rarityLabel.Text = string.format("%s (%d%%)", glitch.rarity, glitch.chance)
                rarityLabel.TextColor3 = glitch.color
                rarityLabel.TextScaled = true
                rarityLabel.Font = Enum.Font.Gotham
                rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
                rarityLabel.Parent = glitchEntry
                
                local bonusLabel = Instance.new("TextLabel")
                bonusLabel.Size = UDim2.new(1, isMobile() and -80 or -100, 0, 20)
                bonusLabel.Position = UDim2.new(0, isMobile() and 80 or 100, 0, isMobile() and 60 or 70)
                bonusLabel.BackgroundTransparency = 1
                bonusLabel.Text = string.format("%.1fx Coin Multiplier", glitch.coinBonus)
                bonusLabel.TextColor3 = Color3.fromRGB(0, 150, 0)
                bonusLabel.TextScaled = true
                bonusLabel.Font = Enum.Font.Gotham
                bonusLabel.TextXAlignment = Enum.TextXAlignment.Left
                bonusLabel.Parent = glitchEntry
            end
            
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end
    }
}

-- 🎨 CREATE UI BUTTONS
for _, data in pairs(UIButtons) do
    local gui = Instance.new("ScreenGui")
    gui.Name = data.Name
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local button = Instance.new("ImageButton")
    button.Name = "OpenButton"
    button.Size = data.Size
    button.Position = data.Position
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundTransparency = 0.1
    button.BorderSizePixel = 0
    button.Image = data.ImageId
    button.ImageColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = gui

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.5, 0)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = data.Color
    buttonStroke.Thickness = 3
    buttonStroke.Transparency = 0.3
    buttonStroke.Parent = button
    
    -- Special styling for roll button
    if data.Name == "RollGui" then
        local costLabel = Instance.new("TextLabel")
        costLabel.Size = UDim2.new(1, 0, 0, 25)
        costLabel.Position = UDim2.new(0, 0, 1, 5)
        costLabel.BackgroundTransparency = 1
        costLabel.Text = GameData.rollCost .. " Coins"
        costLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        costLabel.TextScaled = true
        costLabel.Font = Enum.Font.GothamBold
        costLabel.Parent = button
    end

    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.05,
            Size = data.Size + UDim2.new(0, 5, 0, 5)
        }):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.1
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.1,
            Size = data.Size
        }):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.3
        }):Play()
    end)

    -- Click animation and callback
    button.MouseButton1Click:Connect(function()
        -- Click animation
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = data.Size - UDim2.new(0, 5, 0, 5)
        }):Play()
        task.wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = data.Size
        }):Play()
        
        -- Execute callback
        data.Callback()
    end)
end

-- 🔄 PASSIVE COIN GENERATION
task.spawn(function()
    while true do
        task.wait(1)
        local coinsToAdd = math.floor(10 * GameData.coinMultiplier)
        GameData.coins = GameData.coins + coinsToAdd
        coinLabel.Text = tostring(GameData.coins)
    end
end)

-- 🚀 WELCOME MESSAGE
task.spawn(function()
    task.wait(2)
    showNotification("🎮 Welcome to Glitch Aura! Start rolling for glitches!", Color3.fromRGB(100, 150, 255), 4)
end)