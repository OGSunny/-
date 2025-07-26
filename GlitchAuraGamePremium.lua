-- 🎮 PREMIUM GLITCH AURA GAME SYSTEM 🎮
-- Ultra-Modern UI with Real Assets & Full Platform Support
-- Place in StarterPlayerScripts as LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🎯 GAME DATA SYSTEM
local GameData = {
    coins = 1000,
    gems = 50,
    glitches = {},
    potions = {},
    level = 1,
    experience = 0,
    coinMultiplier = 1,
    usedCodes = {},
    settings = {
        soundEnabled = true,
        notificationsEnabled = true,
        autoSave = true
    }
}

-- 🌟 PREMIUM GLITCH DATABASE
local GlitchDatabase = {
    {
        name = "Shadow Phantom",
        rarity = "Common",
        chance = 35,
        coinBonus = 1.3,
        gemBonus = 0,
        color = Color3.fromRGB(45, 45, 65),
        gradientColor = Color3.fromRGB(25, 25, 45),
        icon = "rbxassetid://6031075938", -- Shadow icon
        effect = "Shadow Trail",
        description = "A mysterious glitch that lurks in darkness"
    },
    {
        name = "Neon Surge",
        rarity = "Uncommon", 
        chance = 25,
        coinBonus = 1.6,
        gemBonus = 1,
        color = Color3.fromRGB(0, 255, 150),
        gradientColor = Color3.fromRGB(0, 200, 255),
        icon = "rbxassetid://6031075929", -- Lightning icon
        effect = "Electric Aura",
        description = "Crackling with electric energy"
    },
    {
        name = "Inferno Core",
        rarity = "Rare",
        chance = 20,
        coinBonus = 2.2,
        gemBonus = 2,
        color = Color3.fromRGB(255, 100, 0),
        gradientColor = Color3.fromRGB(255, 200, 0),
        icon = "rbxassetid://6031075914", -- Fire icon
        effect = "Flame Burst",
        description = "Burns with the intensity of a thousand suns"
    },
    {
        name = "Prismatic Void",
        rarity = "Epic",
        chance = 12,
        coinBonus = 3.5,
        gemBonus = 5,
        color = Color3.fromRGB(255, 0, 255),
        gradientColor = Color3.fromRGB(150, 0, 255),
        icon = "rbxassetid://6031075919", -- Crystal icon
        effect = "Rainbow Spiral",
        description = "Bends reality with prismatic power"
    },
    {
        name = "Void Reaper",
        rarity = "Legendary",
        chance = 6,
        coinBonus = 6.0,
        gemBonus = 10,
        color = Color3.fromRGB(100, 0, 200),
        gradientColor = Color3.fromRGB(50, 0, 100),
        icon = "rbxassetid://6031075924", -- Skull icon
        effect = "Dark Vortex",
        description = "Harvests power from the void itself"
    },
    {
        name = "Cosmic Genesis",
        rarity = "Mythic",
        chance = 2,
        coinBonus = 12.0,
        gemBonus = 25,
        color = Color3.fromRGB(255, 215, 0),
        gradientColor = Color3.fromRGB(255, 255, 255),
        icon = "rbxassetid://6031075903", -- Star icon
        effect = "Stellar Explosion",
        description = "The birth of stars condensed into pure energy"
    }
}

-- 💎 PREMIUM CODES DATABASE
local CodesDatabase = {
    ["PREMIUM2024"] = {coins = 2500, gems = 25, active = true},
    ["GLITCHLORD"] = {coins = 5000, gems = 50, active = true},
    ["MYTHICPOWER"] = {coins = 1500, gems = 15, active = true},
    ["VOIDMASTER"] = {coins = 3000, gems = 30, active = true},
    ["COSMICENERGY"] = {coins = 10000, gems = 100, active = true},
    ["NEWPLAYER"] = {coins = 1000, gems = 10, active = true},
    ["WELCOME"] = {coins = 500, gems = 5, active = true}
}

-- 🎵 PREMIUM SOUND SYSTEM
local Sounds = {
    roll = {id = "rbxassetid://131961136", volume = 0.6},
    success = {id = "rbxassetid://131961136", volume = 0.8},
    rare = {id = "rbxassetid://131961136", volume = 1.0},
    legendary = {id = "rbxassetid://131961136", volume = 1.2},
    mythic = {id = "rbxassetid://131961136", volume = 1.5},
    coin = {id = "rbxassetid://131961136", volume = 0.4},
    gem = {id = "rbxassetid://131961136", volume = 0.5},
    ui = {id = "rbxassetid://131961136", volume = 0.3},
    notification = {id = "rbxassetid://131961136", volume = 0.4}
}

local function createSound(soundData)
    local sound = Instance.new("Sound")
    sound.SoundId = soundData.id
    sound.Volume = soundData.volume
    sound.Parent = SoundService
    return sound
end

-- Initialize sounds
for name, data in pairs(Sounds) do
    Sounds[name] = createSound(data)
end

-- 🎨 UI CREATION SYSTEM
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumGlitchAura"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- 📱 RESPONSIVE DESIGN SYSTEM
local function getScreenSize()
    local camera = workspace.CurrentCamera
    return camera.ViewportSize
end

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function getScaleFactor()
    local screenSize = getScreenSize()
    local baseSize = 1920 -- Base design resolution
    return math.min(screenSize.X / baseSize, screenSize.Y / 1080)
end

-- 🌈 PREMIUM BACKGROUND SYSTEM
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Name = "Background"
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
backgroundFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Parent = screenGui

-- Animated gradient background
local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 15, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 25, 45))
}
backgroundGradient.Rotation = 45
backgroundGradient.Parent = backgroundFrame

-- Animated background rotation
spawn(function()
    while true do
        local tween = TweenService:Create(backgroundGradient, TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = backgroundGradient.Rotation + 360})
        tween:Play()
        tween.Completed:Wait()
    end
end)

-- ✨ PARTICLE EFFECTS SYSTEM
local function createParticleEffect(parent, color)
    for i = 1, 5 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
        particle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
        particle.BackgroundColor3 = color
        particle.BorderSizePixel = 0
        particle.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle
        
        -- Animate particle
        local tween = TweenService:Create(particle, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(particle.Position.X.Scale, 0, -0.2, 0),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            particle:Destroy()
        end)
    end
end

-- 💰 PREMIUM CURRENCY DISPLAY
local currencyFrame = Instance.new("Frame")
currencyFrame.Name = "CurrencyDisplay"
currencyFrame.Size = UDim2.new(0, isMobile() and 300 or 400, 0, isMobile() and 80 or 100)
currencyFrame.Position = UDim2.new(0, 20, 0, 20)
currencyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
currencyFrame.BorderSizePixel = 0
currencyFrame.Parent = screenGui

local currencyCorner = Instance.new("UICorner")
currencyCorner.CornerRadius = UDim.new(0, 15)
currencyCorner.Parent = currencyFrame

local currencyStroke = Instance.new("UIStroke")
currencyStroke.Color = Color3.fromRGB(100, 100, 150)
currencyStroke.Thickness = 2
currencyStroke.Parent = currencyFrame

local currencyGradient = Instance.new("UIGradient")
currencyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
}
currencyGradient.Rotation = 90
currencyGradient.Parent = currencyFrame

-- Coin display
local coinIcon = Instance.new("ImageLabel")
coinIcon.Size = UDim2.new(0, 40, 0, 40)
coinIcon.Position = UDim2.new(0, 15, 0.5, -20)
coinIcon.BackgroundTransparency = 1
coinIcon.Image = "rbxassetid://6031075938"
coinIcon.ImageColor3 = Color3.fromRGB(255, 215, 0)
coinIcon.Parent = currencyFrame

local coinLabel = Instance.new("TextLabel")
coinLabel.Size = UDim2.new(0.4, -30, 1, 0)
coinLabel.Position = UDim2.new(0, 60, 0, 0)
coinLabel.BackgroundTransparency = 1
coinLabel.Text = tostring(GameData.coins)
coinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coinLabel.TextScaled = true
coinLabel.Font = Enum.Font.GothamBold
coinLabel.Parent = currencyFrame

-- Gem display
local gemIcon = Instance.new("ImageLabel")
gemIcon.Size = UDim2.new(0, 40, 0, 40)
gemIcon.Position = UDim2.new(0.5, 15, 0.5, -20)
gemIcon.BackgroundTransparency = 1
gemIcon.Image = "rbxassetid://6031075919"
gemIcon.ImageColor3 = Color3.fromRGB(150, 255, 255)
gemIcon.Parent = currencyFrame

local gemLabel = Instance.new("TextLabel")
gemLabel.Size = UDim2.new(0.4, -30, 1, 0)
gemLabel.Position = UDim2.new(0.5, 60, 0, 0)
gemLabel.BackgroundTransparency = 1
gemLabel.Text = tostring(GameData.gems)
gemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gemLabel.TextScaled = true
gemLabel.Font = Enum.Font.GothamBold
gemLabel.Parent = currencyFrame

-- 🎲 PREMIUM ROLL SYSTEM
local rollFrame = Instance.new("Frame")
rollFrame.Name = "RollSystem"
rollFrame.Size = UDim2.new(0, isMobile() and 200 or 250, 0, isMobile() and 200 or 250)
rollFrame.Position = UDim2.new(0.5, isMobile() and -100 or -125, 1, isMobile() and -220 or -270)
rollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
rollFrame.BorderSizePixel = 0
rollFrame.Parent = screenGui

local rollCorner = Instance.new("UICorner")
rollCorner.CornerRadius = UDim.new(0.5, 0)
rollCorner.Parent = rollFrame

local rollStroke = Instance.new("UIStroke")
rollStroke.Color = Color3.fromRGB(100, 255, 100)
rollStroke.Thickness = 4
rollStroke.Parent = rollFrame

local rollGradient = Instance.new("UIGradient")
rollGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
}
rollGradient.Rotation = 45
rollGradient.Parent = rollStroke

local rollButton = Instance.new("TextButton")
rollButton.Size = UDim2.new(0.8, 0, 0.8, 0)
rollButton.Position = UDim2.new(0.1, 0, 0.1, 0)
rollButton.BackgroundTransparency = 1
rollButton.Text = ""
rollButton.Parent = rollFrame

local rollIcon = Instance.new("ImageLabel")
rollIcon.Size = UDim2.new(0.6, 0, 0.6, 0)
rollIcon.Position = UDim2.new(0.2, 0, 0.15, 0)
rollIcon.BackgroundTransparency = 1
rollIcon.Image = "rbxassetid://6031075938"
rollIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
rollIcon.Parent = rollButton

local rollText = Instance.new("TextLabel")
rollText.Size = UDim2.new(1, 0, 0.2, 0)
rollText.Position = UDim2.new(0, 0, 0.8, 0)
rollText.BackgroundTransparency = 1
rollText.Text = "ROLL"
rollText.TextColor3 = Color3.fromRGB(255, 255, 255)
rollText.TextScaled = true
rollText.Font = Enum.Font.GothamBold
rollText.Parent = rollButton

local rollCost = Instance.new("TextLabel")
rollCost.Size = UDim2.new(1, 0, 0, 30)
rollCost.Position = UDim2.new(0, 0, 1, 10)
rollCost.BackgroundTransparency = 1
rollCost.Text = "250 Coins"
rollCost.TextColor3 = Color3.fromRGB(255, 215, 0)
rollCost.TextScaled = true
rollCost.Font = Enum.Font.Gotham
rollCost.Parent = rollFrame

-- 📱 MOBILE NAVIGATION SYSTEM
local navFrame = Instance.new("Frame")
navFrame.Name = "Navigation"
navFrame.Size = UDim2.new(0, isMobile() and 80 or 100, 1, isMobile() and -100 or -120)
navFrame.Position = UDim2.new(0, 10, 0, isMobile() and 120 or 140)
navFrame.BackgroundTransparency = 1
navFrame.Parent = screenGui

local navLayout = Instance.new("UIListLayout")
navLayout.Padding = UDim.new(0, 15)
navLayout.FillDirection = Enum.FillDirection.Vertical
navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
navLayout.Parent = navFrame

-- Navigation buttons data
local navButtons = {
    {name = "Inventory", icon = "rbxassetid://6031075938", color = Color3.fromRGB(100, 150, 255)},
    {name = "Codes", icon = "rbxassetid://6031075919", color = Color3.fromRGB(255, 150, 100)},
    {name = "Index", icon = "rbxassetid://6031075924", color = Color3.fromRGB(150, 255, 150)},
    {name = "Settings", icon = "rbxassetid://6031075929", color = Color3.fromRGB(255, 255, 150)}
}

local navigationButtons = {}

for i, buttonData in ipairs(navButtons) do
    local button = Instance.new("TextButton")
    button.Name = buttonData.name .. "Button"
    button.Size = UDim2.new(0, isMobile() and 70 or 90, 0, isMobile() and 70 or 90)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = navFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 15)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = buttonData.color
    buttonStroke.Thickness = 2
    buttonStroke.Parent = button
    
    local buttonIcon = Instance.new("ImageLabel")
    buttonIcon.Size = UDim2.new(0.6, 0, 0.6, 0)
    buttonIcon.Position = UDim2.new(0.2, 0, 0.2, 0)
    buttonIcon.BackgroundTransparency = 1
    buttonIcon.Image = buttonData.icon
    buttonIcon.ImageColor3 = buttonData.color
    buttonIcon.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Thickness = 3}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Thickness = 2}):Play()
    end)
    
    navigationButtons[buttonData.name] = button
end

-- 🎒 PREMIUM INVENTORY SYSTEM
local inventoryGui = Instance.new("Frame")
inventoryGui.Name = "InventorySystem"
inventoryGui.Size = UDim2.new(0, isMobile() and 350 or 500, 0, isMobile() and 450 or 600)
inventoryGui.Position = UDim2.new(0.5, isMobile() and -175 or -250, 0.5, isMobile() and -225 or -300)
inventoryGui.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
inventoryGui.BorderSizePixel = 0
inventoryGui.Visible = false
inventoryGui.Parent = screenGui

local inventoryCorner = Instance.new("UICorner")
inventoryCorner.CornerRadius = UDim.new(0, 20)
inventoryCorner.Parent = inventoryGui

local inventoryStroke = Instance.new("UIStroke")
inventoryStroke.Color = Color3.fromRGB(100, 150, 255)
inventoryStroke.Thickness = 3
inventoryStroke.Parent = inventoryGui

-- Inventory header
local inventoryHeader = Instance.new("Frame")
inventoryHeader.Size = UDim2.new(1, 0, 0, 60)
inventoryHeader.Position = UDim2.new(0, 0, 0, 0)
inventoryHeader.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
inventoryHeader.BorderSizePixel = 0
inventoryHeader.Parent = inventoryGui

local inventoryHeaderCorner = Instance.new("UICorner")
inventoryHeaderCorner.CornerRadius = UDim.new(0, 20)
inventoryHeaderCorner.Parent = inventoryHeader

local inventoryTitle = Instance.new("TextLabel")
inventoryTitle.Size = UDim2.new(1, -100, 1, 0)
inventoryTitle.Position = UDim2.new(0, 20, 0, 0)
inventoryTitle.BackgroundTransparency = 1
inventoryTitle.Text = "🎒 GLITCH INVENTORY"
inventoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
inventoryTitle.TextScaled = true
inventoryTitle.Font = Enum.Font.GothamBold
inventoryTitle.TextXAlignment = Enum.TextXAlignment.Left
inventoryTitle.Parent = inventoryHeader

local inventoryClose = Instance.new("TextButton")
inventoryClose.Size = UDim2.new(0, 40, 0, 40)
inventoryClose.Position = UDim2.new(1, -50, 0.5, -20)
inventoryClose.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
inventoryClose.BorderSizePixel = 0
inventoryClose.Text = "✕"
inventoryClose.TextColor3 = Color3.fromRGB(255, 255, 255)
inventoryClose.TextScaled = true
inventoryClose.Font = Enum.Font.GothamBold
inventoryClose.Parent = inventoryHeader

local inventoryCloseCorner = Instance.new("UICorner")
inventoryCloseCorner.CornerRadius = UDim.new(1, 0)
inventoryCloseCorner.Parent = inventoryClose

-- Inventory content
local inventoryContent = Instance.new("ScrollingFrame")
inventoryContent.Size = UDim2.new(1, -20, 1, -80)
inventoryContent.Position = UDim2.new(0, 10, 0, 70)
inventoryContent.BackgroundTransparency = 1
inventoryContent.ScrollBarThickness = 8
inventoryContent.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
inventoryContent.BorderSizePixel = 0
inventoryContent.Parent = inventoryGui

local inventoryGrid = Instance.new("UIGridLayout")
inventoryGrid.CellSize = UDim2.new(0, isMobile() and 90 or 120, 0, isMobile() and 90 or 120)
inventoryGrid.CellPadding = UDim2.new(0, 10, 0, 10)
inventoryGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
inventoryGrid.Parent = inventoryContent

-- 🎫 PREMIUM CODES SYSTEM
local codesGui = Instance.new("Frame")
codesGui.Name = "CodesSystem"
codesGui.Size = UDim2.new(0, isMobile() and 350 or 450, 0, isMobile() and 400 or 500)
codesGui.Position = UDim2.new(0.5, isMobile() and -175 or -225, 0.5, isMobile() and -200 or -250)
codesGui.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
codesGui.BorderSizePixel = 0
codesGui.Visible = false
codesGui.Parent = screenGui

local codesCorner = Instance.new("UICorner")
codesCorner.CornerRadius = UDim.new(0, 20)
codesCorner.Parent = codesGui

local codesStroke = Instance.new("UIStroke")
codesStroke.Color = Color3.fromRGB(255, 150, 100)
codesStroke.Thickness = 3
codesStroke.Parent = codesGui

-- Codes header
local codesHeader = Instance.new("Frame")
codesHeader.Size = UDim2.new(1, 0, 0, 60)
codesHeader.Position = UDim2.new(0, 0, 0, 0)
codesHeader.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
codesHeader.BorderSizePixel = 0
codesHeader.Parent = codesGui

local codesHeaderCorner = Instance.new("UICorner")
codesHeaderCorner.CornerRadius = UDim.new(0, 20)
codesHeaderCorner.Parent = codesHeader

local codesTitle = Instance.new("TextLabel")
codesTitle.Size = UDim2.new(1, -100, 1, 0)
codesTitle.Position = UDim2.new(0, 20, 0, 0)
codesTitle.BackgroundTransparency = 1
codesTitle.Text = "🎫 REDEEM CODES"
codesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
codesTitle.TextScaled = true
codesTitle.Font = Enum.Font.GothamBold
codesTitle.TextXAlignment = Enum.TextXAlignment.Left
codesTitle.Parent = codesHeader

local codesClose = Instance.new("TextButton")
codesClose.Size = UDim2.new(0, 40, 0, 40)
codesClose.Position = UDim2.new(1, -50, 0.5, -20)
codesClose.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
codesClose.BorderSizePixel = 0
codesClose.Text = "✕"
codesClose.TextColor3 = Color3.fromRGB(255, 255, 255)
codesClose.TextScaled = true
codesClose.Font = Enum.Font.GothamBold
codesClose.Parent = codesHeader

local codesCloseCorner = Instance.new("UICorner")
codesCloseCorner.CornerRadius = UDim.new(1, 0)
codesCloseCorner.Parent = codesClose

-- Code input
local codeInput = Instance.new("TextBox")
codeInput.Size = UDim2.new(1, -40, 0, 50)
codeInput.Position = UDim2.new(0, 20, 0, 80)
codeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
codeInput.BorderSizePixel = 0
codeInput.Text = ""
codeInput.PlaceholderText = "Enter premium code here..."
codeInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
codeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
codeInput.TextScaled = true
codeInput.Font = Enum.Font.Gotham
codeInput.Parent = codesGui

local codeInputCorner = Instance.new("UICorner")
codeInputCorner.CornerRadius = UDim.new(0, 15)
codeInputCorner.Parent = codeInput

local redeemButton = Instance.new("TextButton")
redeemButton.Size = UDim2.new(1, -40, 0, 50)
redeemButton.Position = UDim2.new(0, 20, 0, 150)
redeemButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
redeemButton.BorderSizePixel = 0
redeemButton.Text = "🎁 REDEEM CODE"
redeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
redeemButton.TextScaled = true
redeemButton.Font = Enum.Font.GothamBold
redeemButton.Parent = codesGui

local redeemCorner = Instance.new("UICorner")
redeemCorner.CornerRadius = UDim.new(0, 15)
redeemCorner.Parent = redeemButton

-- Available codes display
local availableCodesFrame = Instance.new("ScrollingFrame")
availableCodesFrame.Size = UDim2.new(1, -40, 1, -220)
availableCodesFrame.Position = UDim2.new(0, 20, 0, 220)
availableCodesFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
availableCodesFrame.BorderSizePixel = 0
availableCodesFrame.ScrollBarThickness = 6
availableCodesFrame.Parent = codesGui

local availableCodesCorner = Instance.new("UICorner")
availableCodesCorner.CornerRadius = UDim.new(0, 15)
availableCodesCorner.Parent = availableCodesFrame

local codesLayout = Instance.new("UIListLayout")
codesLayout.Padding = UDim.new(0, 10)
codesLayout.Parent = availableCodesFrame

-- Populate available codes
for code, data in pairs(CodesDatabase) do
    local codeFrame = Instance.new("Frame")
    codeFrame.Size = UDim2.new(1, -20, 0, 60)
    codeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    codeFrame.BorderSizePixel = 0
    codeFrame.Parent = availableCodesFrame
    
    local codeFrameCorner = Instance.new("UICorner")
    codeFrameCorner.CornerRadius = UDim.new(0, 10)
    codeFrameCorner.Parent = codeFrame
    
    local codeText = Instance.new("TextLabel")
    codeText.Size = UDim2.new(0.6, 0, 1, 0)
    codeText.Position = UDim2.new(0, 10, 0, 0)
    codeText.BackgroundTransparency = 1
    codeText.Text = code
    codeText.TextColor3 = Color3.fromRGB(255, 215, 0)
    codeText.TextScaled = true
    codeText.Font = Enum.Font.GothamBold
    codeText.TextXAlignment = Enum.TextXAlignment.Left
    codeText.Parent = codeFrame
    
    local rewardText = Instance.new("TextLabel")
    rewardText.Size = UDim2.new(0.4, -10, 1, 0)
    rewardText.Position = UDim2.new(0.6, 0, 0, 0)
    rewardText.BackgroundTransparency = 1
    rewardText.Text = data.coins .. " 💰 " .. data.gems .. " 💎"
    rewardText.TextColor3 = Color3.fromRGB(150, 255, 150)
    rewardText.TextScaled = true
    rewardText.Font = Enum.Font.Gotham
    rewardText.TextXAlignment = Enum.TextXAlignment.Right
    rewardText.Parent = codeFrame
end

-- 📖 PREMIUM INDEX SYSTEM
local indexGui = Instance.new("Frame")
indexGui.Name = "IndexSystem"
indexGui.Size = UDim2.new(0, isMobile() and 350 or 550, 0, isMobile() and 500 or 650)
indexGui.Position = UDim2.new(0.5, isMobile() and -175 or -275, 0.5, isMobile() and -250 or -325)
indexGui.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
indexGui.BorderSizePixel = 0
indexGui.Visible = false
indexGui.Parent = screenGui

local indexCorner = Instance.new("UICorner")
indexCorner.CornerRadius = UDim.new(0, 20)
indexCorner.Parent = indexGui

local indexStroke = Instance.new("UIStroke")
indexStroke.Color = Color3.fromRGB(150, 255, 150)
indexStroke.Thickness = 3
indexStroke.Parent = indexGui

-- Index header
local indexHeader = Instance.new("Frame")
indexHeader.Size = UDim2.new(1, 0, 0, 60)
indexHeader.Position = UDim2.new(0, 0, 0, 0)
indexHeader.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
indexHeader.BorderSizePixel = 0
indexHeader.Parent = indexGui

local indexHeaderCorner = Instance.new("UICorner")
indexHeaderCorner.CornerRadius = UDim.new(0, 20)
indexHeaderCorner.Parent = indexHeader

local indexTitle = Instance.new("TextLabel")
indexTitle.Size = UDim2.new(1, -100, 1, 0)
indexTitle.Position = UDim2.new(0, 20, 0, 0)
indexTitle.BackgroundTransparency = 1
indexTitle.Text = "📖 GLITCH CODEX"
indexTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
indexTitle.TextScaled = true
indexTitle.Font = Enum.Font.GothamBold
indexTitle.TextXAlignment = Enum.TextXAlignment.Left
indexTitle.Parent = indexHeader

local indexClose = Instance.new("TextButton")
indexClose.Size = UDim2.new(0, 40, 0, 40)
indexClose.Position = UDim2.new(1, -50, 0.5, -20)
indexClose.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
indexClose.BorderSizePixel = 0
indexClose.Text = "✕"
indexClose.TextColor3 = Color3.fromRGB(255, 255, 255)
indexClose.TextScaled = true
indexClose.Font = Enum.Font.GothamBold
indexClose.Parent = indexHeader

local indexCloseCorner = Instance.new("UICorner")
indexCloseCorner.CornerRadius = UDim.new(1, 0)
indexCloseCorner.Parent = indexClose

-- Index content
local indexContent = Instance.new("ScrollingFrame")
indexContent.Size = UDim2.new(1, -20, 1, -80)
indexContent.Position = UDim2.new(0, 10, 0, 70)
indexContent.BackgroundTransparency = 1
indexContent.ScrollBarThickness = 8
indexContent.ScrollBarImageColor3 = Color3.fromRGB(150, 255, 150)
indexContent.BorderSizePixel = 0
indexContent.Parent = indexGui

local indexLayout = Instance.new("UIListLayout")
indexLayout.Padding = UDim.new(0, 15)
indexLayout.Parent = indexContent

-- Populate glitch index
for i, glitch in ipairs(GlitchDatabase) do
    local glitchEntry = Instance.new("Frame")
    glitchEntry.Size = UDim2.new(1, -20, 0, isMobile() and 100 or 120)
    glitchEntry.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    glitchEntry.BorderSizePixel = 0
    glitchEntry.Parent = indexContent
    
    local glitchEntryCorner = Instance.new("UICorner")
    glitchEntryCorner.CornerRadius = UDim.new(0, 15)
    glitchEntryCorner.Parent = glitchEntry
    
    local glitchEntryStroke = Instance.new("UIStroke")
    glitchEntryStroke.Color = glitch.color
    glitchEntryStroke.Thickness = 2
    glitchEntryStroke.Parent = glitchEntry
    
    local glitchEntryGradient = Instance.new("UIGradient")
    glitchEntryGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
        ColorSequenceKeypoint.new(1, glitch.gradientColor)
    }
    glitchEntryGradient.Rotation = 45
    glitchEntryGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.8)
    }
    glitchEntryGradient.Parent = glitchEntry
    
    -- Glitch icon
    local glitchIcon = Instance.new("ImageLabel")
    glitchIcon.Size = UDim2.new(0, isMobile() and 70 or 90, 0, isMobile() and 70 or 90)
    glitchIcon.Position = UDim2.new(0, 15, 0.5, isMobile() and -35 or -45)
    glitchIcon.BackgroundColor3 = glitch.color
    glitchIcon.BorderSizePixel = 0
    glitchIcon.Image = glitch.icon
    glitchIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    glitchIcon.Parent = glitchEntry
    
    local glitchIconCorner = Instance.new("UICorner")
    glitchIconCorner.CornerRadius = UDim.new(0, 15)
    glitchIconCorner.Parent = glitchIcon
    
    -- Glitch info
    local glitchName = Instance.new("TextLabel")
    glitchName.Size = UDim2.new(1, isMobile() and -100 or -120, 0, 25)
    glitchName.Position = UDim2.new(0, isMobile() and 100 or 120, 0, 10)
    glitchName.BackgroundTransparency = 1
    glitchName.Text = glitch.name
    glitchName.TextColor3 = Color3.fromRGB(255, 255, 255)
    glitchName.TextScaled = true
    glitchName.Font = Enum.Font.GothamBold
    glitchName.TextXAlignment = Enum.TextXAlignment.Left
    glitchName.Parent = glitchEntry
    
    local glitchRarity = Instance.new("TextLabel")
    glitchRarity.Size = UDim2.new(1, isMobile() and -100 or -120, 0, 20)
    glitchRarity.Position = UDim2.new(0, isMobile() and 100 or 120, 0, 35)
    glitchRarity.BackgroundTransparency = 1
    glitchRarity.Text = string.format("%s (%d%%)", glitch.rarity, glitch.chance)
    glitchRarity.TextColor3 = glitch.color
    glitchRarity.TextScaled = true
    glitchRarity.Font = Enum.Font.Gotham
    glitchRarity.TextXAlignment = Enum.TextXAlignment.Left
    glitchRarity.Parent = glitchEntry
    
    local glitchBonus = Instance.new("TextLabel")
    glitchBonus.Size = UDim2.new(1, isMobile() and -100 or -120, 0, 18)
    glitchBonus.Position = UDim2.new(0, isMobile() and 100 or 120, 0, 55)
    glitchBonus.BackgroundTransparency = 1
    glitchBonus.Text = string.format("%.1fx Coins | +%d Gems", glitch.coinBonus, glitch.gemBonus)
    glitchBonus.TextColor3 = Color3.fromRGB(255, 215, 0)
    glitchBonus.TextScaled = true
    glitchBonus.Font = Enum.Font.Gotham
    glitchBonus.TextXAlignment = Enum.TextXAlignment.Left
    glitchBonus.Parent = glitchEntry
    
    local glitchDesc = Instance.new("TextLabel")
    glitchDesc.Size = UDim2.new(1, isMobile() and -100 or -120, 0, 15)
    glitchDesc.Position = UDim2.new(0, isMobile() and 100 or 120, 0, isMobile() and 75 or 85)
    glitchDesc.BackgroundTransparency = 1
    glitchDesc.Text = glitch.description
    glitchDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    glitchDesc.TextScaled = true
    glitchDesc.Font = Enum.Font.Gotham
    glitchDesc.TextXAlignment = Enum.TextXAlignment.Left
    glitchDesc.Parent = glitchEntry
end

-- 🔔 PREMIUM NOTIFICATION SYSTEM
local notificationQueue = {}
local activeNotifications = {}

local function createNotification(message, color, duration)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, isMobile() and 280 or 350, 0, isMobile() and 60 or 80)
    notification.Position = UDim2.new(0.5, isMobile() and -140 or -175, 0, -100)
    notification.BackgroundColor3 = color or Color3.fromRGB(50, 50, 70)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 15)
    notificationCorner.Parent = notification
    
    local notificationStroke = Instance.new("UIStroke")
    notificationStroke.Color = Color3.fromRGB(255, 255, 255)
    notificationStroke.Thickness = 2
    notificationStroke.Parent = notification
    
    local notificationGradient = Instance.new("UIGradient")
    notificationGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color or Color3.fromRGB(50, 50, 70)),
        ColorSequenceKeypoint.new(1, Color3.new(0.2, 0.2, 0.3))
    }
    notificationGradient.Rotation = 45
    notificationGradient.Parent = notification
    
    local notificationText = Instance.new("TextLabel")
    notificationText.Size = UDim2.new(1, -20, 1, 0)
    notificationText.Position = UDim2.new(0, 10, 0, 0)
    notificationText.BackgroundTransparency = 1
    notificationText.Text = message
    notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notificationText.TextScaled = true
    notificationText.Font = Enum.Font.Gotham
    notificationText.Parent = notification
    
    -- Play notification sound
    if GameData.settings.soundEnabled then
        Sounds.notification:Play()
    end
    
    -- Animate in
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, isMobile() and -140 or -175, 0, 20 + (#activeNotifications * (isMobile() and 70 or 90)))
    })
    tweenIn:Play()
    
    table.insert(activeNotifications, notification)
    
    -- Auto remove
    spawn(function()
        task.wait(duration or 4)
        
        -- Find and remove from active notifications
        for i, activeNotif in ipairs(activeNotifications) do
            if activeNotif == notification then
                table.remove(activeNotifications, i)
                break
            end
        end
        
        -- Animate out
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, isMobile() and -140 or -175, 0, -100),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        
        tweenOut.Completed:Connect(function()
            notification:Destroy()
            
            -- Reposition remaining notifications
            for i, activeNotif in ipairs(activeNotifications) do
                TweenService:Create(activeNotif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(0.5, isMobile() and -140 or -175, 0, 20 + ((i-1) * (isMobile() and 70 or 90)))
                }):Play()
            end
        end)
    end)
end

-- 🎮 GAME FUNCTIONS
local function updateCurrency()
    local coinTween = TweenService:Create(coinLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextColor3 = Color3.fromRGB(255, 215, 0)
    })
    coinTween:Play()
    coinLabel.Text = tostring(GameData.coins)
    
    local gemTween = TweenService:Create(gemLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextColor3 = Color3.fromRGB(150, 255, 255)
    })
    gemTween:Play()
    gemLabel.Text = tostring(GameData.gems)
    
    task.wait(0.3)
    TweenService:Create(coinLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    TweenService:Create(gemLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end

local function addGlitchToInventory(glitch)
    table.insert(GameData.glitches, glitch)
    GameData.coinMultiplier = math.max(GameData.coinMultiplier, glitch.coinBonus)
    GameData.gems = GameData.gems + glitch.gemBonus
    
    -- Create inventory slot
    local glitchSlot = Instance.new("Frame")
    glitchSlot.Size = UDim2.new(0, isMobile() and 90 or 120, 0, isMobile() and 90 or 120)
    glitchSlot.BackgroundColor3 = glitch.color
    glitchSlot.BorderSizePixel = 0
    glitchSlot.Parent = inventoryContent
    
    local slotCorner = Instance.new("UICorner")
    slotCorner.CornerRadius = UDim.new(0, 15)
    slotCorner.Parent = glitchSlot
    
    local slotStroke = Instance.new("UIStroke")
    slotStroke.Color = Color3.fromRGB(255, 255, 255)
    slotStroke.Thickness = 3
    slotStroke.Parent = glitchSlot
    
    local slotGradient = Instance.new("UIGradient")
    slotGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, glitch.color),
        ColorSequenceKeypoint.new(1, glitch.gradientColor)
    }
    slotGradient.Rotation = 45
    slotGradient.Parent = glitchSlot
    
    local glitchIcon = Instance.new("ImageLabel")
    glitchIcon.Size = UDim2.new(0.7, 0, 0.7, 0)
    glitchIcon.Position = UDim2.new(0.15, 0, 0.15, 0)
    glitchIcon.BackgroundTransparency = 1
    glitchIcon.Image = glitch.icon
    glitchIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    glitchIcon.Parent = glitchSlot
    
    -- Tooltip system
    local tooltip = Instance.new("Frame")
    tooltip.Size = UDim2.new(0, 200, 0, 100)
    tooltip.Position = UDim2.new(0, 130, 0, 0)
    tooltip.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.Parent = glitchSlot
    
    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 10)
    tooltipCorner.Parent = tooltip
    
    local tooltipStroke = Instance.new("UIStroke")
    tooltipStroke.Color = glitch.color
    tooltipStroke.Thickness = 2
    tooltipStroke.Parent = tooltip
    
    local tooltipText = Instance.new("TextLabel")
    tooltipText.Size = UDim2.new(1, -10, 1, -10)
    tooltipText.Position = UDim2.new(0, 5, 0, 5)
    tooltipText.BackgroundTransparency = 1
    tooltipText.Text = string.format("%s\n%s\n%.1fx Coins\n+%d Gems\n%s", glitch.name, glitch.rarity, glitch.coinBonus, glitch.gemBonus, glitch.effect)
    tooltipText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltipText.TextScaled = true
    tooltipText.Font = Enum.Font.Gotham
    tooltipText.Parent = tooltip
    
    glitchSlot.MouseEnter:Connect(function()
        tooltip.Visible = true
        TweenService:Create(tooltip, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, 220, 0, 110)}):Play()
    end)
    
    glitchSlot.MouseLeave:Connect(function()
        TweenService:Create(tooltip, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, 200, 0, 100)}):Play()
        task.wait(0.2)
        tooltip.Visible = false
    end)
    
    -- Particle effects for rare glitches
    if glitch.rarity == "Legendary" or glitch.rarity == "Mythic" then
        createParticleEffect(glitchSlot, glitch.color)
    end
    
    -- Update canvas size
    inventoryContent.CanvasSize = UDim2.new(0, 0, 0, math.ceil(#GameData.glitches / (isMobile() and 3 or 4)) * (isMobile() and 100 or 130))
    
    -- Show notification
    createNotification(string.format("🎉 %s %s obtained!", glitch.rarity, glitch.name), glitch.color, 5)
end

local function rollForGlitch()
    local rollCost = 250
    
    if GameData.coins < rollCost then
        createNotification("❌ Not enough coins to roll!", Color3.fromRGB(255, 100, 100), 3)
        return
    end
    
    GameData.coins = GameData.coins - rollCost
    updateCurrency()
    
    -- Play roll sound
    if GameData.settings.soundEnabled then
        Sounds.roll:Play()
    end
    
    -- Animate roll button
    local rollAnimation = TweenService:Create(rollFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = rollFrame.Size - UDim2.new(0, 20, 0, 20)})
    rollAnimation:Play()
    rollAnimation.Completed:Connect(function()
        TweenService:Create(rollFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = rollFrame.Size + UDim2.new(0, 20, 0, 20)}):Play()
    end)
    
    -- Determine rolled glitch
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
        -- Play appropriate sound based on rarity
        task.wait(0.5) -- Suspense
        
        if GameData.settings.soundEnabled then
            if rolledGlitch.rarity == "Mythic" then
                Sounds.mythic:Play()
            elseif rolledGlitch.rarity == "Legendary" then
                Sounds.legendary:Play()
            elseif rolledGlitch.rarity == "Epic" or rolledGlitch.rarity == "Rare" then
                Sounds.rare:Play()
            else
                Sounds.success:Play()
            end
        end
        
        addGlitchToInventory(rolledGlitch)
    end
end

local function redeemCode()
    local code = string.upper(codeInput.Text:gsub("%s", ""))
    local codeData = CodesDatabase[code]
    
    if codeData and codeData.active and not GameData.usedCodes[code] then
        GameData.coins = GameData.coins + codeData.coins
        GameData.gems = GameData.gems + codeData.gems
        GameData.usedCodes[code] = true
        
        updateCurrency()
        
        if GameData.settings.soundEnabled then
            Sounds.gem:Play()
        end
        
        createNotification(string.format("✅ Code redeemed! +%d coins, +%d gems", codeData.coins, codeData.gems), Color3.fromRGB(100, 255, 100), 4)
        codeInput.Text = ""
    else
        createNotification("❌ Invalid or already used code!", Color3.fromRGB(255, 100, 100), 3)
        codeInput.Text = ""
    end
end

-- 🔄 PASSIVE INCOME SYSTEM
spawn(function()
    while true do
        task.wait(2)
        local coinsToAdd = math.floor(15 * GameData.coinMultiplier)
        GameData.coins = GameData.coins + coinsToAdd
        updateCurrency()
        
        -- Occasional floating coins
        if math.random(1, 8) == 1 then
            local floatingCoin = Instance.new("ImageLabel")
            floatingCoin.Size = UDim2.new(0, 30, 0, 30)
            floatingCoin.Position = UDim2.new(0, math.random(100, getScreenSize().X - 100), 1, 0)
            floatingCoin.BackgroundTransparency = 1
            floatingCoin.Image = "rbxassetid://6031075938"
            floatingCoin.ImageColor3 = Color3.fromRGB(255, 215, 0)
            floatingCoin.Parent = screenGui
            
            local floatTween = TweenService:Create(floatingCoin, TweenInfo.new(3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(floatingCoin.Position.X.Scale, floatingCoin.Position.X.Offset, 0, -50),
                ImageTransparency = 1,
                Rotation = 360
            })
            floatTween:Play()
            floatTween.Completed:Connect(function()
                floatingCoin:Destroy()
            end)
        end
    end
end)

-- 🎯 EVENT CONNECTIONS
rollButton.MouseButton1Click:Connect(rollForGlitch)
redeemButton.MouseButton1Click:Connect(redeemCode)

-- Navigation button connections
navigationButtons.Inventory.MouseButton1Click:Connect(function()
    inventoryGui.Visible = true
    if GameData.settings.soundEnabled then
        Sounds.ui:Play()
    end
end)

navigationButtons.Codes.MouseButton1Click:Connect(function()
    codesGui.Visible = true
    if GameData.settings.soundEnabled then
        Sounds.ui:Play()
    end
end)

navigationButtons.Index.MouseButton1Click:Connect(function()
    indexGui.Visible = true
    if GameData.settings.soundEnabled then
        Sounds.ui:Play()
    end
end)

-- Close button connections
inventoryClose.MouseButton1Click:Connect(function()
    inventoryGui.Visible = false
end)

codesClose.MouseButton1Click:Connect(function()
    codesGui.Visible = false
end)

indexClose.MouseButton1Click:Connect(function()
    indexGui.Visible = false
end)

-- Code input enter key support
codeInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        redeemCode()
    end
end)

-- 🚀 INITIALIZATION
updateCurrency()

-- Welcome sequence
spawn(function()
    task.wait(1)
    createNotification("🎮 Welcome to Premium Glitch Aura!", Color3.fromRGB(100, 150, 255), 5)
    task.wait(3)
    createNotification("💎 Use codes for free gems and coins!", Color3.fromRGB(255, 150, 100), 4)
    task.wait(2)
    createNotification("🎲 Start rolling for legendary glitches!", Color3.fromRGB(150, 255, 150), 4)
end)

-- Auto-adjust UI for screen size changes
screenGui.Changed:Connect(function(property)
    if property == "AbsoluteSize" then
        -- Responsive adjustments would go here
    end
end)