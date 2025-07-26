-- Roblox Glitch Aura Game System
-- Place this in StarterPlayerScripts as a LocalScript

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player References
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Game Data
local gameData = {
    coins = 500, -- Starting coins
    glitches = {},
    potions = {}, -- Currently unused, but good for future expansion
    hasGlitch = false,
    coinMultiplier = 1
}

-- Glitch Database
-- Defines all possible glitches, their properties, and drop chances.
local glitchDatabase = {
    {name = "Shadow Glitch", rarity = "Common", chance = 40, coinBonus = 1.2, color = Color3.fromRGB(50, 50, 50)},
    {name = "Neon Glitch", rarity = "Uncommon", chance = 25, coinBonus = 1.5, color = Color3.fromRGB(0, 255, 255)},
    {name = "Fire Glitch", rarity = "Rare", chance = 20, coinBonus = 2.0, color = Color3.fromRGB(255, 100, 0)},
    {name = "Rainbow Glitch", rarity = "Epic", chance = 10, coinBonus = 3.0, color = Color3.fromRGB(255, 0, 255)},
    {name = "Void Glitch", rarity = "Legendary", chance = 4, coinBonus = 5.0, color = Color3.fromRGB(100, 0, 200)},
    {name = "Cosmic Glitch", rarity = "Mythic", chance = 1, coinBonus = 10.0, color = Color3.fromRGB(255, 215, 0)}
}

-- Codes Database
-- Stores redeemable codes and their associated rewards.
local codesDatabase = {
    ["FREEGEMS"] = {coins = 1000, active = true},
    ["GLITCH2024"] = {coins = 500, active = true},
    ["LUCKY"] = {coins = 750, active = true}
}

-- UI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GlitchAuraGame"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local coinFrame = Instance.new("Frame")
coinFrame.Size = UDim2.new(0, 200, 0, 50)
coinFrame.Position = UDim2.new(0, 20, 0, 20)
coinFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
coinFrame.BorderSizePixel = 0
coinFrame.Parent = screenGui

local coinFrameCorner = Instance.new("UICorner")
coinFrameCorner.CornerRadius = UDim.new(0, 8)
coinFrameCorner.Parent = coinFrame

local coinIcon = Instance.new("ImageLabel")
coinIcon.Size = UDim2.new(0, 30, 0, 30)
coinIcon.Position = UDim2.new(0, 10, 0.5, -15)
coinIcon.BackgroundTransparency = 1
coinIcon.Image = "rbxassetid://17368061836" -- Placeholder Image ID
coinIcon.Parent = coinFrame

local coinLabel = Instance.new("TextLabel")
coinLabel.Size = UDim2.new(1, -50, 1, 0)
coinLabel.Position = UDim2.new(0, 50, 0, 0)
coinLabel.BackgroundTransparency = 1
coinLabel.Text = gameData.coins
coinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coinLabel.TextScaled = true
coinLabel.Font = Enum.Font.GothamBold
coinLabel.Parent = coinFrame

local rollButton = Instance.new("ImageButton")
rollButton.Size = UDim2.new(0, 80, 0, 80)
rollButton.Position = UDim2.new(0.5, -40, 1, -100)
rollButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
rollButton.BorderSizePixel = 0
rollButton.Image = "rbxassetid://125264363254178" -- Placeholder Image ID
rollButton.Parent = screenGui

local rollButtonCorner = Instance.new("UICorner")
rollButtonCorner.CornerRadius = UDim.new(0.5, 0)
rollButtonCorner.Parent = rollButton

local rollCostLabel = Instance.new("TextLabel")
rollCostLabel.Size = UDim2.new(1, 0, 0, 20)
rollCostLabel.Position = UDim2.new(0, 0, 1, 5)
rollCostLabel.BackgroundTransparency = 1
rollCostLabel.Text = "100 Coins"
rollCostLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
rollCostLabel.TextScaled = true
rollCostLabel.Font = Enum.Font.Gotham
rollCostLabel.Parent = rollButton

local inventoryButton = Instance.new("ImageButton")
inventoryButton.Size = UDim2.new(0, 60, 0, 60)
inventoryButton.Position = UDim2.new(0, 20, 0.5, -30)
inventoryButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inventoryButton.BorderSizePixel = 0
inventoryButton.Image = "rbxassetid://18209609229" -- Placeholder Image ID
inventoryButton.Parent = screenGui

local inventoryCorner = Instance.new("UICorner")
inventoryCorner.CornerRadius = UDim.new(0, 8)
inventoryCorner.Parent = inventoryButton

local codesButton = Instance.new("ImageButton")
codesButton.Size = UDim2.new(0, 60, 0, 60)
codesButton.Position = UDim2.new(0, 20, 0.5, 50)
codesButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
codesButton.BorderSizePixel = 0
codesButton.Image = "rbxassetid://18209599690" -- Placeholder Image ID
codesButton.Parent = screenGui

local codesCorner = Instance.new("UICorner")
codesCorner.CornerRadius = UDim.new(0, 8)
codesCorner.Parent = codesButton

local indexButton = Instance.new("ImageButton")
indexButton.Size = UDim2.new(0, 60, 0, 60)
indexButton.Position = UDim2.new(0, 20, 0.5, 130)
indexButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
indexButton.BorderSizePixel = 0
indexButton.Image = "rbxassetid://76367970334970" -- Placeholder Image ID
indexButton.Parent = screenGui

local indexCorner = Instance.new("UICorner")
indexCorner.CornerRadius = UDim.new(0, 8)
indexCorner.Parent = indexButton

local inventoryGui = Instance.new("Frame")
inventoryGui.Size = UDim2.new(0, 400, 0, 500)
inventoryGui.Position = UDim2.new(0.5, -200, 0.5, -250)
inventoryGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inventoryGui.BorderSizePixel = 0
inventoryGui.Visible = false
inventoryGui.Parent = screenGui

local inventoryCornerGui = Instance.new("UICorner")
inventoryCornerGui.CornerRadius = UDim.new(0, 10)
inventoryCornerGui.Parent = inventoryGui

local inventoryTitle = Instance.new("TextLabel")
inventoryTitle.Size = UDim2.new(1, -60, 0, 40)
inventoryTitle.Position = UDim2.new(0, 0, 0, 0)
inventoryTitle.BackgroundTransparency = 1
inventoryTitle.Text = "INVENTORY"
inventoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
inventoryTitle.TextScaled = true
inventoryTitle.Font = Enum.Font.GothamBold
inventoryTitle.Parent = inventoryGui

local closeInventory = Instance.new("ImageButton")
closeInventory.Size = UDim2.new(0, 30, 0, 30)
closeInventory.Position = UDim2.new(1, -40, 0, 5)
closeInventory.BackgroundTransparency = 1
closeInventory.Image = "rbxassetid://17368208589" -- Placeholder Image ID
closeInventory.Parent = inventoryGui

local glitchFrame = Instance.new("Frame")
glitchFrame.Size = UDim2.new(1, -20, 0.5, -30)
glitchFrame.Position = UDim2.new(0, 10, 0, 50)
glitchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
glitchFrame.BorderSizePixel = 0
glitchFrame.Parent = inventoryGui

local glitchFrameCorner = Instance.new("UICorner")
glitchFrameCorner.CornerRadius = UDim.new(0, 8)
glitchFrameCorner.Parent = glitchFrame

local glitchTitle = Instance.new("TextLabel")
glitchTitle.Size = UDim2.new(1, 0, 0, 30)
glitchTitle.Position = UDim2.new(0, 0, 0, 0)
glitchTitle.BackgroundTransparency = 1
glitchTitle.Text = "GLITCHES"
glitchTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
glitchTitle.TextScaled = true
glitchTitle.Font = Enum.Font.Gotham
glitchTitle.Parent = glitchFrame

local glitchScrollFrame = Instance.new("ScrollingFrame")
glitchScrollFrame.Size = UDim2.new(1, -10, 1, -40)
glitchScrollFrame.Position = UDim2.new(0, 5, 0, 35)
glitchScrollFrame.BackgroundTransparency = 1
glitchScrollFrame.ScrollBarThickness = 8
glitchScrollFrame.Parent = glitchFrame

local glitchGrid = Instance.new("UIGridLayout")
glitchGrid.CellSize = UDim2.new(0, 60, 0, 60)
glitchGrid.CellPadding = UDim2.new(0, 5, 0, 5)
glitchGrid.Parent = glitchScrollFrame

local potionFrame = Instance.new("Frame")
potionFrame.Size = UDim2.new(1, -20, 0.5, -30)
potionFrame.Position = UDim2.new(0, 10, 0.5, 10)
potionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
potionFrame.BorderSizePixel = 0
potionFrame.Parent = inventoryGui

local potionFrameCorner = Instance.new("UICorner")
potionFrameCorner.CornerRadius = UDim.new(0, 8)
potionFrameCorner.Parent = potionFrame

local potionTitle = Instance.new("TextLabel")
potionTitle.Size = UDim2.new(1, 0, 0, 30)
potionTitle.Position = UDim2.new(0, 0, 0, 0)
potionTitle.BackgroundTransparency = 1
potionTitle.Text = "POTIONS"
potionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
potionTitle.TextScaled = true
potionTitle.Font = Enum.Font.Gotham
potionTitle.Parent = potionFrame

local codesGui = Instance.new("Frame")
codesGui.Size = UDim2.new(0, 350, 0, 400)
codesGui.Position = UDim2.new(0.5, -175, 0.5, -200)
codesGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
codesGui.BorderSizePixel = 0
codesGui.Visible = false
codesGui.Parent = screenGui

local codesCornerGui = Instance.new("UICorner")
codesCornerGui.CornerRadius = UDim.new(0, 10)
codesCornerGui.Parent = codesGui

local codesTitle = Instance.new("TextLabel")
codesTitle.Size = UDim2.new(1, -60, 0, 40)
codesTitle.Position = UDim2.new(0, 0, 0, 0)
codesTitle.BackgroundTransparency = 1
codesTitle.Text = "CODES"
codesTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
codesTitle.TextScaled = true
codesTitle.Font = Enum.Font.GothamBold
codesTitle.Parent = codesGui

local closeCodes = Instance.new("ImageButton")
closeCodes.Size = UDim2.new(0, 30, 0, 30)
closeCodes.Position = UDim2.new(1, -40, 0, 5)
closeCodes.BackgroundTransparency = 1
closeCodes.Image = "rbxassetid://17368208589" -- Placeholder Image ID
closeCodes.Parent = codesGui

local codeInput = Instance.new("TextBox")
codeInput.Size = UDim2.new(1, -20, 0, 40)
codeInput.Position = UDim2.new(0, 10, 0, 50)
codeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
codeInput.BorderSizePixel = 0
codeInput.Text = "Enter Code..."
codeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
codeInput.TextScaled = true
codeInput.Font = Enum.Font.Gotham
codeInput.Parent = codesGui

local codeInputCorner = Instance.new("UICorner")
codeInputCorner.CornerRadius = UDim.new(0, 8)
codeInputCorner.Parent = codeInput

local redeemButton = Instance.new("TextButton")
redeemButton.Size = UDim2.new(1, -20, 0, 40)
redeemButton.Position = UDim2.new(0, 10, 0, 100)
redeemButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
redeemButton.BorderSizePixel = 0
redeemButton.Text = "REDEEM"
redeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
redeemButton.TextScaled = true
redeemButton.Font = Enum.Font.GothamBold
redeemButton.Parent = codesGui

local redeemCorner = Instance.new("UICorner")
redeemCorner.CornerRadius = UDim.new(0, 8)
redeemCorner.Parent = redeemButton

local indexGui = Instance.new("Frame")
indexGui.Size = UDim2.new(0, 500, 0, 600)
indexGui.Position = UDim2.new(0.5, -250, 0.5, -300)
indexGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
indexGui.BorderSizePixel = 0
indexGui.Visible = false
indexGui.Parent = screenGui

local indexCornerGui = Instance.new("UICorner")
indexCornerGui.CornerRadius = UDim.new(0, 10)
indexCornerGui.Parent = indexGui

local indexTitle = Instance.new("TextLabel")
indexTitle.Size = UDim2.new(1, -60, 0, 40)
indexTitle.Position = UDim2.new(0, 0, 0, 0)
indexTitle.BackgroundTransparency = 1
indexTitle.Text = "GLITCH INDEX"
indexTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
indexTitle.TextScaled = true
indexTitle.Font = Enum.Font.GothamBold
indexTitle.Parent = indexGui

local closeIndex = Instance.new("ImageButton")
closeIndex.Size = UDim2.new(0, 30, 0, 30)
closeIndex.Position = UDim2.new(1, -40, 0, 5)
closeIndex.BackgroundTransparency = 1
closeIndex.Image = "rbxassetid://17368208589" -- Placeholder Image ID
closeIndex.Parent = indexGui

local indexScrollFrame = Instance.new("ScrollingFrame")
indexScrollFrame.Size = UDim2.new(1, -20, 1, -60)
indexScrollFrame.Position = UDim2.new(0, 10, 0, 50)
indexScrollFrame.BackgroundTransparency = 1
indexScrollFrame.ScrollBarThickness = 8
indexScrollFrame.Parent = indexGui

local indexList = Instance.new("UIListLayout")
indexList.Padding = UDim.new(0, 10)
indexList.Parent = indexScrollFrame

-- Populate Glitch Index dynamically
for _, glitch in ipairs(glitchDatabase) do
    local glitchEntry = Instance.new("Frame")
    glitchEntry.Size = UDim2.new(1, -20, 0, 80)
    glitchEntry.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    glitchEntry.BorderSizePixel = 0
    glitchEntry.Parent = indexScrollFrame
    
    local glitchEntryCorner = Instance.new("UICorner")
    glitchEntryCorner.CornerRadius = UDim.new(0, 8)
    glitchEntryCorner.Parent = glitchEntry
    
    local glitchIcon = Instance.new("Frame")
    glitchIcon.Size = UDim2.new(0, 60, 0, 60)
    glitchIcon.Position = UDim2.new(0, 10, 0, 10)
    glitchIcon.BackgroundColor3 = glitch.color
    glitchIcon.BorderSizePixel = 0
    glitchIcon.Parent = glitchEntry
    
    local glitchIconCorner = Instance.new("UICorner")
    glitchIconCorner.CornerRadius = UDim.new(0, 8)
    glitchIconCorner.Parent = glitchIcon
    
    local glitchName = Instance.new("TextLabel")
    glitchName.Size = UDim2.new(1, -90, 0, 30)
    glitchName.Position = UDim2.new(0, 80, 0, 10)
    glitchName.BackgroundTransparency = 1
    glitchName.Text = glitch.name
    glitchName.TextColor3 = Color3.fromRGB(255, 255, 255)
    glitchName.TextScaled = true
    glitchName.Font = Enum.Font.GothamBold
    glitchName.TextXAlignment = Enum.TextXAlignment.Left
    glitchName.Parent = glitchEntry
    
    local glitchRarity = Instance.new("TextLabel")
    glitchRarity.Size = UDim2.new(1, -90, 0, 20)
    glitchRarity.Position = UDim2.new(0, 80, 0, 40)
    glitchRarity.BackgroundTransparency = 1
    glitchRarity.Text = glitch.rarity .. " (" .. glitch.chance .. "%)"
    glitchRarity.TextColor3 = glitch.color
    glitchRarity.TextScaled = true
    glitchRarity.Font = Enum.Font.Gotham
    glitchRarity.TextXAlignment = Enum.TextXAlignment.Left
    glitchRarity.Parent = glitchEntry
end

-- Adjust CanvasSize for the Index ScrollFrame after populating
indexScrollFrame.CanvasSize = UDim2.new(0, 0, 0, indexList.AbsoluteContentSize.Y + indexList.Padding.Offset)

local function updateCoins()
    -- Updates the coin display on the UI.
    coinLabel.Text = gameData.coins
end

local function addGlitch(glitch)
    -- Adds a new glitch to the player's inventory and updates game stats.
    table.insert(gameData.glitches, glitch)
    gameData.hasGlitch = true
    gameData.coinMultiplier = math.max(gameData.coinMultiplier, glitch.coinBonus) -- Ensure multiplier is highest
    
    -- Create glitch slot in inventory UI
    local glitchSlot = Instance.new("Frame")
    glitchSlot.Size = UDim2.new(0, 60, 0, 60)
    glitchSlot.BackgroundColor3 = glitch.color
    glitchSlot.BorderSizePixel = 0
    glitchSlot.Parent = glitchScrollFrame
    
    local glitchSlotCorner = Instance.new("UICorner")
    glitchSlotCorner.CornerRadius = UDim.new(0, 8)
    glitchSlotCorner.Parent = glitchSlot
    
    local glitchLabel = Instance.new("TextLabel")
    glitchLabel.Size = UDim2.new(1, 0, 1, 0)
    glitchLabel.BackgroundTransparency = 1
    glitchLabel.Text = string.sub(glitch.name, 1, 1) -- Display first letter of glitch name
    glitchLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    glitchLabel.TextScaled = true
    glitchLabel.Font = Enum.Font.GothamBold
    glitchLabel.Parent = glitchSlot
    
    -- Adjust CanvasSize for the Inventory Glitch ScrollFrame
    glitchScrollFrame.CanvasSize = UDim2.new(0, 0, 0, glitchGrid.AbsoluteContentSize.Y + glitchGrid.CellPadding.Offset)
end

local function rollGlitch()
    -- Handles the logic for rolling a new glitch.
    local rollCost = 100
    if gameData.coins < rollCost then
        warn("Not enough coins to roll!")
        return -- Exit if not enough coins
    end
    
    gameData.coins = gameData.coins - rollCost
    updateCoins()
    
    -- Animate roll button
    local tween = TweenService:Create(rollButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 70, 0, 70)})
    tween:Play()
    tween.Completed:Wait() -- Wait for shrink to complete
    TweenService:Create(rollButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 80, 0, 80)}):Play()
    
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

    if codeInfo and codeInfo.active then
        gameData.coins = gameData.coins + codeInfo.coins
        codeInfo.active = false -- Deactivate the code after use
        updateCoins()
        codeInput.Text = "Code Redeemed!"
    else
        codeInput.Text = "Invalid or Used Code!"
    end
    
    -- Reset input field after a delay
    task.wait(2)
    codeInput.Text = "Enter Code..."
    isRedeeming = false
end

-- Coin Generation Loop
-- Awards coins periodically based on multiplier.
spawn(function()
    while true do
        task.wait(1) -- Use task.wait for more robust waiting
        local coinsToAdd = 10 * gameData.coinMultiplier
        gameData.coins = gameData.coins + coinsToAdd
        updateCoins()
    end
end)

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
    codeInput.Text = "Enter Code..." -- Reset input text when opening
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

updateCoins() -- Set initial coin display


Make this work fix everything egt the models yourswlf and make sure they work and make full change and make sure it looks good
