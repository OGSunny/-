-- Roblox Glitch Aura Game System
-- Place this in StarterPlayerScripts as a LocalScript

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- Player References
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Game Data
local gameData = {
    coins = 500, -- Starting coins
    glitches = {},
    potions = {}, -- Currently unused, but good for future expansion
    hasGlitch = false,
    coinMultiplier = 1,
    usedCodes = {} -- Track used codes per player
}

-- Glitch Database
-- Defines all possible glitches, their properties, and drop chances.
local glitchDatabase = {
    {name = "Shadow Glitch", rarity = "Common", chance = 40, coinBonus = 1.2, color = Color3.fromRGB(50, 50, 50), icon = "🌑"},
    {name = "Neon Glitch", rarity = "Uncommon", chance = 25, coinBonus = 1.5, color = Color3.fromRGB(0, 255, 255), icon = "⚡"},
    {name = "Fire Glitch", rarity = "Rare", chance = 20, coinBonus = 2.0, color = Color3.fromRGB(255, 100, 0), icon = "🔥"},
    {name = "Rainbow Glitch", rarity = "Epic", chance = 10, coinBonus = 3.0, color = Color3.fromRGB(255, 0, 255), icon = "🌈"},
    {name = "Void Glitch", rarity = "Legendary", chance = 4, coinBonus = 5.0, color = Color3.fromRGB(100, 0, 200), icon = "🕳️"},
    {name = "Cosmic Glitch", rarity = "Mythic", chance = 1, coinBonus = 10.0, color = Color3.fromRGB(255, 215, 0), icon = "✨"}
}

-- Codes Database
-- Stores redeemable codes and their associated rewards.
local codesDatabase = {
    ["FREEGEMS"] = {coins = 1000, active = true},
    ["GLITCH2024"] = {coins = 500, active = true},
    ["LUCKY"] = {coins = 750, active = true},
    ["NEWBIE"] = {coins = 300, active = true},
    ["WELCOME"] = {coins = 200, active = true}
}

-- Sound Effects
local rollSound = Instance.new("Sound")
rollSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
rollSound.Volume = 0.5
rollSound.Parent = SoundService

local coinSound = Instance.new("Sound")
coinSound.SoundId = "rbxasset://sounds/impact_generic.mp3"
coinSound.Volume = 0.3
coinSound.Parent = SoundService

local successSound = Instance.new("Sound")
successSound.SoundId = "rbxasset://sounds/action_get_up.mp3"
successSound.Volume = 0.4
successSound.Parent = SoundService

-- UI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GlitchAuraGame"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main UI Frame with gradient background
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 15, 35))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Coin Display Frame
local coinFrame = Instance.new("Frame")
coinFrame.Size = UDim2.new(0, 220, 0, 60)
coinFrame.Position = UDim2.new(0, 20, 0, 20)
coinFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
coinFrame.BorderSizePixel = 0
coinFrame.Parent = screenGui

local coinFrameCorner = Instance.new("UICorner")
coinFrameCorner.CornerRadius = UDim.new(0, 12)
coinFrameCorner.Parent = coinFrame

local coinFrameStroke = Instance.new("UIStroke")
coinFrameStroke.Color = Color3.fromRGB(255, 215, 0)
coinFrameStroke.Thickness = 2
coinFrameStroke.Parent = coinFrame

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
coinLabel.Position = UDim2.new(0, 60, 0, 0)
coinLabel.BackgroundTransparency = 1
coinLabel.Text = tostring(gameData.coins)
coinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coinLabel.TextScaled = true
coinLabel.Font = Enum.Font.GothamBold
coinLabel.Parent = coinFrame

-- Roll Button
local rollButton = Instance.new("TextButton")
rollButton.Size = UDim2.new(0, 100, 0, 100)
rollButton.Position = UDim2.new(0.5, -50, 1, -120)
rollButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
rollButton.BorderSizePixel = 0
rollButton.Text = "🎲"
rollButton.TextScaled = true
rollButton.Font = Enum.Font.GothamBold
rollButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rollButton.Parent = screenGui

local rollButtonCorner = Instance.new("UICorner")
rollButtonCorner.CornerRadius = UDim.new(0.5, 0)
rollButtonCorner.Parent = rollButton

local rollButtonStroke = Instance.new("UIStroke")
rollButtonStroke.Color = Color3.fromRGB(100, 255, 100)
rollButtonStroke.Thickness = 3
rollButtonStroke.Parent = rollButton

local rollCostLabel = Instance.new("TextLabel")
rollCostLabel.Size = UDim2.new(1, 0, 0, 25)
rollCostLabel.Position = UDim2.new(0, 0, 1, 5)
rollCostLabel.BackgroundTransparency = 1
rollCostLabel.Text = "100 Coins"
rollCostLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
rollCostLabel.TextScaled = true
rollCostLabel.Font = Enum.Font.Gotham
rollCostLabel.Parent = rollButton

-- Side Menu Buttons
local buttonSize = UDim2.new(0, 70, 0, 70)
local buttonSpacing = 80

local inventoryButton = Instance.new("TextButton")
inventoryButton.Size = buttonSize
inventoryButton.Position = UDim2.new(0, 20, 0.5, -35)
inventoryButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
inventoryButton.BorderSizePixel = 0
inventoryButton.Text = "🎒"
inventoryButton.TextScaled = true
inventoryButton.Font = Enum.Font.GothamBold
inventoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
inventoryButton.Parent = screenGui

local inventoryCorner = Instance.new("UICorner")
inventoryCorner.CornerRadius = UDim.new(0, 12)
inventoryCorner.Parent = inventoryButton

local codesButton = Instance.new("TextButton")
codesButton.Size = buttonSize
codesButton.Position = UDim2.new(0, 20, 0.5, -35 + buttonSpacing)
codesButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
codesButton.BorderSizePixel = 0
codesButton.Text = "🎫"
codesButton.TextScaled = true
codesButton.Font = Enum.Font.GothamBold
codesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
codesButton.Parent = screenGui

local codesCorner = Instance.new("UICorner")
codesCorner.CornerRadius = UDim.new(0, 12)
codesCorner.Parent = codesButton

local indexButton = Instance.new("TextButton")
indexButton.Size = buttonSize
indexButton.Position = UDim2.new(0, 20, 0.5, -35 + buttonSpacing * 2)
indexButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
indexButton.BorderSizePixel = 0
indexButton.Text = "📖"
indexButton.TextScaled = true
indexButton.Font = Enum.Font.GothamBold
indexButton.TextColor3 = Color3.fromRGB(255, 255, 255)
indexButton.Parent = screenGui

local indexCorner = Instance.new("UICorner")
indexCorner.CornerRadius = UDim.new(0, 12)
indexCorner.Parent = indexButton

-- Inventory GUI
local inventoryGui = Instance.new("Frame")
inventoryGui.Size = UDim2.new(0, 450, 0, 550)
inventoryGui.Position = UDim2.new(0.5, -225, 0.5, -275)
inventoryGui.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
inventoryGui.BorderSizePixel = 0
inventoryGui.Visible = false
inventoryGui.Parent = screenGui

local inventoryCornerGui = Instance.new("UICorner")
inventoryCornerGui.CornerRadius = UDim.new(0, 15)
inventoryCornerGui.Parent = inventoryGui

local inventoryStroke = Instance.new("UIStroke")
inventoryStroke.Color = Color3.fromRGB(70, 70, 90)
inventoryStroke.Thickness = 2
inventoryStroke.Parent = inventoryGui

local inventoryTitle = Instance.new("TextLabel")
inventoryTitle.Size = UDim2.new(1, -60, 0, 50)
inventoryTitle.Position = UDim2.new(0, 0, 0, 0)
inventoryTitle.BackgroundTransparency = 1
inventoryTitle.Text = "🎒 INVENTORY"
inventoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
inventoryTitle.TextScaled = true
inventoryTitle.Font = Enum.Font.GothamBold
inventoryTitle.Parent = inventoryGui

local closeInventory = Instance.new("TextButton")
closeInventory.Size = UDim2.new(0, 40, 0, 40)
closeInventory.Position = UDim2.new(1, -50, 0, 5)
closeInventory.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeInventory.BorderSizePixel = 0
closeInventory.Text = "❌"
closeInventory.TextScaled = true
closeInventory.Font = Enum.Font.GothamBold
closeInventory.TextColor3 = Color3.fromRGB(255, 255, 255)
closeInventory.Parent = inventoryGui

local closeInventoryCorner = Instance.new("UICorner")
closeInventoryCorner.CornerRadius = UDim.new(0, 8)
closeInventoryCorner.Parent = closeInventory

local glitchFrame = Instance.new("Frame")
glitchFrame.Size = UDim2.new(1, -20, 0.5, -30)
glitchFrame.Position = UDim2.new(0, 10, 0, 60)
glitchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
glitchFrame.BorderSizePixel = 0
glitchFrame.Parent = inventoryGui

local glitchFrameCorner = Instance.new("UICorner")
glitchFrameCorner.CornerRadius = UDim.new(0, 10)
glitchFrameCorner.Parent = glitchFrame

local glitchTitle = Instance.new("TextLabel")
glitchTitle.Size = UDim2.new(1, 0, 0, 35)
glitchTitle.Position = UDim2.new(0, 0, 0, 0)
glitchTitle.BackgroundTransparency = 1
glitchTitle.Text = "✨ GLITCHES"
glitchTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
glitchTitle.TextScaled = true
glitchTitle.Font = Enum.Font.Gotham
glitchTitle.Parent = glitchFrame

local glitchScrollFrame = Instance.new("ScrollingFrame")
glitchScrollFrame.Size = UDim2.new(1, -10, 1, -45)
glitchScrollFrame.Position = UDim2.new(0, 5, 0, 40)
glitchScrollFrame.BackgroundTransparency = 1
glitchScrollFrame.ScrollBarThickness = 8
glitchScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
glitchScrollFrame.Parent = glitchFrame

local glitchGrid = Instance.new("UIGridLayout")
glitchGrid.CellSize = UDim2.new(0, 70, 0, 70)
glitchGrid.CellPadding = UDim2.new(0, 8, 0, 8)
glitchGrid.Parent = glitchScrollFrame

local potionFrame = Instance.new("Frame")
potionFrame.Size = UDim2.new(1, -20, 0.5, -30)
potionFrame.Position = UDim2.new(0, 10, 0.5, 10)
potionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
potionFrame.BorderSizePixel = 0
potionFrame.Parent = inventoryGui

local potionFrameCorner = Instance.new("UICorner")
potionFrameCorner.CornerRadius = UDim.new(0, 10)
potionFrameCorner.Parent = potionFrame

local potionTitle = Instance.new("TextLabel")
potionTitle.Size = UDim2.new(1, 0, 0, 35)
potionTitle.Position = UDim2.new(0, 0, 0, 0)
potionTitle.BackgroundTransparency = 1
potionTitle.Text = "🧪 POTIONS (Coming Soon!)"
potionTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
potionTitle.TextScaled = true
potionTitle.Font = Enum.Font.Gotham
potionTitle.Parent = potionFrame

-- Codes GUI
local codesGui = Instance.new("Frame")
codesGui.Size = UDim2.new(0, 400, 0, 450)
codesGui.Position = UDim2.new(0.5, -200, 0.5, -225)
codesGui.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
codesGui.BorderSizePixel = 0
codesGui.Visible = false
codesGui.Parent = screenGui

local codesCornerGui = Instance.new("UICorner")
codesCornerGui.CornerRadius = UDim.new(0, 15)
codesCornerGui.Parent = codesGui

local codesStroke = Instance.new("UIStroke")
codesStroke.Color = Color3.fromRGB(70, 70, 90)
codesStroke.Thickness = 2
codesStroke.Parent = codesGui

local codesTitle = Instance.new("TextLabel")
codesTitle.Size = UDim2.new(1, -60, 0, 50)
codesTitle.Position = UDim2.new(0, 0, 0, 0)
codesTitle.BackgroundTransparency = 1
codesTitle.Text = "🎫 CODES"
codesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
codesTitle.TextScaled = true
codesTitle.Font = Enum.Font.GothamBold
codesTitle.Parent = codesGui

local closeCodes = Instance.new("TextButton")
closeCodes.Size = UDim2.new(0, 40, 0, 40)
closeCodes.Position = UDim2.new(1, -50, 0, 5)
closeCodes.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeCodes.BorderSizePixel = 0
closeCodes.Text = "❌"
closeCodes.TextScaled = true
closeCodes.Font = Enum.Font.GothamBold
closeCodes.TextColor3 = Color3.fromRGB(255, 255, 255)
closeCodes.Parent = codesGui

local closeCodesCorner = Instance.new("UICorner")
closeCodesCorner.CornerRadius = UDim.new(0, 8)
closeCodesCorner.Parent = closeCodes

local codeInput = Instance.new("TextBox")
codeInput.Size = UDim2.new(1, -20, 0, 50)
codeInput.Position = UDim2.new(0, 10, 0, 60)
codeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
codeInput.BorderSizePixel = 0
codeInput.Text = ""
codeInput.PlaceholderText = "Enter Code Here..."
codeInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
codeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
codeInput.TextScaled = true
codeInput.Font = Enum.Font.Gotham
codeInput.Parent = codesGui

local codeInputCorner = Instance.new("UICorner")
codeInputCorner.CornerRadius = UDim.new(0, 10)
codeInputCorner.Parent = codeInput

local redeemButton = Instance.new("TextButton")
redeemButton.Size = UDim2.new(1, -20, 0, 50)
redeemButton.Position = UDim2.new(0, 10, 0, 120)
redeemButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
redeemButton.BorderSizePixel = 0
redeemButton.Text = "🎁 REDEEM CODE"
redeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
redeemButton.TextScaled = true
redeemButton.Font = Enum.Font.GothamBold
redeemButton.Parent = codesGui

local redeemCorner = Instance.new("UICorner")
redeemCorner.CornerRadius = UDim.new(0, 10)
redeemCorner.Parent = redeemButton

-- Available codes display
local availableCodesFrame = Instance.new("Frame")
availableCodesFrame.Size = UDim2.new(1, -20, 1, -190)
availableCodesFrame.Position = UDim2.new(0, 10, 0, 180)
availableCodesFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
availableCodesFrame.BorderSizePixel = 0
availableCodesFrame.Parent = codesGui

local availableCodesCorner = Instance.new("UICorner")
availableCodesCorner.CornerRadius = UDim.new(0, 10)
availableCodesCorner.Parent = availableCodesFrame

local availableCodesTitle = Instance.new("TextLabel")
availableCodesTitle.Size = UDim2.new(1, 0, 0, 30)
availableCodesTitle.Position = UDim2.new(0, 0, 0, 0)
availableCodesTitle.BackgroundTransparency = 1
availableCodesTitle.Text = "Available Codes:"
availableCodesTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
availableCodesTitle.TextScaled = true
availableCodesTitle.Font = Enum.Font.Gotham
availableCodesTitle.Parent = availableCodesFrame

local codesList = Instance.new("TextLabel")
codesList.Size = UDim2.new(1, -10, 1, -40)
codesList.Position = UDim2.new(0, 5, 0, 35)
codesList.BackgroundTransparency = 1
codesList.Text = "FREEGEMS (1000 coins)\nGLITCH2024 (500 coins)\nLUCKY (750 coins)\nNEWBIE (300 coins)\nWELCOME (200 coins)"
codesList.TextColor3 = Color3.fromRGB(150, 255, 150)
codesList.TextScaled = false
codesList.TextSize = 14
codesList.Font = Enum.Font.Gotham
codesList.TextYAlignment = Enum.TextYAlignment.Top
codesList.Parent = availableCodesFrame

-- Index GUI
local indexGui = Instance.new("Frame")
indexGui.Size = UDim2.new(0, 550, 0, 650)
indexGui.Position = UDim2.new(0.5, -275, 0.5, -325)
indexGui.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
indexGui.BorderSizePixel = 0
indexGui.Visible = false
indexGui.Parent = screenGui

local indexCornerGui = Instance.new("UICorner")
indexCornerGui.CornerRadius = UDim.new(0, 15)
indexCornerGui.Parent = indexGui

local indexStroke = Instance.new("UIStroke")
indexStroke.Color = Color3.fromRGB(70, 70, 90)
indexStroke.Thickness = 2
indexStroke.Parent = indexGui

local indexTitle = Instance.new("TextLabel")
indexTitle.Size = UDim2.new(1, -60, 0, 50)
indexTitle.Position = UDim2.new(0, 0, 0, 0)
indexTitle.BackgroundTransparency = 1
indexTitle.Text = "📖 GLITCH INDEX"
indexTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
indexTitle.TextScaled = true
indexTitle.Font = Enum.Font.GothamBold
indexTitle.Parent = indexGui

local closeIndex = Instance.new("TextButton")
closeIndex.Size = UDim2.new(0, 40, 0, 40)
closeIndex.Position = UDim2.new(1, -50, 0, 5)
closeIndex.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeIndex.BorderSizePixel = 0
closeIndex.Text = "❌"
closeIndex.TextScaled = true
closeIndex.Font = Enum.Font.GothamBold
closeIndex.TextColor3 = Color3.fromRGB(255, 255, 255)
closeIndex.Parent = indexGui

local closeIndexCorner = Instance.new("UICorner")
closeIndexCorner.CornerRadius = UDim.new(0, 8)
closeIndexCorner.Parent = closeIndex

local indexScrollFrame = Instance.new("ScrollingFrame")
indexScrollFrame.Size = UDim2.new(1, -20, 1, -70)
indexScrollFrame.Position = UDim2.new(0, 10, 0, 60)
indexScrollFrame.BackgroundTransparency = 1
indexScrollFrame.ScrollBarThickness = 10
indexScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
indexScrollFrame.Parent = indexGui

local indexList = Instance.new("UIListLayout")
indexList.Padding = UDim.new(0, 12)
indexList.Parent = indexScrollFrame

-- Populate Glitch Index dynamically
for i, glitch in ipairs(glitchDatabase) do
    local glitchEntry = Instance.new("Frame")
    glitchEntry.Size = UDim2.new(1, -20, 0, 90)
    glitchEntry.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    glitchEntry.BorderSizePixel = 0
    glitchEntry.Parent = indexScrollFrame
    
    local glitchEntryCorner = Instance.new("UICorner")
    glitchEntryCorner.CornerRadius = UDim.new(0, 10)
    glitchEntryCorner.Parent = glitchEntry
    
    local glitchEntryStroke = Instance.new("UIStroke")
    glitchEntryStroke.Color = glitch.color
    glitchEntryStroke.Thickness = 2
    glitchEntryStroke.Parent = glitchEntry
    
    local glitchIcon = Instance.new("Frame")
    glitchIcon.Size = UDim2.new(0, 70, 0, 70)
    glitchIcon.Position = UDim2.new(0, 10, 0, 10)
    glitchIcon.BackgroundColor3 = glitch.color
    glitchIcon.BorderSizePixel = 0
    glitchIcon.Parent = glitchEntry
    
    local glitchIconCorner = Instance.new("UICorner")
    glitchIconCorner.CornerRadius = UDim.new(0, 10)
    glitchIconCorner.Parent = glitchIcon
    
    local glitchIconText = Instance.new("TextLabel")
    glitchIconText.Size = UDim2.new(1, 0, 1, 0)
    glitchIconText.BackgroundTransparency = 1
    glitchIconText.Text = glitch.icon
    glitchIconText.TextScaled = true
    glitchIconText.Font = Enum.Font.GothamBold
    glitchIconText.Parent = glitchIcon
    
    local glitchName = Instance.new("TextLabel")
    glitchName.Size = UDim2.new(1, -100, 0, 35)
    glitchName.Position = UDim2.new(0, 90, 0, 10)
    glitchName.BackgroundTransparency = 1
    glitchName.Text = glitch.name
    glitchName.TextColor3 = Color3.fromRGB(255, 255, 255)
    glitchName.TextScaled = true
    glitchName.Font = Enum.Font.GothamBold
    glitchName.TextXAlignment = Enum.TextXAlignment.Left
    glitchName.Parent = glitchEntry
    
    local glitchRarity = Instance.new("TextLabel")
    glitchRarity.Size = UDim2.new(1, -100, 0, 25)
    glitchRarity.Position = UDim2.new(0, 90, 0, 45)
    glitchRarity.BackgroundTransparency = 1
    glitchRarity.Text = string.format("%s (%d%% chance)", glitch.rarity, glitch.chance)
    glitchRarity.TextColor3 = glitch.color
    glitchRarity.TextScaled = true
    glitchRarity.Font = Enum.Font.Gotham
    glitchRarity.TextXAlignment = Enum.TextXAlignment.Left
    glitchRarity.Parent = glitchEntry
    
    local coinBonus = Instance.new("TextLabel")
    coinBonus.Size = UDim2.new(1, -100, 0, 20)
    coinBonus.Position = UDim2.new(0, 90, 0, 65)
    coinBonus.BackgroundTransparency = 1
    coinBonus.Text = string.format("Coin Bonus: %.1fx", glitch.coinBonus)
    coinBonus.TextColor3 = Color3.fromRGB(255, 215, 0)
    coinBonus.TextScaled = true
    coinBonus.Font = Enum.Font.Gotham
    coinBonus.TextXAlignment = Enum.TextXAlignment.Left
    coinBonus.Parent = glitchEntry
end

-- Adjust CanvasSize for the Index ScrollFrame after populating
indexScrollFrame.CanvasSize = UDim2.new(0, 0, 0, indexList.AbsoluteContentSize.Y + 20)

-- Notification System
local function showNotification(message, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(0.5, -150, 0, -70)
    notification.BackgroundColor3 = color or Color3.fromRGB(50, 50, 60)
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 10)
    notificationCorner.Parent = notification
    
    local notificationText = Instance.new("TextLabel")
    notificationText.Size = UDim2.new(1, -20, 1, 0)
    notificationText.Position = UDim2.new(0, 10, 0, 0)
    notificationText.BackgroundTransparency = 1
    notificationText.Text = message
    notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notificationText.TextScaled = true
    notificationText.Font = Enum.Font.Gotham
    notificationText.Parent = notification
    
    -- Animate notification
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0, 20)})
    tweenIn:Play()
    
    -- Auto-remove notification
    task.wait(3)
    local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -150, 0, -70)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        notification:Destroy()
    end)
end

-- Game Functions
local function updateCoins()
    -- Updates the coin display on the UI with animation.
    local tween = TweenService:Create(coinLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 215, 0)})
    tween:Play()
    coinLabel.Text = tostring(gameData.coins)
    task.wait(0.2)
    TweenService:Create(coinLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end

local function addGlitch(glitch)
    -- Adds a new glitch to the player's inventory and updates game stats.
    table.insert(gameData.glitches, glitch)
    gameData.hasGlitch = true
    gameData.coinMultiplier = math.max(gameData.coinMultiplier, glitch.coinBonus) -- Ensure multiplier is highest
    
    -- Create glitch slot in inventory UI
    local glitchSlot = Instance.new("Frame")
    glitchSlot.Size = UDim2.new(0, 70, 0, 70)
    glitchSlot.BackgroundColor3 = glitch.color
    glitchSlot.BorderSizePixel = 0
    glitchSlot.Parent = glitchScrollFrame
    
    local glitchSlotCorner = Instance.new("UICorner")
    glitchSlotCorner.CornerRadius = UDim.new(0, 10)
    glitchSlotCorner.Parent = glitchSlot
    
    local glitchSlotStroke = Instance.new("UIStroke")
    glitchSlotStroke.Color = Color3.fromRGB(255, 255, 255)
    glitchSlotStroke.Thickness = 2
    glitchSlotStroke.Parent = glitchSlot
    
    local glitchLabel = Instance.new("TextLabel")
    glitchLabel.Size = UDim2.new(1, 0, 1, 0)
    glitchLabel.BackgroundTransparency = 1
    glitchLabel.Text = glitch.icon
    glitchLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    glitchLabel.TextScaled = true
    glitchLabel.Font = Enum.Font.GothamBold
    glitchLabel.Parent = glitchSlot
    
    -- Tooltip on hover
    local tooltip = Instance.new("TextLabel")
    tooltip.Size = UDim2.new(0, 150, 0, 40)
    tooltip.Position = UDim2.new(0, 80, 0, 15)
    tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    tooltip.BorderSizePixel = 0
    tooltip.Text = glitch.name .. "\n" .. glitch.rarity
    tooltip.TextColor3 = glitch.color
    tooltip.TextScaled = true
    tooltip.Font = Enum.Font.Gotham
    tooltip.Visible = false
    tooltip.Parent = glitchSlot
    
    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 5)
    tooltipCorner.Parent = tooltip
    
    glitchSlot.MouseEnter:Connect(function()
        tooltip.Visible = true
    end)
    
    glitchSlot.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)
    
    -- Adjust CanvasSize for the Inventory Glitch ScrollFrame
    glitchScrollFrame.CanvasSize = UDim2.new(0, 0, 0, math.ceil(#gameData.glitches / 5) * 78)
    
    -- Show notification
    spawn(function()
        showNotification("New " .. glitch.rarity .. " Glitch: " .. glitch.name, glitch.color)
    end)
end

local function rollGlitch()
    -- Handles the logic for rolling a new glitch.
    local rollCost = 100
    if gameData.coins < rollCost then
        spawn(function()
            showNotification("Not enough coins to roll!", Color3.fromRGB(200, 50, 50))
        end)
        return -- Exit if not enough coins
    end
    
    gameData.coins = gameData.coins - rollCost
    updateCoins()
    
    -- Play roll sound
    rollSound:Play()
    
    -- Animate roll button
    local tween1 = TweenService:Create(rollButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 90, 0, 90)})
    tween1:Play()
    tween1.Completed:Wait()
    local tween2 = TweenService:Create(rollButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 100, 0, 100)})
    tween2:Play()
    
    -- Determine which glitch is rolled based on chances
    local roll = math.random(1, 100)
    local cumulativeChance = 0
    local rolledGlitch = nil
    
    for _, glitch in ipairs(glitchDatabase) do
        cumulativeChance = cumulativeChance + glitch.chance
        if roll <= cumulativeChance then
            rolledGlitch = glitch
            break
        end
    end

    if rolledGlitch then
        successSound:Play()
        addGlitch(rolledGlitch)
    else
        warn("No glitch rolled. Check glitch chances!") -- Should ideally not happen with valid chances
    end
end

local isRedeeming = false -- Flag to prevent spamming the redeem button

local function redeemCode()
    -- Processes entered codes for rewards.
    if isRedeeming then return end -- Prevent multiple redemptions at once
    isRedeeming = true

    local code = string.upper(codeInput.Text:gsub("%s", "")) -- Get text and remove spaces, make uppercase
    local codeInfo = codesDatabase[code]

    if codeInfo and codeInfo.active and not gameData.usedCodes[code] then
        gameData.coins = gameData.coins + codeInfo.coins
        gameData.usedCodes[code] = true -- Mark code as used for this player
        updateCoins()
        coinSound:Play()
        codeInput.Text = ""
        spawn(function()
            showNotification("Code redeemed! +" .. codeInfo.coins .. " coins", Color3.fromRGB(0, 200, 0))
        end)
    else
        spawn(function()
            showNotification("Invalid or already used code!", Color3.fromRGB(200, 50, 50))
        end)
        codeInput.Text = ""
    end
    
    -- Reset flag after a delay
    task.wait(1)
    isRedeeming = false
end

-- Coin Generation Loop with visual feedback
spawn(function()
    while true do
        task.wait(1) -- Use task.wait for more robust waiting
        local coinsToAdd = math.floor(10 * gameData.coinMultiplier)
        gameData.coins = gameData.coins + coinsToAdd
        updateCoins()
        
        -- Show floating coin animation occasionally
        if math.random(1, 5) == 1 then
            local floatingCoin = Instance.new("TextLabel")
            floatingCoin.Size = UDim2.new(0, 30, 0, 30)
            floatingCoin.Position = UDim2.new(0, math.random(100, 300), 1, -50)
            floatingCoin.BackgroundTransparency = 1
            floatingCoin.Text = "💰"
            floatingCoin.TextScaled = true
            floatingCoin.Font = Enum.Font.GothamBold
            floatingCoin.Parent = screenGui
            
            local floatTween = TweenService:Create(floatingCoin, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, floatingCoin.Position.X.Offset, 0, -100),
                TextTransparency = 1
            })
            floatTween:Play()
            floatTween.Completed:Connect(function()
                floatingCoin:Destroy()
            end)
        end
    end
end)

-- Button hover effects
local function addHoverEffect(button, hoverColor, normalColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = normalColor}):Play()
    end)
end

-- Add hover effects to buttons
addHoverEffect(rollButton, Color3.fromRGB(90, 90, 110), Color3.fromRGB(70, 70, 90))
addHoverEffect(inventoryButton, Color3.fromRGB(60, 60, 70), Color3.fromRGB(40, 40, 50))
addHoverEffect(codesButton, Color3.fromRGB(60, 60, 70), Color3.fromRGB(40, 40, 50))
addHoverEffect(indexButton, Color3.fromRGB(60, 60, 70), Color3.fromRGB(40, 40, 50))
addHoverEffect(redeemButton, Color3.fromRGB(0, 200, 0), Color3.fromRGB(0, 170, 0))

-- Button Connections
rollButton.MouseButton1Click:Connect(rollGlitch)

inventoryButton.MouseButton1Click:Connect(function()
    inventoryGui.Visible = true
end)

closeInventory.MouseButton1Click:Connect(function()
    inventoryGui.Visible = false
end)

codesButton.MouseButton1Click:Connect(function()
    codesGui.Visible = true
    codeInput.Text = ""
end)

closeCodes.MouseButton1Click:Connect(function()
    codesGui.Visible = false
end)

indexButton.MouseButton1Click:Connect(function()
    indexGui.Visible = true
end)

closeIndex.MouseButton1Click:Connect(function()
    indexGui.Visible = false
end)

redeemButton.MouseButton1Click:Connect(redeemCode)

codeInput.FocusLost:Connect(function(enterPressed)
    -- Redeem code if Enter is pressed while typing in the textbox
    if enterPressed then
        redeemCode()
    end
end)

-- Initialize
updateCoins() -- Set initial coin display

-- Welcome message
spawn(function()
    task.wait(1)
    showNotification("Welcome to Glitch Aura! Start rolling for glitches!", Color3.fromRGB(100, 100, 255))
end)