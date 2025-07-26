-- 🎮 GLITCH AURA GAME SYSTEM - SEPARATE COMPONENTS 🎮
-- Modern UI with Individual Positioned Elements
-- Place in StarterPlayerScripts as LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🎯 GAME DATA
local GameData = {
    coins = 500,
    gems = 25,
    glitches = {},
    potions = {},
    coinMultiplier = 1,
    usedCodes = {},
    settings = {
        soundEnabled = true,
        notificationsEnabled = true
    }
}

-- 🌟 GLITCH DATABASE
local GlitchDatabase = {
    {
        name = "Shadow Phantom",
        rarity = "Common",
        chance = 35,
        coinBonus = 1.3,
        color = Color3.fromRGB(45, 45, 65),
        icon = "rbxassetid://17368194109",
        description = "A mysterious glitch that lurks in darkness"
    },
    {
        name = "Neon Surge",
        rarity = "Uncommon", 
        chance = 25,
        coinBonus = 1.6,
        color = Color3.fromRGB(0, 255, 150),
        icon = "rbxassetid://17368089878",
        description = "Crackling with electric energy"
    },
    {
        name = "Inferno Core",
        rarity = "Rare",
        chance = 20,
        coinBonus = 2.2,
        color = Color3.fromRGB(255, 100, 0),
        icon = "rbxassetid://17368084284",
        description = "Burns with the intensity of a thousand suns"
    },
    {
        name = "Prismatic Void",
        rarity = "Epic",
        chance = 12,
        coinBonus = 3.5,
        color = Color3.fromRGB(255, 0, 255),
        icon = "rbxassetid://17368204813",
        description = "Bends reality with prismatic power"
    },
    {
        name = "Void Reaper",
        rarity = "Legendary",
        chance = 6,
        coinBonus = 6.0,
        color = Color3.fromRGB(100, 0, 200),
        icon = "rbxassetid://17368208589",
        description = "Harvests power from the void itself"
    },
    {
        name = "Cosmic Genesis",
        rarity = "Mythic",
        chance = 2,
        coinBonus = 12.0,
        color = Color3.fromRGB(255, 215, 0),
        icon = "rbxassetid://17368194109",
        description = "The birth of stars condensed into pure energy"
    }
}

-- 💎 CODES DATABASE
local CodesDatabase = {
    ["GLITCH2024"] = {coins = 2500, gems = 25, active = true, duration = 7}, -- 7 days
    ["MYTHICPOWER"] = {coins = 1500, gems = 15, active = true, duration = 5},
    ["VOIDMASTER"] = {coins = 3000, gems = 30, active = true, duration = 10},
    ["NEWPLAYER"] = {coins = 1000, gems = 10, active = true, duration = 30},
    ["WELCOME"] = {coins = 500, gems = 5, active = true, duration = 14}
}

-- 🎵 SOUND SYSTEM
local function createSound(id, volume)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. id
    sound.Volume = volume or 0.5
    sound.Parent = SoundService
    return sound
end

local Sounds = {
    roll = createSound("131961136", 0.6),
    success = createSound("131961136", 0.8),
    rare = createSound("131961136", 1.0),
    coin = createSound("131961136", 0.4),
    ui = createSound("131961136", 0.3)
}

-- 📱 RESPONSIVE DESIGN
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- 🎨 MAIN SCREEN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GlitchAuraGame"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- 💰 COIN DISPLAY (Top Left)
local coinFrame = Instance.new("Frame")
coinFrame.Name = "CoinDisplay"
coinFrame.Size = UDim2.new(0, isMobile() and 180 or 220, 0, isMobile() and 50 or 60)
coinFrame.Position = UDim2.new(0, 20, 0, 20)
coinFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
coinFrame.BorderSizePixel = 0
coinFrame.Parent = screenGui

local coinCorner = Instance.new("UICorner")
coinCorner.CornerRadius = UDim.new(0, 12)
coinCorner.Parent = coinFrame

local coinStroke = Instance.new("UIStroke")
coinStroke.Color = Color3.fromRGB(255, 215, 0)
coinStroke.Thickness = 2
coinStroke.Parent = coinFrame

local coinIcon = Instance.new("ImageLabel")
coinIcon.Size = UDim2.new(0, 30, 0, 30)
coinIcon.Position = UDim2.new(0, 10, 0.5, -15)
coinIcon.BackgroundTransparency = 1
coinIcon.Image = "rbxassetid://17368084284"
coinIcon.ImageColor3 = Color3.fromRGB(255, 215, 0)
coinIcon.Parent = coinFrame

local coinLabel = Instance.new("TextLabel")
coinLabel.Size = UDim2.new(1, -50, 1, 0)
coinLabel.Position = UDim2.new(0, 50, 0, 0)
coinLabel.BackgroundTransparency = 1
coinLabel.Text = tostring(GameData.coins)
coinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coinLabel.TextScaled = true
coinLabel.Font = Enum.Font.GothamBold
coinLabel.Parent = coinFrame

-- 🎲 ROLL BUTTON (Bottom Middle)
local rollButton = Instance.new("ImageButton")
rollButton.Name = "RollButton"
rollButton.Size = UDim2.new(0, isMobile() and 80 or 100, 0, isMobile() and 80 or 100)
rollButton.Position = UDim2.new(0.5, isMobile() and -40 or -50, 1, isMobile() and -100 or -120)
rollButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
rollButton.BorderSizePixel = 0
rollButton.Image = "rbxassetid://125264363254178"
rollButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
rollButton.Parent = screenGui

local rollCorner = Instance.new("UICorner")
rollCorner.CornerRadius = UDim.new(0.5, 0)
rollCorner.Parent = rollButton

local rollStroke = Instance.new("UIStroke")
rollStroke.Color = Color3.fromRGB(100, 255, 100)
rollStroke.Thickness = 3
rollStroke.Parent = rollButton

local rollCostLabel = Instance.new("TextLabel")
rollCostLabel.Size = UDim2.new(1, 0, 0, 25)
rollCostLabel.Position = UDim2.new(0, 0, 1, 5)
rollCostLabel.BackgroundTransparency = 1
rollCostLabel.Text = "100 Coins"
rollCostLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
rollCostLabel.TextScaled = true
rollCostLabel.Font = Enum.Font.Gotham
rollCostLabel.Parent = rollButton

-- 🎒 INVENTORY BUTTON (Left Middle)
local inventoryButton = Instance.new("ImageButton")
inventoryButton.Name = "InventoryButton"
inventoryButton.Size = UDim2.new(0, isMobile() and 60 or 80, 0, isMobile() and 60 or 80)
inventoryButton.Position = UDim2.new(0, 20, 0.5, -40)
inventoryButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
inventoryButton.BorderSizePixel = 0
inventoryButton.Image = "rbxassetid://18209609229"
inventoryButton.ImageColor3 = Color3.fromRGB(100, 150, 255)
inventoryButton.Parent = screenGui

local inventoryCorner = Instance.new("UICorner")
inventoryCorner.CornerRadius = UDim.new(0, 12)
inventoryCorner.Parent = inventoryButton

local inventoryStroke = Instance.new("UIStroke")
inventoryStroke.Color = Color3.fromRGB(100, 150, 255)
inventoryStroke.Thickness = 2
inventoryStroke.Parent = inventoryButton

-- 🎫 CODES BUTTON (Left Middle - Below Inventory)
local codesButton = Instance.new("ImageButton")
codesButton.Name = "CodesButton"
codesButton.Size = UDim2.new(0, isMobile() and 60 or 80, 0, isMobile() and 60 or 80)
codesButton.Position = UDim2.new(0, 20, 0.5, isMobile() and 40 or 60)
codesButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
codesButton.BorderSizePixel = 0
codesButton.Image = "rbxassetid://18209599690"
codesButton.ImageColor3 = Color3.fromRGB(255, 150, 100)
codesButton.Parent = screenGui

local codesCorner = Instance.new("UICorner")
codesCorner.CornerRadius = UDim.new(0, 12)
codesCorner.Parent = codesButton

local codesStroke = Instance.new("UIStroke")
codesStroke.Color = Color3.fromRGB(255, 150, 100)
codesStroke.Thickness = 2
codesStroke.Parent = codesButton

-- 📖 INDEX BUTTON (Left Middle - Below Codes)
local indexButton = Instance.new("ImageButton")
indexButton.Name = "IndexButton"
indexButton.Size = UDim2.new(0, isMobile() and 60 or 80, 0, isMobile() and 60 or 80)
indexButton.Position = UDim2.new(0, 20, 0.5, isMobile() and 120 or 160)
indexButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
indexButton.BorderSizePixel = 0
indexButton.Image = "rbxassetid://76367970334970"
indexButton.ImageColor3 = Color3.fromRGB(150, 255, 150)
indexButton.Parent = screenGui

local indexCorner = Instance.new("UICorner")
indexCorner.CornerRadius = UDim.new(0, 12)
indexCorner.Parent = indexButton

local indexStroke = Instance.new("UIStroke")
indexStroke.Color = Color3.fromRGB(150, 255, 150)
indexStroke.Thickness = 2
indexStroke.Parent = indexButton

-- 🎒 INVENTORY GUI (Hidden by default)
local inventoryGui = Instance.new("Frame")
inventoryGui.Name = "InventoryGui"
inventoryGui.Size = UDim2.new(0, isMobile() and 350 or 450, 0, isMobile() and 400 or 500)
inventoryGui.Position = UDim2.new(0.5, isMobile() and -175 or -225, 0.5, isMobile() and -200 or -250)
inventoryGui.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
inventoryGui.BorderSizePixel = 0
inventoryGui.Visible = false
inventoryGui.Parent = screenGui

local inventoryGuiCorner = Instance.new("UICorner")
inventoryGuiCorner.CornerRadius = UDim.new(0, 15)
inventoryGuiCorner.Parent = inventoryGui

local inventoryGuiStroke = Instance.new("UIStroke")
inventoryGuiStroke.Color = Color3.fromRGB(100, 150, 255)
inventoryGuiStroke.Thickness = 3
inventoryGuiStroke.Parent = inventoryGui

-- Inventory Header
local inventoryHeader = Instance.new("Frame")
inventoryHeader.Size = UDim2.new(1, 0, 0, 50)
inventoryHeader.Position = UDim2.new(0, 0, 0, 0)
inventoryHeader.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
inventoryHeader.BorderSizePixel = 0
inventoryHeader.Parent = inventoryGui

local inventoryHeaderCorner = Instance.new("UICorner")
inventoryHeaderCorner.CornerRadius = UDim.new(0, 15)
inventoryHeaderCorner.Parent = inventoryHeader

local inventoryTitle = Instance.new("TextLabel")
inventoryTitle.Size = UDim2.new(1, -60, 1, 0)
inventoryTitle.Position = UDim2.new(0, 15, 0, 0)
inventoryTitle.BackgroundTransparency = 1
inventoryTitle.Text = "🎒 INVENTORY"
inventoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
inventoryTitle.TextScaled = true
inventoryTitle.Font = Enum.Font.GothamBold
inventoryTitle.TextXAlignment = Enum.TextXAlignment.Left
inventoryTitle.Parent = inventoryHeader

local inventoryCloseButton = Instance.new("ImageButton")
inventoryCloseButton.Size = UDim2.new(0, 35, 0, 35)
inventoryCloseButton.Position = UDim2.new(1, -45, 0.5, -17.5)
inventoryCloseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
inventoryCloseButton.BorderSizePixel = 0
inventoryCloseButton.Image = "rbxassetid://17368208589"
inventoryCloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
inventoryCloseButton.Parent = inventoryHeader

local inventoryCloseCorner = Instance.new("UICorner")
inventoryCloseCorner.CornerRadius = UDim.new(1, 0)
inventoryCloseCorner.Parent = inventoryCloseButton

-- Glitch Slots Section
local glitchSection = Instance.new("Frame")
glitchSection.Size = UDim2.new(1, -20, 0.6, -30)
glitchSection.Position = UDim2.new(0, 10, 0, 60)
glitchSection.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
glitchSection.BorderSizePixel = 0
glitchSection.Parent = inventoryGui

local glitchSectionCorner = Instance.new("UICorner")
glitchSectionCorner.CornerRadius = UDim.new(0, 10)
glitchSectionCorner.Parent = glitchSection

local glitchSectionTitle = Instance.new("TextLabel")
glitchSectionTitle.Size = UDim2.new(1, 0, 0, 30)
glitchSectionTitle.Position = UDim2.new(0, 0, 0, 0)
glitchSectionTitle.BackgroundTransparency = 1
glitchSectionTitle.Text = "✨ GLITCHES"
glitchSectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
glitchSectionTitle.TextScaled = true
glitchSectionTitle.Font = Enum.Font.Gotham
glitchSectionTitle.Parent = glitchSection

local glitchScrollFrame = Instance.new("ScrollingFrame")
glitchScrollFrame.Size = UDim2.new(1, -10, 1, -40)
glitchScrollFrame.Position = UDim2.new(0, 5, 0, 35)
glitchScrollFrame.BackgroundTransparency = 1
glitchScrollFrame.ScrollBarThickness = 6
glitchScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
glitchScrollFrame.BorderSizePixel = 0
glitchScrollFrame.Parent = glitchSection

local glitchGrid = Instance.new("UIGridLayout")
glitchGrid.CellSize = UDim2.new(0, isMobile() and 70 or 90, 0, isMobile() and 70 or 90)
glitchGrid.CellPadding = UDim2.new(0, 8, 0, 8)
glitchGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
glitchGrid.Parent = glitchScrollFrame

-- Potion Slots Section
local potionSection = Instance.new("Frame")
potionSection.Size = UDim2.new(1, -20, 0.4, -20)
potionSection.Position = UDim2.new(0, 10, 0.6, 10)
potionSection.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
potionSection.BorderSizePixel = 0
potionSection.Parent = inventoryGui

local potionSectionCorner = Instance.new("UICorner")
potionSectionCorner.CornerRadius = UDim.new(0, 10)
potionSectionCorner.Parent = potionSection

local potionSectionTitle = Instance.new("TextLabel")
potionSectionTitle.Size = UDim2.new(1, 0, 0, 30)
potionSectionTitle.Position = UDim2.new(0, 0, 0, 0)
potionSectionTitle.BackgroundTransparency = 1
potionSectionTitle.Text = "🧪 POTIONS (Coming Soon)"
potionSectionTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
potionSectionTitle.TextScaled = true
potionSectionTitle.Font = Enum.Font.Gotham
potionSectionTitle.Parent = potionSection

-- 🎫 CODES GUI (Hidden by default)
local codesGui = Instance.new("Frame")
codesGui.Name = "CodesGui"
codesGui.Size = UDim2.new(0, isMobile() and 300 or 400, 0, isMobile() and 350 or 450)
codesGui.Position = UDim2.new(0.5, isMobile() and -150 or -200, 0.5, isMobile() and -175 or -225)
codesGui.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
codesGui.BorderSizePixel = 0
codesGui.Visible = false
codesGui.Parent = screenGui

local codesGuiCorner = Instance.new("UICorner")
codesGuiCorner.CornerRadius = UDim.new(0, 15)
codesGuiCorner.Parent = codesGui

local codesGuiStroke = Instance.new("UIStroke")
codesGuiStroke.Color = Color3.fromRGB(255, 150, 100)
codesGuiStroke.Thickness = 3
codesGuiStroke.Parent = codesGui

-- Codes Header
local codesHeader = Instance.new("Frame")
codesHeader.Size = UDim2.new(1, 0, 0, 50)
codesHeader.Position = UDim2.new(0, 0, 0, 0)
codesHeader.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
codesHeader.BorderSizePixel = 0
codesHeader.Parent = codesGui

local codesHeaderCorner = Instance.new("UICorner")
codesHeaderCorner.CornerRadius = UDim.new(0, 15)
codesHeaderCorner.Parent = codesHeader

local codesTitle = Instance.new("TextLabel")
codesTitle.Size = UDim2.new(1, -60, 1, 0)
codesTitle.Position = UDim2.new(0, 15, 0, 0)
codesTitle.BackgroundTransparency = 1
codesTitle.Text = "🎫 REDEEM CODES"
codesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
codesTitle.TextScaled = true
codesTitle.Font = Enum.Font.GothamBold
codesTitle.TextXAlignment = Enum.TextXAlignment.Left
codesTitle.Parent = codesHeader

local codesCloseButton = Instance.new("ImageButton")
codesCloseButton.Size = UDim2.new(0, 35, 0, 35)
codesCloseButton.Position = UDim2.new(1, -45, 0.5, -17.5)
codesCloseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
codesCloseButton.BorderSizePixel = 0
codesCloseButton.Image = "rbxassetid://17368208589"
codesCloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
codesCloseButton.Parent = codesHeader

local codesCloseCorner = Instance.new("UICorner")
codesCloseCorner.CornerRadius = UDim.new(1, 0)
codesCloseCorner.Parent = codesCloseButton

-- Code Input
local codeInput = Instance.new("TextBox")
codeInput.Size = UDim2.new(1, -30, 0, 40)
codeInput.Position = UDim2.new(0, 15, 0, 70)
codeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
codeInput.BorderSizePixel = 0
codeInput.Text = ""
codeInput.PlaceholderText = "Enter code here..."
codeInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
codeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
codeInput.TextScaled = true
codeInput.Font = Enum.Font.Gotham
codeInput.Parent = codesGui

local codeInputCorner = Instance.new("UICorner")
codeInputCorner.CornerRadius = UDim.new(0, 10)
codeInputCorner.Parent = codeInput

-- Redeem Button
local redeemButton = Instance.new("TextButton")
redeemButton.Size = UDim2.new(1, -30, 0, 40)
redeemButton.Position = UDim2.new(0, 15, 0, 120)
redeemButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
redeemButton.BorderSizePixel = 0
redeemButton.Text = "🎁 REDEEM CODE"
redeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
redeemButton.TextScaled = true
redeemButton.Font = Enum.Font.GothamBold
redeemButton.Parent = codesGui

local redeemCorner = Instance.new("UICorner")
redeemCorner.CornerRadius = UDim.new(0, 10)
redeemCorner.Parent = redeemButton

-- Available Codes List
local availableCodesFrame = Instance.new("ScrollingFrame")
availableCodesFrame.Size = UDim2.new(1, -30, 1, -180)
availableCodesFrame.Position = UDim2.new(0, 15, 0, 170)
availableCodesFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
availableCodesFrame.BorderSizePixel = 0
availableCodesFrame.ScrollBarThickness = 6
availableCodesFrame.Parent = codesGui

local availableCodesCorner = Instance.new("UICorner")
availableCodesCorner.CornerRadius = UDim.new(0, 10)
availableCodesCorner.Parent = availableCodesFrame

local codesLayout = Instance.new("UIListLayout")
codesLayout.Padding = UDim.new(0, 8)
codesLayout.Parent = availableCodesFrame

-- Populate available codes
for code, data in pairs(CodesDatabase) do
    local codeFrame = Instance.new("Frame")
    codeFrame.Size = UDim2.new(1, -10, 0, 50)
    codeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    codeFrame.BorderSizePixel = 0
    codeFrame.Parent = availableCodesFrame
    
    local codeFrameCorner = Instance.new("UICorner")
    codeFrameCorner.CornerRadius = UDim.new(0, 8)
    codeFrameCorner.Parent = codeFrame
    
    local codeNameLabel = Instance.new("TextLabel")
    codeNameLabel.Size = UDim2.new(0.6, 0, 1, 0)
    codeNameLabel.Position = UDim2.new(0, 10, 0, 0)
    codeNameLabel.BackgroundTransparency = 1
    codeNameLabel.Text = code
    codeNameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    codeNameLabel.TextScaled = true
    codeNameLabel.Font = Enum.Font.GothamBold
    codeNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    codeNameLabel.Parent = codeFrame
    
    local rewardLabel = Instance.new("TextLabel")
    rewardLabel.Size = UDim2.new(0.4, -10, 1, 0)
    rewardLabel.Position = UDim2.new(0.6, 0, 0, 0)
    rewardLabel.BackgroundTransparency = 1
    rewardLabel.Text = data.coins .. " 💰"
    rewardLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    rewardLabel.TextScaled = true
    rewardLabel.Font = Enum.Font.Gotham
    rewardLabel.TextXAlignment = Enum.TextXAlignment.Right
    rewardLabel.Parent = codeFrame
end

-- 📖 INDEX GUI (Hidden by default)
local indexGui = Instance.new("Frame")
indexGui.Name = "IndexGui"
indexGui.Size = UDim2.new(0, isMobile() and 350 or 500, 0, isMobile() and 450 or 600)
indexGui.Position = UDim2.new(0.5, isMobile() and -175 or -250, 0.5, isMobile() and -225 or -300)
indexGui.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
indexGui.BorderSizePixel = 0
indexGui.Visible = false
indexGui.Parent = screenGui

local indexGuiCorner = Instance.new("UICorner")
indexGuiCorner.CornerRadius = UDim.new(0, 15)
indexGuiCorner.Parent = indexGui

local indexGuiStroke = Instance.new("UIStroke")
indexGuiStroke.Color = Color3.fromRGB(150, 255, 150)
indexGuiStroke.Thickness = 3
indexGuiStroke.Parent = indexGui

-- Index Header
local indexHeader = Instance.new("Frame")
indexHeader.Size = UDim2.new(1, 0, 0, 50)
indexHeader.Position = UDim2.new(0, 0, 0, 0)
indexHeader.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
indexHeader.BorderSizePixel = 0
indexHeader.Parent = indexGui

local indexHeaderCorner = Instance.new("UICorner")
indexHeaderCorner.CornerRadius = UDim.new(0, 15)
indexHeaderCorner.Parent = indexHeader

local indexTitle = Instance.new("TextLabel")
indexTitle.Size = UDim2.new(1, -60, 1, 0)
indexTitle.Position = UDim2.new(0, 15, 0, 0)
indexTitle.BackgroundTransparency = 1
indexTitle.Text = "📖 GLITCH INDEX"
indexTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
indexTitle.TextScaled = true
indexTitle.Font = Enum.Font.GothamBold
indexTitle.TextXAlignment = Enum.TextXAlignment.Left
indexTitle.Parent = indexHeader

local indexCloseButton = Instance.new("ImageButton")
indexCloseButton.Size = UDim2.new(0, 35, 0, 35)
indexCloseButton.Position = UDim2.new(1, -45, 0.5, -17.5)
indexCloseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
indexCloseButton.BorderSizePixel = 0
indexCloseButton.Image = "rbxassetid://17368208589"
indexCloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
indexCloseButton.Parent = indexHeader

local indexCloseCorner = Instance.new("UICorner")
indexCloseCorner.CornerRadius = UDim.new(1, 0)
indexCloseCorner.Parent = indexCloseButton

-- Index Content
local indexScrollFrame = Instance.new("ScrollingFrame")
indexScrollFrame.Size = UDim2.new(1, -20, 1, -70)
indexScrollFrame.Position = UDim2.new(0, 10, 0, 60)
indexScrollFrame.BackgroundTransparency = 1
indexScrollFrame.ScrollBarThickness = 8
indexScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 255, 150)
indexScrollFrame.BorderSizePixel = 0
indexScrollFrame.Parent = indexGui

local indexLayout = Instance.new("UIListLayout")
indexLayout.Padding = UDim.new(0, 10)
indexLayout.Parent = indexScrollFrame

-- Populate glitch index
for i, glitch in ipairs(GlitchDatabase) do
    local glitchEntry = Instance.new("Frame")
    glitchEntry.Size = UDim2.new(1, -20, 0, isMobile() and 80 or 100)
    glitchEntry.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    glitchEntry.BorderSizePixel = 0
    glitchEntry.Parent = indexScrollFrame
    
    local glitchEntryCorner = Instance.new("UICorner")
    glitchEntryCorner.CornerRadius = UDim.new(0, 10)
    glitchEntryCorner.Parent = glitchEntry
    
    local glitchEntryStroke = Instance.new("UIStroke")
    glitchEntryStroke.Color = glitch.color
    glitchEntryStroke.Thickness = 2
    glitchEntryStroke.Parent = glitchEntry
    
    -- Glitch Icon
    local glitchIcon = Instance.new("ImageLabel")
    glitchIcon.Size = UDim2.new(0, isMobile() and 60 or 80, 0, isMobile() and 60 or 80)
    glitchIcon.Position = UDim2.new(0, 10, 0.5, isMobile() and -30 or -40)
    glitchIcon.BackgroundColor3 = glitch.color
    glitchIcon.BorderSizePixel = 0
    glitchIcon.Image = glitch.icon
    glitchIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    glitchIcon.Parent = glitchEntry
    
    local glitchIconCorner = Instance.new("UICorner")
    glitchIconCorner.CornerRadius = UDim.new(0, 10)
    glitchIconCorner.Parent = glitchIcon
    
    -- Glitch Info
    local glitchName = Instance.new("TextLabel")
    glitchName.Size = UDim2.new(1, isMobile() and -80 or -100, 0, 25)
    glitchName.Position = UDim2.new(0, isMobile() and 80 or 100, 0, 10)
    glitchName.BackgroundTransparency = 1
    glitchName.Text = glitch.name
    glitchName.TextColor3 = Color3.fromRGB(255, 255, 255)
    glitchName.TextScaled = true
    glitchName.Font = Enum.Font.GothamBold
    glitchName.TextXAlignment = Enum.TextXAlignment.Left
    glitchName.Parent = glitchEntry
    
    local glitchRarity = Instance.new("TextLabel")
    glitchRarity.Size = UDim2.new(1, isMobile() and -80 or -100, 0, 20)
    glitchRarity.Position = UDim2.new(0, isMobile() and 80 or 100, 0, 35)
    glitchRarity.BackgroundTransparency = 1
    glitchRarity.Text = string.format("%s (%d%%)", glitch.rarity, glitch.chance)
    glitchRarity.TextColor3 = glitch.color
    glitchRarity.TextScaled = true
    glitchRarity.Font = Enum.Font.Gotham
    glitchRarity.TextXAlignment = Enum.TextXAlignment.Left
    glitchRarity.Parent = glitchEntry
    
    local glitchBonus = Instance.new("TextLabel")
    glitchBonus.Size = UDim2.new(1, isMobile() and -80 or -100, 0, 15)
    glitchBonus.Position = UDim2.new(0, isMobile() and 80 or 100, 0, isMobile() and 55 or 65)
    glitchBonus.BackgroundTransparency = 1
    glitchBonus.Text = string.format("%.1fx Coin Multiplier", glitch.coinBonus)
    glitchBonus.TextColor3 = Color3.fromRGB(255, 215, 0)
    glitchBonus.TextScaled = true
    glitchBonus.Font = Enum.Font.Gotham
    glitchBonus.TextXAlignment = Enum.TextXAlignment.Left
    glitchBonus.Parent = glitchEntry
end

-- 🔔 NOTIFICATION SYSTEM
local function showNotification(message, color, duration)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, isMobile() and 250 or 300, 0, isMobile() and 50 or 60)
    notification.Position = UDim2.new(0.5, isMobile() and -125 or -150, 0, -80)
    notification.BackgroundColor3 = color or Color3.fromRGB(50, 50, 70)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 12)
    notificationCorner.Parent = notification
    
    local notificationStroke = Instance.new("UIStroke")
    notificationStroke.Color = Color3.fromRGB(255, 255, 255)
    notificationStroke.Thickness = 2
    notificationStroke.Parent = notification
    
    local notificationText = Instance.new("TextLabel")
    notificationText.Size = UDim2.new(1, -20, 1, 0)
    notificationText.Position = UDim2.new(0, 10, 0, 0)
    notificationText.BackgroundTransparency = 1
    notificationText.Text = message
    notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notificationText.TextScaled = true
    notificationText.Font = Enum.Font.Gotham
    notificationText.Parent = notification
    
    -- Animate in
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, isMobile() and -125 or -150, 0, 20)
    })
    tweenIn:Play()
    
    -- Auto remove
    spawn(function()
        task.wait(duration or 3)
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, isMobile() and -125 or -150, 0, -80),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- 🎮 GAME FUNCTIONS
local function updateCoins()
    local tween = TweenService:Create(coinLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        TextColor3 = Color3.fromRGB(255, 215, 0)
    })
    tween:Play()
    coinLabel.Text = tostring(GameData.coins)
    task.wait(0.2)
    TweenService:Create(coinLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end

local function addGlitchToInventory(glitch)
    table.insert(GameData.glitches, glitch)
    GameData.coinMultiplier = math.max(GameData.coinMultiplier, glitch.coinBonus)
    
    -- Create glitch slot
    local glitchSlot = Instance.new("Frame")
    glitchSlot.Size = UDim2.new(0, isMobile() and 70 or 90, 0, isMobile() and 70 or 90)
    glitchSlot.BackgroundColor3 = glitch.color
    glitchSlot.BorderSizePixel = 0
    glitchSlot.Parent = glitchScrollFrame
    
    local slotCorner = Instance.new("UICorner")
    slotCorner.CornerRadius = UDim.new(0, 10)
    slotCorner.Parent = glitchSlot
    
    local slotStroke = Instance.new("UIStroke")
    slotStroke.Color = Color3.fromRGB(255, 255, 255)
    slotStroke.Thickness = 2
    slotStroke.Parent = glitchSlot
    
    local glitchIcon = Instance.new("ImageLabel")
    glitchIcon.Size = UDim2.new(0.8, 0, 0.8, 0)
    glitchIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
    glitchIcon.BackgroundTransparency = 1
    glitchIcon.Image = glitch.icon
    glitchIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    glitchIcon.Parent = glitchSlot
    
    -- Update canvas size
    glitchScrollFrame.CanvasSize = UDim2.new(0, 0, 0, math.ceil(#GameData.glitches / (isMobile() and 4 or 5)) * (isMobile() and 78 or 98))
    
    showNotification(string.format("🎉 %s %s obtained!", glitch.rarity, glitch.name), glitch.color, 4)
end

local function rollForGlitch()
    local rollCost = 100
    
    if GameData.coins < rollCost then
        showNotification("❌ Not enough coins to roll!", Color3.fromRGB(255, 100, 100), 3)
        return
    end
    
    GameData.coins = GameData.coins - rollCost
    updateCoins()
    
    -- Play roll sound
    if GameData.settings.soundEnabled then
        Sounds.roll:Play()
    end
    
    -- Animate roll button
    local rollAnimation = TweenService:Create(rollButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
        Size = rollButton.Size - UDim2.new(0, 10, 0, 10)
    })
    rollAnimation:Play()
    rollAnimation.Completed:Connect(function()
        TweenService:Create(rollButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = rollButton.Size + UDim2.new(0, 10, 0, 10)
        }):Play()
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
        task.wait(0.3) -- Suspense
        
        if GameData.settings.soundEnabled then
            if rolledGlitch.rarity == "Mythic" or rolledGlitch.rarity == "Legendary" then
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
        GameData.usedCodes[code] = true
        
        updateCoins()
        
        if GameData.settings.soundEnabled then
            Sounds.coin:Play()
        end
        
        showNotification(string.format("✅ Code redeemed! +%d coins", codeData.coins), Color3.fromRGB(100, 255, 100), 4)
        codeInput.Text = ""
    else
        showNotification("❌ Invalid or already used code!", Color3.fromRGB(255, 100, 100), 3)
        codeInput.Text = ""
    end
end

-- 🔄 PASSIVE COIN GENERATION
spawn(function()
    while true do
        task.wait(1)
        local coinsToAdd = math.floor(10 * GameData.coinMultiplier)
        GameData.coins = GameData.coins + coinsToAdd
        updateCoins()
    end
end)

-- 🎯 BUTTON HOVER EFFECTS
local function addHoverEffect(button, hoverColor, normalColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = normalColor}):Play()
    end)
end

addHoverEffect(rollButton, Color3.fromRGB(70, 70, 90), Color3.fromRGB(50, 50, 70))
addHoverEffect(inventoryButton, Color3.fromRGB(60, 60, 80), Color3.fromRGB(40, 40, 60))
addHoverEffect(codesButton, Color3.fromRGB(60, 60, 80), Color3.fromRGB(40, 40, 60))
addHoverEffect(indexButton, Color3.fromRGB(60, 60, 80), Color3.fromRGB(40, 40, 60))
addHoverEffect(redeemButton, Color3.fromRGB(120, 255, 120), Color3.fromRGB(100, 255, 100))

-- 🎯 EVENT CONNECTIONS
rollButton.MouseButton1Click:Connect(rollForGlitch)
redeemButton.MouseButton1Click:Connect(redeemCode)

-- Navigation buttons
inventoryButton.MouseButton1Click:Connect(function()
    inventoryGui.Visible = true
    if GameData.settings.soundEnabled then
        Sounds.ui:Play()
    end
end)

codesButton.MouseButton1Click:Connect(function()
    codesGui.Visible = true
    if GameData.settings.soundEnabled then
        Sounds.ui:Play()
    end
end)

indexButton.MouseButton1Click:Connect(function()
    indexGui.Visible = true
    if GameData.settings.soundEnabled then
        Sounds.ui:Play()
    end
end)

-- Close buttons
inventoryCloseButton.MouseButton1Click:Connect(function()
    inventoryGui.Visible = false
end)

codesCloseButton.MouseButton1Click:Connect(function()
    codesGui.Visible = false
end)

indexCloseButton.MouseButton1Click:Connect(function()
    indexGui.Visible = false
end)

-- Code input enter key support
codeInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        redeemCode()
    end
end)

-- 🚀 INITIALIZATION
updateCoins()

-- Welcome sequence
spawn(function()
    task.wait(1)
    showNotification("🎮 Welcome to Glitch Aura!", Color3.fromRGB(100, 150, 255), 4)
    task.wait(2)
    showNotification("🎲 Roll for glitches to earn coins faster!", Color3.fromRGB(150, 255, 150), 3)
end)