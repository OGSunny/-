-- Unlock System (ServerScriptService)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for RemoteEvents
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local updateGUIRemote = remoteEvents:WaitForChild("UpdateGUIRemote")

-- Create unlock remote event
local unlockRemote = Instance.new("RemoteEvent")
unlockRemote.Name = "UnlockRemote"
unlockRemote.Parent = remoteEvents

-- Unlock thresholds and rewards
local unlockThresholds = {
    {
        clicks = 100,
        unlock = "achievement1",
        title = "First Steps!",
        description = "Reached 100 total clicks!",
        reward = "clickPower",
        rewardValue = 1
    },
    {
        clicks = 500,
        unlock = "achievement2", 
        title = "Getting Warmed Up!",
        description = "Reached 500 total clicks!",
        reward = "clicks",
        rewardValue = 50
    },
    {
        clicks = 1000,
        unlock = "achievement3",
        title = "Click Master!",
        description = "Reached 1,000 total clicks!",
        reward = "autoClicker",
        rewardValue = 1
    },
    {
        clicks = 5000,
        unlock = "achievement4",
        title = "Dedication!",
        description = "Reached 5,000 total clicks!",
        reward = "clickPower",
        rewardValue = 5
    },
    {
        clicks = 10000,
        unlock = "achievement5",
        title = "Click Legend!",
        description = "Reached 10,000 total clicks!",
        reward = "autoClicker",
        rewardValue = 2
    },
    {
        clicks = 25000,
        unlock = "achievement6",
        title = "Unstoppable!",
        description = "Reached 25,000 total clicks!",
        reward = "clickPower",
        rewardValue = 10
    },
    {
        clicks = 50000,
        unlock = "achievement7",
        title = "Click God!",
        description = "Reached 50,000 total clicks!",
        reward = "autoClickPower",
        rewardValue = 5
    },
    {
        clicks = 100000,
        unlock = "achievement8",
        title = "Transcendent Clicker!",
        description = "Reached 100,000 total clicks!",
        reward = "clickPower",
        rewardValue = 25
    }
}

-- Track player unlocks
local playerUnlocks = {}

-- Function to check and grant unlocks
local function checkUnlocks(player, playerData)
    if not playerUnlocks[player.UserId] then
        playerUnlocks[player.UserId] = {}
    end
    
    local unlockedSomething = false
    
    for _, unlock in ipairs(unlockThresholds) do
        if playerData.totalClicks >= unlock.clicks and not playerUnlocks[player.UserId][unlock.unlock] then
            -- Grant unlock
            playerUnlocks[player.UserId][unlock.unlock] = true
            
            -- Apply reward
            if unlock.reward == "clickPower" then
                playerData.clickPower = playerData.clickPower + unlock.rewardValue
            elseif unlock.reward == "clicks" then
                playerData.clicks = playerData.clicks + unlock.rewardValue
            elseif unlock.reward == "autoClicker" then
                playerData.autoClickers = playerData.autoClickers + unlock.rewardValue
            elseif unlock.reward == "autoClickPower" then
                playerData.autoClickPower = playerData.autoClickPower + unlock.rewardValue
            end
            
            -- Notify client
            unlockRemote:FireClient(player, unlock)
            unlockedSomething = true
        end
    end
    
    return unlockedSomething
end

-- Function to get next unlock for display
local function getNextUnlock(totalClicks)
    for _, unlock in ipairs(unlockThresholds) do
        if totalClicks < unlock.clicks then
            return unlock
        end
    end
    return nil
end

-- Export functions for use by other scripts
_G.CheckUnlocks = checkUnlocks
_G.GetNextUnlock = getNextUnlock

print("Unlock System loaded!")