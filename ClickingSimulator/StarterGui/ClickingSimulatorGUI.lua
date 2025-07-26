-- Clicking Simulator GUI (StarterGui LocalScript)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents and ShopItems
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local clickRemote = remoteEvents:WaitForChild("ClickRemote")
local updateGUIRemote = remoteEvents:WaitForChild("UpdateGUIRemote")
local leaderboardRemote = remoteEvents:WaitForChild("LeaderboardRemote")

local shopItemsModule = ReplicatedStorage:WaitForChild("ShopItems")
local shopItems = require(shopItemsModule)

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClickingSimulatorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Background gradient
local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
backgroundGradient.Rotation = 45
backgroundGradient.Parent = mainFrame

-- Click Button
local clickButton = Instance.new("TextButton")
clickButton.Name = "ClickButton"
clickButton.Size = UDim2.new(0, 200, 0, 200)
clickButton.Position = UDim2.new(0.5, -100, 0.5, -100)
clickButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
clickButton.Text = "CLICK ME!"
clickButton.TextColor3 = Color3.white
clickButton.TextScaled = true
clickButton.Font = Enum.Font.GothamBold
clickButton.BorderSizePixel = 0
clickButton.Parent = mainFrame

-- Click button styling
local clickButtonCorner = Instance.new("UICorner")
clickButtonCorner.CornerRadius = UDim.new(0, 20)
clickButtonCorner.Parent = clickButton

local clickButtonGradient = Instance.new("UIGradient")
clickButtonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 80))
}
clickButtonGradient.Rotation = 90
clickButtonGradient.Parent = clickButton

-- Stats Frame
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 300, 0, 200)
statsFrame.Position = UDim2.new(0, 20, 0, 20)
statsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
statsFrame.BorderSizePixel = 0
statsFrame.Parent = mainFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 15)
statsCorner.Parent = statsFrame

-- Stats Title
local statsTitle = Instance.new("TextLabel")
statsTitle.Name = "StatsTitle"
statsTitle.Size = UDim2.new(1, 0, 0, 40)
statsTitle.Position = UDim2.new(0, 0, 0, 0)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "📊 STATS"
statsTitle.TextColor3 = Color3.white
statsTitle.TextScaled = true
statsTitle.Font = Enum.Font.GothamBold
statsTitle.Parent = statsFrame

-- Clicks Label
local clicksLabel = Instance.new("TextLabel")
clicksLabel.Name = "ClicksLabel"
clicksLabel.Size = UDim2.new(1, -20, 0, 30)
clicksLabel.Position = UDim2.new(0, 10, 0, 50)
clicksLabel.BackgroundTransparency = 1
clicksLabel.Text = "Clicks: 0"
clicksLabel.TextColor3 = Color3.white
clicksLabel.TextScaled = true
clicksLabel.Font = Enum.Font.Gotham
clicksLabel.TextXAlignment = Enum.TextXAlignment.Left
clicksLabel.Parent = statsFrame

-- Click Power Label
local clickPowerLabel = Instance.new("TextLabel")
clickPowerLabel.Name = "ClickPowerLabel"
clickPowerLabel.Size = UDim2.new(1, -20, 0, 30)
clickPowerLabel.Position = UDim2.new(0, 10, 0, 90)
clickPowerLabel.BackgroundTransparency = 1
clickPowerLabel.Text = "Click Power: 1"
clickPowerLabel.TextColor3 = Color3.white
clickPowerLabel.TextScaled = true
clickPowerLabel.Font = Enum.Font.Gotham
clickPowerLabel.TextXAlignment = Enum.TextXAlignment.Left
clickPowerLabel.Parent = statsFrame

-- Auto Clickers Label
local autoClickersLabel = Instance.new("TextLabel")
autoClickersLabel.Name = "AutoClickersLabel"
autoClickersLabel.Size = UDim2.new(1, -20, 0, 30)
autoClickersLabel.Position = UDim2.new(0, 10, 0, 130)
autoClickersLabel.BackgroundTransparency = 1
autoClickersLabel.Text = "Auto Clickers: 0"
autoClickersLabel.TextColor3 = Color3.white
autoClickersLabel.TextScaled = true
autoClickersLabel.Font = Enum.Font.Gotham
autoClickersLabel.TextXAlignment = Enum.TextXAlignment.Left
autoClickersLabel.Parent = statsFrame

-- Shop Frame
local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopFrame"
shopFrame.Size = UDim2.new(0, 350, 0, 500)
shopFrame.Position = UDim2.new(1, -370, 0, 20)
shopFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
shopFrame.BorderSizePixel = 0
shopFrame.Parent = mainFrame

local shopCorner = Instance.new("UICorner")
shopCorner.CornerRadius = UDim.new(0, 15)
shopCorner.Parent = shopFrame

-- Shop Title
local shopTitle = Instance.new("TextLabel")
shopTitle.Name = "ShopTitle"
shopTitle.Size = UDim2.new(1, 0, 0, 50)
shopTitle.Position = UDim2.new(0, 0, 0, 0)
shopTitle.BackgroundTransparency = 1
shopTitle.Text = "🛒 SHOP"
shopTitle.TextColor3 = Color3.white
shopTitle.TextScaled = true
shopTitle.Font = Enum.Font.GothamBold
shopTitle.Parent = shopFrame

-- Shop Scroll Frame
local shopScrollFrame = Instance.new("ScrollingFrame")
shopScrollFrame.Name = "ShopScrollFrame"
shopScrollFrame.Size = UDim2.new(1, -20, 1, -70)
shopScrollFrame.Position = UDim2.new(0, 10, 0, 60)
shopScrollFrame.BackgroundTransparency = 1
shopScrollFrame.BorderSizePixel = 0
shopScrollFrame.ScrollBarThickness = 8
shopScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
shopScrollFrame.Parent = shopFrame

local shopLayout = Instance.new("UIListLayout")
shopLayout.SortOrder = Enum.SortOrder.LayoutOrder
shopLayout.Padding = UDim.new(0, 10)
shopLayout.Parent = shopScrollFrame

-- Leaderboard Frame
local leaderboardFrame = Instance.new("Frame")
leaderboardFrame.Name = "LeaderboardFrame"
leaderboardFrame.Size = UDim2.new(0, 300, 0, 400)
leaderboardFrame.Position = UDim2.new(0, 20, 1, -420)
leaderboardFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
leaderboardFrame.BorderSizePixel = 0
leaderboardFrame.Parent = mainFrame

local leaderboardCorner = Instance.new("UICorner")
leaderboardCorner.CornerRadius = UDim.new(0, 15)
leaderboardCorner.Parent = leaderboardFrame

-- Leaderboard Title
local leaderboardTitle = Instance.new("TextLabel")
leaderboardTitle.Name = "LeaderboardTitle"
leaderboardTitle.Size = UDim2.new(1, 0, 0, 50)
leaderboardTitle.Position = UDim2.new(0, 0, 0, 0)
leaderboardTitle.BackgroundTransparency = 1
leaderboardTitle.Text = "🏆 LEADERBOARD"
leaderboardTitle.TextColor3 = Color3.white
leaderboardTitle.TextScaled = true
leaderboardTitle.Font = Enum.Font.GothamBold
leaderboardTitle.Parent = leaderboardFrame

-- Leaderboard Scroll Frame
local leaderboardScrollFrame = Instance.new("ScrollingFrame")
leaderboardScrollFrame.Name = "LeaderboardScrollFrame"
leaderboardScrollFrame.Size = UDim2.new(1, -20, 1, -70)
leaderboardScrollFrame.Position = UDim2.new(0, 10, 0, 60)
leaderboardScrollFrame.BackgroundTransparency = 1
leaderboardScrollFrame.BorderSizePixel = 0
leaderboardScrollFrame.ScrollBarThickness = 8
leaderboardScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
leaderboardScrollFrame.Parent = leaderboardFrame

local leaderboardLayout = Instance.new("UIListLayout")
leaderboardLayout.SortOrder = Enum.SortOrder.LayoutOrder
leaderboardLayout.Padding = UDim.new(0, 5)
leaderboardLayout.Parent = leaderboardScrollFrame

-- Helper function to format numbers
local function formatNumber(num)
    if num >= 1000000000 then
        return string.format("%.2fB", num / 1000000000)
    elseif num >= 1000000 then
        return string.format("%.2fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.2fK", num / 1000)
    else
        return tostring(num)
    end
end

-- Helper function to calculate price
local function calculatePrice(item, purchaseCount)
    return math.floor(item.basePrice * (item.priceMultiplier ^ purchaseCount))
end

-- Create shop items
local shopButtons = {}
for i, item in ipairs(shopItems) do
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "Item" .. i
    itemFrame.Size = UDim2.new(1, 0, 0, 80)
    itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = shopScrollFrame
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 10)
    itemCorner.Parent = itemFrame
    
    local itemButton = Instance.new("TextButton")
    itemButton.Name = "ItemButton"
    itemButton.Size = UDim2.new(1, 0, 1, 0)
    itemButton.Position = UDim2.new(0, 0, 0, 0)
    itemButton.BackgroundTransparency = 1
    itemButton.Text = ""
    itemButton.Parent = itemFrame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "IconLabel"
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 10, 0.5, -20)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = item.icon
    iconLabel.TextScaled = true
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Parent = itemFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -120, 0, 25)
    nameLabel.Position = UDim2.new(0, 60, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = item.name
    nameLabel.TextColor3 = Color3.white
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = itemFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "DescLabel"
    descLabel.Size = UDim2.new(1, -120, 0, 20)
    descLabel.Position = UDim2.new(0, 60, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = item.description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextScaled = true
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = itemFrame
    
    local priceLabel = Instance.new("TextLabel")
    priceLabel.Name = "PriceLabel"
    priceLabel.Size = UDim2.new(0, 80, 0, 30)
    priceLabel.Position = UDim2.new(1, -90, 0.5, -15)
    priceLabel.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    priceLabel.Text = formatNumber(item.basePrice)
    priceLabel.TextColor3 = Color3.black
    priceLabel.TextScaled = true
    priceLabel.Font = Enum.Font.GothamBold
    priceLabel.Parent = itemFrame
    
    local priceLabelCorner = Instance.new("UICorner")
    priceLabelCorner.CornerRadius = UDim.new(0, 8)
    priceLabelCorner.Parent = priceLabel
    
    shopButtons[i] = {
        button = itemButton,
        frame = itemFrame,
        priceLabel = priceLabel
    }
    
    -- Click handler
    itemButton.MouseButton1Click:Connect(function()
        clickRemote:FireServer("purchase", i)
    end)
end

-- Update shop scroll frame size
shopScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #shopItems * 90)

-- Click button functionality
clickButton.MouseButton1Click:Connect(function()
    -- Visual feedback
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
    local scaleTween = TweenService:Create(clickButton, tweenInfo, {Size = UDim2.new(0, 180, 0, 180)})
    scaleTween:Play()
    
    scaleTween.Completed:Connect(function()
        local returnTween = TweenService:Create(clickButton, tweenInfo, {Size = UDim2.new(0, 200, 0, 200)})
        returnTween:Play()
    end)
    
    -- Create click effect
    local clickEffect = Instance.new("TextLabel")
    clickEffect.Size = UDim2.new(0, 50, 0, 50)
    clickEffect.Position = UDim2.new(0.5, math.random(-50, 50), 0.5, math.random(-50, 50))
    clickEffect.BackgroundTransparency = 1
    clickEffect.Text = "+1"
    clickEffect.TextColor3 = Color3.fromRGB(255, 255, 100)
    clickEffect.TextScaled = true
    clickEffect.Font = Enum.Font.GothamBold
    clickEffect.Parent = mainFrame
    
    -- Animate click effect
    local effectTween = TweenService:Create(clickEffect, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(clickEffect.Position.X.Scale, clickEffect.Position.X.Offset, clickEffect.Position.Y.Scale - 0.1, clickEffect.Position.Y.Offset),
        TextTransparency = 1
    })
    effectTween:Play()
    
    effectTween.Completed:Connect(function()
        clickEffect:Destroy()
    end)
    
    -- Send click to server
    clickRemote:FireServer("click")
end)

-- Update GUI when data changes
updateGUIRemote.OnClientEvent:Connect(function(data)
    clicksLabel.Text = "Clicks: " .. formatNumber(data.clicks)
    clickPowerLabel.Text = "Click Power: " .. formatNumber(data.clickPower)
    autoClickersLabel.Text = "Auto Clickers: " .. formatNumber(data.autoClickers)
    
    -- Update click effect text
    clickButton.Text = "CLICK ME!\n+" .. formatNumber(data.clickPower)
    
    -- Update shop prices
    for i, shopButton in ipairs(shopButtons) do
        local item = shopItems[i]
        local purchaseCount = data.upgrades[i] or 0
        local currentPrice = calculatePrice(item, purchaseCount)
        shopButton.priceLabel.Text = formatNumber(currentPrice)
        
        -- Color code affordability
        if data.clicks >= currentPrice then
            shopButton.priceLabel.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            shopButton.frame.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
        else
            shopButton.priceLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            shopButton.frame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        end
    end
end)

-- Update leaderboard
leaderboardRemote.OnClientEvent:Connect(function(leaderboardData)
    -- Clear existing leaderboard
    for _, child in ipairs(leaderboardScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Create leaderboard entries
    for i, entry in ipairs(leaderboardData) do
        if i > 10 then break end -- Show top 10 only
        
        local entryFrame = Instance.new("Frame")
        entryFrame.Name = "Entry" .. i
        entryFrame.Size = UDim2.new(1, 0, 0, 30)
        entryFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        entryFrame.BorderSizePixel = 0
        entryFrame.Parent = leaderboardScrollFrame
        
        local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 8)
        entryCorner.Parent = entryFrame
        
        local rankLabel = Instance.new("TextLabel")
        rankLabel.Size = UDim2.new(0, 30, 1, 0)
        rankLabel.Position = UDim2.new(0, 5, 0, 0)
        rankLabel.BackgroundTransparency = 1
        rankLabel.Text = "#" .. i
        rankLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        rankLabel.TextScaled = true
        rankLabel.Font = Enum.Font.GothamBold
        rankLabel.Parent = entryFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.5, -35, 1, 0)
        nameLabel.Position = UDim2.new(0, 35, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = entry.name
        nameLabel.TextColor3 = Color3.white
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = entryFrame
        
        local clicksLabel = Instance.new("TextLabel")
        clicksLabel.Size = UDim2.new(0.5, -10, 1, 0)
        clicksLabel.Position = UDim2.new(0.5, 0, 0, 0)
        clicksLabel.BackgroundTransparency = 1
        clicksLabel.Text = formatNumber(entry.clicks)
        clicksLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        clicksLabel.TextScaled = true
        clicksLabel.Font = Enum.Font.Gotham
        clicksLabel.TextXAlignment = Enum.TextXAlignment.Right
        clicksLabel.Parent = entryFrame
    end
    
    -- Update scroll frame size
    leaderboardScrollFrame.CanvasSize = UDim2.new(0, 0, 0, math.min(#leaderboardData, 10) * 35)
end)