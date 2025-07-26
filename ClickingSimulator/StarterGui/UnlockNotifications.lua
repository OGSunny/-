-- Unlock Notifications (StarterGui LocalScript)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local unlockRemote = remoteEvents:WaitForChild("UnlockRemote")

-- Create notification GUI
local notificationGui = Instance.new("ScreenGui")
notificationGui.Name = "UnlockNotifications"
notificationGui.ResetOnSpawn = false
notificationGui.Parent = playerGui

-- Queue for notifications
local notificationQueue = {}
local isShowingNotification = false

-- Function to create unlock notification
local function createUnlockNotification(unlockData)
    -- Main notification frame
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "UnlockNotification"
    notificationFrame.Size = UDim2.new(0, 400, 0, 120)
    notificationFrame.Position = UDim2.new(0.5, -200, 0, -150) -- Start off-screen
    notificationFrame.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Parent = notificationGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = notificationFrame
    
    -- Add gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 220, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 180, 30))
    }
    gradient.Rotation = 45
    gradient.Parent = notificationFrame
    
    -- Add glow effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxasset://textures/ui/Glow.png"
    glow.ImageColor3 = Color3.fromRGB(255, 255, 100)
    glow.ImageTransparency = 0.5
    glow.Parent = notificationFrame
    
    -- Achievement icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 60, 0, 60)
    iconLabel.Position = UDim2.new(0, 15, 0.5, -30)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "🏆"
    iconLabel.TextScaled = true
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Parent = notificationFrame
    
    -- Achievement title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -90, 0, 30)
    titleLabel.Position = UDim2.new(0, 85, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎉 " .. unlockData.title
    titleLabel.TextColor3 = Color3.white
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notificationFrame
    
    -- Achievement description
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(1, -90, 0, 25)
    descLabel.Position = UDim2.new(0, 85, 0, 45)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = unlockData.description
    descLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    descLabel.TextScaled = true
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = notificationFrame
    
    -- Reward text
    local rewardText = ""
    if unlockData.reward == "clickPower" then
        rewardText = "+" .. unlockData.rewardValue .. " Click Power!"
    elseif unlockData.reward == "clicks" then
        rewardText = "+" .. unlockData.rewardValue .. " Clicks!"
    elseif unlockData.reward == "autoClicker" then
        rewardText = "+" .. unlockData.rewardValue .. " Auto Clicker!"
    elseif unlockData.reward == "autoClickPower" then
        rewardText = "+" .. unlockData.rewardValue .. " Auto Click Power!"
    end
    
    local rewardLabel = Instance.new("TextLabel")
    rewardLabel.Name = "Reward"
    rewardLabel.Size = UDim2.new(1, -90, 0, 20)
    rewardLabel.Position = UDim2.new(0, 85, 0, 75)
    rewardLabel.BackgroundTransparency = 1
    rewardLabel.Text = "Reward: " .. rewardText
    rewardLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    rewardLabel.TextScaled = true
    rewardLabel.Font = Enum.Font.GothamBold
    rewardLabel.TextXAlignment = Enum.TextXAlignment.Left
    rewardLabel.Parent = notificationFrame
    
    return notificationFrame
end

-- Function to show notification with animation
local function showNotification(unlockData)
    if isShowingNotification then
        table.insert(notificationQueue, unlockData)
        return
    end
    
    isShowingNotification = true
    
    local notification = createUnlockNotification(unlockData)
    
    -- Slide in animation
    local slideInTween = TweenService:Create(
        notification,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -200, 0, 50)}
    )
    
    -- Glow pulse animation
    local glow = notification:FindFirstChild("Glow")
    local glowTween = TweenService:Create(
        glow,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {ImageTransparency = 0.2}
    )
    
    slideInTween:Play()
    glowTween:Play()
    
    -- Wait, then slide out
    slideInTween.Completed:Connect(function()
        wait(3) -- Show for 3 seconds
        
        local slideOutTween = TweenService:Create(
            notification,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, -200, 0, -150)}
        )
        
        slideOutTween:Play()
        glowTween:Cancel()
        
        slideOutTween.Completed:Connect(function()
            notification:Destroy()
            isShowingNotification = false
            
            -- Show next notification in queue
            if #notificationQueue > 0 then
                local nextUnlock = table.remove(notificationQueue, 1)
                showNotification(nextUnlock)
            end
        end)
    end)
    
    -- Create particle effects
    spawn(function()
        for i = 1, 10 do
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, 8, 0, 8)
            particle.Position = UDim2.new(0.5, math.random(-200, 200), 0.5, math.random(-60, 60))
            particle.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
            particle.BorderSizePixel = 0
            particle.Parent = notificationGui
            
            local particleCorner = Instance.new("UICorner")
            particleCorner.CornerRadius = UDim.new(1, 0)
            particleCorner.Parent = particle
            
            -- Animate particle
            local particleTween = TweenService:Create(
                particle,
                TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(particle.Position.X.Scale, particle.Position.X.Offset + math.random(-100, 100), 
                                       particle.Position.Y.Scale - 0.3, particle.Position.Y.Offset),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 2, 0, 2)
                }
            )
            
            particleTween:Play()
            particleTween.Completed:Connect(function()
                particle:Destroy()
            end)
            
            wait(0.1)
        end
    end)
end

-- Listen for unlock events
unlockRemote.OnClientEvent:Connect(function(unlockData)
    showNotification(unlockData)
end)