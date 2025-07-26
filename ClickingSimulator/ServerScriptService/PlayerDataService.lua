-- PlayerData Service (ServerScriptService)
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local playerDataStore = DataStoreService:GetDataStore("PlayerData")

-- Wait for RemoteEvents to be created
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local clickRemote = remoteEvents:WaitForChild("ClickRemote")
local updateGUIRemote = remoteEvents:WaitForChild("UpdateGUIRemote")
local leaderboardRemote = remoteEvents:WaitForChild("LeaderboardRemote")

-- Wait for shop items module
local shopItemsModule = ReplicatedStorage:WaitForChild("ShopItems")
local shopItems = require(shopItemsModule)

-- Default player data structure
local defaultData = {
    clicks = 0,
    clickPower = 1,
    autoClickers = 0,
    autoClickPower = 1,
    upgrades = {},
    lastAutoClick = 0,
    totalClicks = 0,
    joinTime = os.time()
}

-- Store player data in memory
local playerData = {}

-- Helper function to deep copy table
local function deepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

-- Load player data
local function loadPlayerData(player)
    local success, data = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        -- Merge with default data to ensure all fields exist
        local mergedData = deepCopy(defaultData)
        for key, value in pairs(data) do
            mergedData[key] = value
        end
        playerData[player.UserId] = mergedData
    else
        playerData[player.UserId] = deepCopy(defaultData)
    end
    
    -- Initialize last auto click time
    playerData[player.UserId].lastAutoClick = tick()
    
    -- Update client GUI
    updatePlayerGUI(player)
end

-- Save player data
local function savePlayerData(player)
    if not playerData[player.UserId] then return end
    
    pcall(function()
        playerDataStore:SetAsync(player.UserId, playerData[player.UserId])
    end)
end

-- Get player data
function getPlayerData(player)
    return playerData[player.UserId]
end

-- Update player GUI
function updatePlayerGUI(player)
    local data = playerData[player.UserId]
    if data then
        updateGUIRemote:FireClient(player, data)
    end
end

-- Calculate upgrade price
local function calculatePrice(item, purchaseCount)
    return math.floor(item.basePrice * (item.priceMultiplier ^ purchaseCount))
end

-- Handle remote events
clickRemote.OnServerEvent:Connect(function(player, action, itemId)
    local data = playerData[player.UserId]
    if not data then return end
    
    if action == "click" then
        -- Add clicks based on click power
        data.clicks = data.clicks + data.clickPower
        data.totalClicks = data.totalClicks + data.clickPower
        
        -- Check for unlocks
        if _G.CheckUnlocks then
            _G.CheckUnlocks(player, data)
        end
        
        updatePlayerGUI(player)
        
    elseif action == "purchase" and itemId then
        local item = shopItems[itemId]
        if not item then return end
        
        local currentCount = data.upgrades[itemId] or 0
        local currentPrice = calculatePrice(item, currentCount)
        
        if data.clicks >= currentPrice then
            -- Deduct cost
            data.clicks = data.clicks - currentPrice
            
            -- Apply upgrade
            if item.effect == "clickPower" then
                data.clickPower = data.clickPower + item.value
            elseif item.effect == "autoClicker" then
                data.autoClickers = data.autoClickers + item.value
            elseif item.effect == "autoClickPower" then
                data.autoClickPower = data.autoClickPower + item.value
            end
            
            -- Track purchase count
            data.upgrades[itemId] = currentCount + 1
            
            -- Update client
            updatePlayerGUI(player)
        end
    end
end)

-- Auto-clicker system
local lastAutoClickUpdate = tick()
RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    
    -- Run auto-clickers every second
    if currentTime - lastAutoClickUpdate >= 1 then
        for userId, data in pairs(playerData) do
            if data.autoClickers > 0 then
                local autoClickAmount = data.autoClickers * data.autoClickPower
                data.clicks = data.clicks + autoClickAmount
                data.totalClicks = data.totalClicks + autoClickAmount
                
                -- Update GUI for this player
                local player = Players:GetPlayerByUserId(userId)
                if player then
                    -- Check for unlocks
                    if _G.CheckUnlocks then
                        _G.CheckUnlocks(player, data)
                    end
                    updatePlayerGUI(player)
                end
            end
        end
        lastAutoClickUpdate = currentTime
    end
end)

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
    loadPlayerData(player)
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
    playerData[player.UserId] = nil
end)

-- Auto-save every 30 seconds
spawn(function()
    while true do
        wait(30)
        for _, player in pairs(Players:GetPlayers()) do
            savePlayerData(player)
        end
    end
end)

-- Leaderboard system
spawn(function()
    while true do
        wait(5) -- Update leaderboard every 5 seconds
        
        local leaderboardData = {}
        for _, player in pairs(Players:GetPlayers()) do
            local data = playerData[player.UserId]
            if data then
                table.insert(leaderboardData, {
                    name = player.Name,
                    clicks = data.totalClicks,
                    clickPower = data.clickPower
                })
            end
        end
        
        -- Sort by total clicks
        table.sort(leaderboardData, function(a, b)
            return a.clicks > b.clicks
        end)
        
        -- Send to all clients
        for _, player in pairs(Players:GetPlayers()) do
            leaderboardRemote:FireClient(player, leaderboardData)
        end
    end
end)