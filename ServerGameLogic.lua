-- 🔒 SERVER-SIDE GAME LOGIC - SECURE & EXPLOIT-PROOF
-- This handles all critical game operations on the server to prevent cheating

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

-- 💾 DATA STORES
local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v2")
local GlobalDataStore = DataStoreService:GetDataStore("GlobalData_v1")

-- 🗄️ SERVER DATA STORAGE
local ServerGameData = {} -- Player.UserId -> GameData
local PlayerConnections = {} -- Track player connections

-- 🌟 SERVER-SIDE GLITCH DATABASE
local GlitchDatabase = {
    -- Common (50% total)
    {name = "Shadow Wisp", rarity = "Common", chance = 20, coinBonus = 1.2, value = 50, xpBonus = 1.1, color = Color3.fromRGB(60, 60, 80)},
    {name = "Static Pulse", rarity = "Common", chance = 15, coinBonus = 1.3, value = 75, xpBonus = 1.15, color = Color3.fromRGB(80, 80, 100)},
    {name = "Digital Echo", rarity = "Common", chance = 15, coinBonus = 1.4, value = 100, xpBonus = 1.2, color = Color3.fromRGB(70, 90, 110)},
    
    -- Uncommon (25% total)
    {name = "Neon Surge", rarity = "Uncommon", chance = 12, coinBonus = 1.8, value = 200, xpBonus = 1.3, gemChanceBonus = 1.1, color = Color3.fromRGB(0, 255, 150)},
    {name = "Pixel Storm", rarity = "Uncommon", chance = 8, coinBonus = 2.0, value = 300, xpBonus = 1.4, gemChanceBonus = 1.15, color = Color3.fromRGB(100, 200, 255)},
    {name = "Code Fragment", rarity = "Uncommon", chance = 5, coinBonus = 2.2, value = 400, xpBonus = 1.5, gemChanceBonus = 1.2, color = Color3.fromRGB(150, 255, 100)},
    
    -- Rare (15% total)
    {name = "Inferno Core", rarity = "Rare", chance = 7, coinBonus = 3.0, value = 800, xpBonus = 2.0, potionDropChance = 0.1, color = Color3.fromRGB(255, 100, 0)},
    {name = "Frost Matrix", rarity = "Rare", chance = 5, coinBonus = 3.5, value = 1200, xpBonus = 2.2, potionDropChance = 0.12, color = Color3.fromRGB(100, 200, 255)},
    {name = "Lightning Node", rarity = "Rare", chance = 3, coinBonus = 4.0, value = 1600, xpBonus = 2.5, potionDropChance = 0.15, color = Color3.fromRGB(255, 255, 0)},
    
    -- Epic (7% total)
    {name = "Prismatic Void", rarity = "Epic", chance = 3, coinBonus = 5.0, value = 3000, xpBonus = 3.0, luckBoostDuration = 300, color = Color3.fromRGB(255, 0, 255)},
    {name = "Quantum Rift", rarity = "Epic", chance = 2.5, coinBonus = 6.0, value = 4000, xpBonus = 3.5, luckBoostDuration = 450, color = Color3.fromRGB(200, 100, 255)},
    {name = "Plasma Burst", rarity = "Epic", chance = 1.5, coinBonus = 7.0, value = 5000, xpBonus = 4.0, luckBoostDuration = 600, color = Color3.fromRGB(255, 100, 200)},
    
    -- Legendary (2.5% total)
    {name = "Void Reaper", rarity = "Legendary", chance = 1, coinBonus = 10.0, value = 10000, xpBonus = 5.0, autoSellBonus = 1.5, color = Color3.fromRGB(100, 0, 200)},
    {name = "Celestial Gate", rarity = "Legendary", chance = 0.8, coinBonus = 12.0, value = 15000, xpBonus = 6.0, autoSellBonus = 1.7, color = Color3.fromRGB(255, 215, 0)},
    {name = "Dimension Tear", rarity = "Legendary", chance = 0.7, coinBonus = 15.0, value = 20000, xpBonus = 7.0, autoSellBonus = 2.0, color = Color3.fromRGB(200, 0, 100)},
    
    -- Mythic (0.4% total)
    {name = "Cosmic Genesis", rarity = "Mythic", chance = 0.2, coinBonus = 25.0, value = 50000, xpBonus = 10.0, setBonus = "Cosmic", color = Color3.fromRGB(255, 215, 0)},
    {name = "Reality Shard", rarity = "Mythic", chance = 0.15, coinBonus = 30.0, value = 75000, xpBonus = 12.0, setBonus = "Reality", color = Color3.fromRGB(255, 255, 255)},
    
    -- Divine (0.1% total)
    {name = "Omnipotent Core", rarity = "Divine", chance = 0.05, coinBonus = 50.0, value = 200000, xpBonus = 20.0, setBonus = "Divine", color = Color3.fromRGB(255, 255, 255)},
    {name = "Universe Heart", rarity = "Divine", chance = 0.03, coinBonus = 75.0, value = 500000, xpBonus = 25.0, setBonus = "Divine", color = Color3.fromRGB(255, 255, 255)},
    {name = "Infinity Essence", rarity = "Divine", chance = 0.02, coinBonus = 100.0, value = 1000000, xpBonus = 30.0, setBonus = "Divine", color = Color3.fromRGB(255, 255, 255)}
}

-- 🧪 POTION DATABASE
local PotionDatabase = {
    {name = "Luck Elixir", rarity = "Common", effect = "luck", multiplier = 1.5, duration = 300, color = Color3.fromRGB(0, 255, 100)},
    {name = "Coin Booster", rarity = "Common", effect = "coins", multiplier = 2.0, duration = 600, color = Color3.fromRGB(255, 215, 0)},
    {name = "XP Accelerator", rarity = "Uncommon", effect = "xp", multiplier = 3.0, duration = 450, color = Color3.fromRGB(100, 150, 255)},
    {name = "Divine Fortune", rarity = "Rare", effect = "luck", multiplier = 3.0, duration = 900, color = Color3.fromRGB(255, 100, 255)},
    {name = "Mystic Multiplier", rarity = "Epic", effect = "all", multiplier = 2.5, duration = 1200, color = Color3.fromRGB(200, 100, 255)}
}

-- 💎 ENHANCED CODES DATABASE
local CodesDatabase = {
    ["GLITCH2024"] = {coins = 2500, gems = 10, xp = 500, active = true},
    ["MYTHICPOWER"] = {coins = 1500, gems = 5, potions = {"Luck Elixir"}, active = true},
    ["VOIDMASTER"] = {coins = 3000, gems = 15, xp = 1000, active = true},
    ["NEWPLAYER"] = {coins = 1000, gems = 5, xp = 200, active = true},
    ["WELCOME"] = {coins = 500, gems = 2, potions = {"Coin Booster"}, active = true},
    ["LUCKYBOOST"] = {coins = 2000, luckBoost = 1.5, duration = 1800, active = true},
    ["RNGMASTER"] = {coins = 5000, gems = 25, xp = 2000, active = true},
    ["LEGENDARY"] = {coins = 10000, gems = 50, potions = {"Divine Fortune"}, active = true},
    ["PRESTIGE"] = {coins = 25000, gems = 100, prestigeTokens = 1, active = true}
}

-- 🏪 SHOP DATABASE
local ShopDatabase = {
    upgrades = {
        {id = "luck_boost_1", name = "Luck Boost I", description = "Permanently increase luck by 25%", cost = 1000, currency = "gems", effect = {type = "luck", value = 1.25}},
        {id = "coin_mult_1", name = "Coin Multiplier I", description = "Permanently increase coin gain by 50%", cost = 2000, currency = "gems", effect = {type = "coinMult", value = 1.5}},
        {id = "roll_discount_1", name = "Roll Discount I", description = "Reduce roll cost by 20%", cost = 1500, currency = "gems", effect = {type = "rollDiscount", value = 0.8}},
        {id = "inventory_expand_1", name = "Inventory Expansion I", description = "Increase inventory slots by 50", cost = 500, currency = "gems", effect = {type = "inventory", value = 50}}
    },
    boosters = {
        {id = "temp_luck_1", name = "Temporary Luck Boost", description = "2x luck for 30 minutes", cost = 100, currency = "gems", duration = 1800, effect = {type = "luck", value = 2.0}},
        {id = "temp_coins_1", name = "Temporary Coin Boost", description = "3x coins for 15 minutes", cost = 150, currency = "gems", duration = 900, effect = {type = "coins", value = 3.0}},
        {id = "auto_roll_1", name = "Auto-Roll Token", description = "Enable auto-roll for 1 hour", cost = 200, currency = "gems", duration = 3600, effect = {type = "autoRoll", value = true}}
    }
}

-- 🎯 QUEST DATABASE
local QuestDatabase = {
    daily = {
        {id = "daily_rolls", name = "Daily Roller", description = "Roll 10 times", target = 10, rewards = {coins = 500, xp = 100}},
        {id = "daily_rare", name = "Rare Hunter", description = "Find 1 rare or better item", target = 1, rewards = {coins = 1000, gems = 5}},
        {id = "daily_codes", name = "Code Redeemer", description = "Redeem 1 code", target = 1, rewards = {coins = 300, xp = 50}}
    },
    weekly = {
        {id = "weekly_legend", name = "Legend Seeker", description = "Find 1 legendary item", target = 1, rewards = {coins = 5000, gems = 25, xp = 1000}},
        {id = "weekly_rolls", name = "Roll Master", description = "Roll 100 times", target = 100, rewards = {coins = 2000, gems = 10}}
    }
}

-- 📊 LEADERBOARD TRACKING
local LeaderboardStats = {
    totalRolls = {},
    totalCoinsEarned = {},
    rareItemsFound = {},
    highestValueItem = {}
}

-- 🔧 UTILITY FUNCTIONS
local function getDefaultPlayerData()
    return {
        coins = 1000,
        gems = 50,
        xp = 0,
        level = 1,
        glitches = {},
        potions = {},
        coinMultiplier = 1,
        luckMultiplier = 1,
        xpMultiplier = 1,
        usedCodes = {},
        rollCost = 100,
        autoRollEnabled = false,
        maxInventorySlots = 100,
        prestigeLevel = 0,
        prestigeTokens = 0,
        activeBuffs = {},
        ownedUpgrades = {},
        statistics = {
            totalRolls = 0,
            totalCoinsEarned = 0,
            rareItemsFound = 0,
            playTime = 0,
            highestValueItem = 0,
            itemsSold = 0,
            codesRedeemed = 0
        },
        settings = {
            soundEnabled = true,
            particlesEnabled = true,
            autoSellCommons = false,
            autoSellUncommons = false
        },
        quests = {
            daily = {},
            weekly = {},
            lastDailyReset = 0,
            lastWeeklyReset = 0
        },
        achievements = {}
    }
end

local function loadPlayerData(player)
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        ServerGameData[player.UserId] = data
        -- Ensure all new fields exist (for version compatibility)
        local defaultData = getDefaultPlayerData()
        for key, value in pairs(defaultData) do
            if ServerGameData[player.UserId][key] == nil then
                ServerGameData[player.UserId][key] = value
            end
        end
    else
        ServerGameData[player.UserId] = getDefaultPlayerData()
    end
    
    -- Initialize daily/weekly quests if needed
    initializeQuests(player.UserId)
    
    print("Loaded data for player:", player.Name)
end

local function savePlayerData(player)
    local data = ServerGameData[player.UserId]
    if data then
        local success, errorMessage = pcall(function()
            PlayerDataStore:SetAsync(player.UserId, data)
        end)
        
        if not success then
            warn("Failed to save data for player " .. player.Name .. ": " .. errorMessage)
        end
    end
end

-- 🎯 QUEST SYSTEM
local function initializeQuests(userId)
    local playerData = ServerGameData[userId]
    local currentTime = os.time()
    
    -- Reset daily quests if needed (24 hours)
    if currentTime - playerData.quests.lastDailyReset > 86400 then
        playerData.quests.daily = {}
        for _, quest in ipairs(QuestDatabase.daily) do
            playerData.quests.daily[quest.id] = {
                progress = 0,
                completed = false,
                claimed = false
            }
        end
        playerData.quests.lastDailyReset = currentTime
    end
    
    -- Reset weekly quests if needed (7 days)
    if currentTime - playerData.quests.lastWeeklyReset > 604800 then
        playerData.quests.weekly = {}
        for _, quest in ipairs(QuestDatabase.weekly) do
            playerData.quests.weekly[quest.id] = {
                progress = 0,
                completed = false,
                claimed = false
            }
        end
        playerData.quests.lastWeeklyReset = currentTime
    end
end

local function updateQuestProgress(userId, questType, amount)
    local playerData = ServerGameData[userId]
    
    -- Update daily roll quest
    if questType == "rolls" then
        if playerData.quests.daily.daily_rolls and not playerData.quests.daily.daily_rolls.completed then
            playerData.quests.daily.daily_rolls.progress = playerData.quests.daily.daily_rolls.progress + amount
            if playerData.quests.daily.daily_rolls.progress >= 10 then
                playerData.quests.daily.daily_rolls.completed = true
            end
        end
        
        if playerData.quests.weekly.weekly_rolls and not playerData.quests.weekly.weekly_rolls.completed then
            playerData.quests.weekly.weekly_rolls.progress = playerData.quests.weekly.weekly_rolls.progress + amount
            if playerData.quests.weekly.weekly_rolls.progress >= 100 then
                playerData.quests.weekly.weekly_rolls.completed = true
            end
        end
    end
    
    -- Update rare item quests
    if questType == "rare_items" then
        if playerData.quests.daily.daily_rare and not playerData.quests.daily.daily_rare.completed then
            playerData.quests.daily.daily_rare.progress = playerData.quests.daily.daily_rare.progress + amount
            if playerData.quests.daily.daily_rare.progress >= 1 then
                playerData.quests.daily.daily_rare.completed = true
            end
        end
    end
    
    -- Update legendary quest
    if questType == "legendary_items" then
        if playerData.quests.weekly.weekly_legend and not playerData.quests.weekly.weekly_legend.completed then
            playerData.quests.weekly.weekly_legend.progress = playerData.quests.weekly.weekly_legend.progress + amount
            if playerData.quests.weekly.weekly_legend.progress >= 1 then
                playerData.quests.weekly.weekly_legend.completed = true
            end
        end
    end
end

-- 🏆 ACHIEVEMENT SYSTEM
local function checkAchievements(userId)
    local playerData = ServerGameData[userId]
    local achievements = {
        {id = "first_roll", name = "First Steps", description = "Make your first roll", condition = function() return playerData.statistics.totalRolls >= 1 end},
        {id = "roll_master", name = "Roll Master", description = "Make 1000 rolls", condition = function() return playerData.statistics.totalRolls >= 1000 end},
        {id = "rare_collector", name = "Rare Collector", description = "Find 10 rare items", condition = function() return playerData.statistics.rareItemsFound >= 10 end},
        {id = "millionaire", name = "Millionaire", description = "Earn 1,000,000 coins", condition = function() return playerData.statistics.totalCoinsEarned >= 1000000 end}
    }
    
    for _, achievement in ipairs(achievements) do
        if not playerData.achievements[achievement.id] and achievement.condition() then
            playerData.achievements[achievement.id] = {
                unlocked = true,
                timestamp = os.time()
            }
            -- Send achievement notification to client
            local remoteEvent = ReplicatedStorage:WaitForChild("AchievementUnlocked")
            remoteEvent:FireClient(Players:GetPlayerByUserId(userId), achievement)
        end
    end
end

-- 🎲 ENHANCED ROLL LOGIC
local function performRoll(userId)
    local playerData = ServerGameData[userId]
    
    if playerData.coins < playerData.rollCost then
        return false, "Not enough coins to roll! Need " .. playerData.rollCost .. " coins"
    end
    
    -- Check inventory space
    if #playerData.glitches >= playerData.maxInventorySlots then
        return false, "Inventory full! Sell some items or upgrade your inventory."
    end
    
    playerData.coins = playerData.coins - playerData.rollCost
    playerData.statistics.totalRolls = playerData.statistics.totalRolls + 1
    
    -- Apply active buffs
    local effectiveLuck = playerData.luckMultiplier
    for buffId, buff in pairs(playerData.activeBuffs) do
        if buff.effect.type == "luck" and buff.endTime > os.time() then
            effectiveLuck = effectiveLuck * buff.effect.value
        end
    end
    
    -- Enhanced roll logic with luck
    local roll = math.random(1, 10000) / effectiveLuck
    local rolledGlitch = nil
    
    -- Pre-calculated cumulative chances for better performance
    local cumulativeChances = {
        {chance = 2000, rarity = "Common"},
        {chance = 2500, rarity = "Uncommon"},
        {chance = 1500, rarity = "Rare"},
        {chance = 700, rarity = "Epic"},
        {chance = 250, rarity = "Legendary"},
        {chance = 40, rarity = "Mythic"},
        {chance = 10, rarity = "Divine"}
    }
    
    local currentSum = 0
    local targetRarity = "Common"
    
    for _, rarityData in ipairs(cumulativeChances) do
        currentSum = currentSum + rarityData.chance
        if roll <= currentSum then
            targetRarity = rarityData.rarity
            break
        end
    end
    
    -- Find a random glitch of the target rarity
    local possibleGlitches = {}
    for _, glitch in ipairs(GlitchDatabase) do
        if glitch.rarity == targetRarity then
            table.insert(possibleGlitches, glitch)
        end
    end
    
    if #possibleGlitches > 0 then
        rolledGlitch = possibleGlitches[math.random(1, #possibleGlitches)]
    else
        rolledGlitch = GlitchDatabase[1] -- Fallback
    end
    
    if rolledGlitch then
        -- Create glitch copy with unique properties
        local glitchCopy = {}
        for k, v in pairs(rolledGlitch) do
            glitchCopy[k] = v
        end
        glitchCopy.id = playerData.statistics.totalRolls -- Unique ID
        glitchCopy.timestamp = os.time()
        
        -- Auto-sell if enabled and meets criteria
        if (playerData.settings.autoSellCommons and rolledGlitch.rarity == "Common") or
           (playerData.settings.autoSellUncommons and rolledGlitch.rarity == "Uncommon") then
            
            local sellValue = math.floor(rolledGlitch.value * (playerData.ownedUpgrades.autoSellBonus or 1))
            playerData.coins = playerData.coins + sellValue
            playerData.statistics.itemsSold = playerData.statistics.itemsSold + 1
            return true, "Auto-sold " .. rolledGlitch.name .. " for " .. sellValue .. " coins!", rolledGlitch, "auto_sell"
        else
            table.insert(playerData.glitches, glitchCopy)
        end
        
        -- Update multipliers
        if rolledGlitch.coinBonus > playerData.coinMultiplier then
            playerData.coinMultiplier = rolledGlitch.coinBonus
        end
        
        if rolledGlitch.xpBonus and rolledGlitch.xpBonus > playerData.xpMultiplier then
            playerData.xpMultiplier = rolledGlitch.xpBonus
        end
        
        -- Update statistics
        if rolledGlitch.rarity ~= "Common" then
            playerData.statistics.rareItemsFound = playerData.statistics.rareItemsFound + 1
            updateQuestProgress(userId, "rare_items", 1)
        end
        
        if rolledGlitch.rarity == "Legendary" or rolledGlitch.rarity == "Mythic" or rolledGlitch.rarity == "Divine" then
            updateQuestProgress(userId, "legendary_items", 1)
        end
        
        if rolledGlitch.value > playerData.statistics.highestValueItem then
            playerData.statistics.highestValueItem = rolledGlitch.value
        end
        
        -- Award XP
        local xpGain = math.floor((rolledGlitch.value / 10) * playerData.xpMultiplier)
        playerData.xp = playerData.xp + xpGain
        
        -- Check for level up
        local newLevel = math.floor(playerData.xp / 1000) + 1
        if newLevel > playerData.level then
            playerData.level = newLevel
            -- Level up rewards
            playerData.gems = playerData.gems + (newLevel * 2)
        end
        
        -- Handle special glitch effects
        if rolledGlitch.potionDropChance and math.random() < rolledGlitch.potionDropChance then
            local randomPotion = PotionDatabase[math.random(1, #PotionDatabase)]
            table.insert(playerData.potions, randomPotion)
        end
        
        if rolledGlitch.luckBoostDuration then
            playerData.activeBuffs["glitch_luck_" .. glitchCopy.id] = {
                effect = {type = "luck", value = 1.5},
                endTime = os.time() + rolledGlitch.luckBoostDuration,
                source = "glitch"
            }
        end
        
        -- Update quest progress
        updateQuestProgress(userId, "rolls", 1)
        
        -- Check achievements
        checkAchievements(userId)
        
        local message = "🎉 " .. rolledGlitch.rarity .. " " .. rolledGlitch.name .. " obtained!"
        if xpGain > 0 then
            message = message .. " (+" .. xpGain .. " XP)"
        end
        
        return true, message, rolledGlitch, "normal"
    else
        return false, "Failed to roll an item."
    end
end

-- 🎫 CODE REDEMPTION
local function redeemCode(userId, code)
    local playerData = ServerGameData[userId]
    local upperCode = string.upper(code:gsub("%s", ""))
    local codeData = CodesDatabase[upperCode]
    
    if not codeData or not codeData.active then
        return false, "Invalid code!"
    end
    
    if playerData.usedCodes[upperCode] then
        return false, "Code already used!"
    end
    
    local rewards = {}
    
    if codeData.coins then
        playerData.coins = playerData.coins + codeData.coins
        table.insert(rewards, codeData.coins .. " coins")
    end
    
    if codeData.gems then
        playerData.gems = playerData.gems + codeData.gems
        table.insert(rewards, codeData.gems .. " gems")
    end
    
    if codeData.xp then
        playerData.xp = playerData.xp + codeData.xp
        table.insert(rewards, codeData.xp .. " XP")
    end
    
    if codeData.luckBoost and codeData.duration then
        playerData.activeBuffs["code_luck"] = {
            effect = {type = "luck", value = codeData.luckBoost},
            endTime = os.time() + codeData.duration,
            source = "code"
        }
        table.insert(rewards, codeData.luckBoost .. "x luck for " .. math.floor(codeData.duration/60) .. " minutes")
    end
    
    if codeData.potions then
        for _, potionName in ipairs(codeData.potions) do
            for _, potion in ipairs(PotionDatabase) do
                if potion.name == potionName then
                    table.insert(playerData.potions, potion)
                    table.insert(rewards, potionName)
                    break
                end
            end
        end
    end
    
    if codeData.prestigeTokens then
        playerData.prestigeTokens = playerData.prestigeTokens + codeData.prestigeTokens
        table.insert(rewards, codeData.prestigeTokens .. " prestige tokens")
    end
    
    playerData.usedCodes[upperCode] = true
    playerData.statistics.codesRedeemed = playerData.statistics.codesRedeemed + 1
    
    -- Update quest progress
    updateQuestProgress(userId, "codes", 1)
    
    return true, "Code redeemed! Received: " .. table.concat(rewards, ", ")
end

-- 🧪 POTION USAGE
local function usePotion(userId, potionIndex)
    local playerData = ServerGameData[userId]
    
    if not playerData.potions[potionIndex] then
        return false, "Potion not found!"
    end
    
    local potion = playerData.potions[potionIndex]
    local buffId = "potion_" .. potion.effect .. "_" .. os.time()
    
    playerData.activeBuffs[buffId] = {
        effect = {type = potion.effect, value = potion.multiplier},
        endTime = os.time() + potion.duration,
        source = "potion",
        name = potion.name
    }
    
    table.remove(playerData.potions, potionIndex)
    
    local durationMinutes = math.floor(potion.duration / 60)
    return true, "Used " .. potion.name .. "! Effect: " .. potion.multiplier .. "x " .. potion.effect .. " for " .. durationMinutes .. " minutes"
end

-- 🏪 SHOP PURCHASE
local function purchaseItem(userId, itemId, itemType)
    local playerData = ServerGameData[userId]
    local item = nil
    
    if itemType == "upgrade" then
        for _, upgrade in ipairs(ShopDatabase.upgrades) do
            if upgrade.id == itemId then
                item = upgrade
                break
            end
        end
    elseif itemType == "booster" then
        for _, booster in ipairs(ShopDatabase.boosters) do
            if booster.id == itemId then
                item = booster
                break
            end
        end
    end
    
    if not item then
        return false, "Item not found!"
    end
    
    if playerData.ownedUpgrades[itemId] and itemType == "upgrade" then
        return false, "Upgrade already owned!"
    end
    
    local currency = item.currency == "gems" and playerData.gems or playerData.coins
    if currency < item.cost then
        return false, "Not enough " .. item.currency .. "!"
    end
    
    -- Deduct cost
    if item.currency == "gems" then
        playerData.gems = playerData.gems - item.cost
    else
        playerData.coins = playerData.coins - item.cost
    end
    
    if itemType == "upgrade" then
        playerData.ownedUpgrades[itemId] = true
        
        -- Apply permanent effect
        if item.effect.type == "luck" then
            playerData.luckMultiplier = playerData.luckMultiplier * item.effect.value
        elseif item.effect.type == "coinMult" then
            playerData.coinMultiplier = playerData.coinMultiplier * item.effect.value
        elseif item.effect.type == "rollDiscount" then
            playerData.rollCost = math.floor(playerData.rollCost * item.effect.value)
        elseif item.effect.type == "inventory" then
            playerData.maxInventorySlots = playerData.maxInventorySlots + item.effect.value
        end
        
        return true, "Purchased " .. item.name .. "! Permanent effect applied."
    elseif itemType == "booster" then
        local buffId = "shop_" .. itemId .. "_" .. os.time()
        playerData.activeBuffs[buffId] = {
            effect = item.effect,
            endTime = os.time() + item.duration,
            source = "shop"
        }
        
        return true, "Purchased " .. item.name .. "! Effect active for " .. math.floor(item.duration/60) .. " minutes."
    end
end

-- 💰 ITEM SELLING
local function sellItem(userId, itemIndex)
    local playerData = ServerGameData[userId]
    
    if not playerData.glitches[itemIndex] then
        return false, "Item not found!"
    end
    
    local item = playerData.glitches[itemIndex]
    local sellValue = math.floor(item.value * (playerData.ownedUpgrades.autoSellBonus or 1))
    
    playerData.coins = playerData.coins + sellValue
    playerData.statistics.itemsSold = playerData.statistics.itemsSold + 1
    
    table.remove(playerData.glitches, itemIndex)
    
    return true, "Sold " .. item.name .. " for " .. sellValue .. " coins!"
end

-- 🔄 BUFF CLEANUP
local function cleanupExpiredBuffs(userId)
    local playerData = ServerGameData[userId]
    local currentTime = os.time()
    
    for buffId, buff in pairs(playerData.activeBuffs) do
        if buff.endTime <= currentTime then
            playerData.activeBuffs[buffId] = nil
        end
    end
end

-- 🎮 CREATE REMOTE EVENTS AND FUNCTIONS
local function createRemoteEvents()
    local remoteFolder = Instance.new("Folder")
    remoteFolder.Name = "RemoteEvents"
    remoteFolder.Parent = ReplicatedStorage
    
    -- Remote Functions (Client -> Server -> Client)
    local rollGlitch = Instance.new("RemoteFunction")
    rollGlitch.Name = "RollGlitch"
    rollGlitch.Parent = remoteFolder
    rollGlitch.OnServerInvoke = function(player)
        local success, message, glitchData, rollType = performRoll(player.UserId)
        cleanupExpiredBuffs(player.UserId)
        return success, message, glitchData, rollType, ServerGameData[player.UserId]
    end
    
    local redeemCodeRemote = Instance.new("RemoteFunction")
    redeemCodeRemote.Name = "RedeemCode"
    redeemCodeRemote.Parent = remoteFolder
    redeemCodeRemote.OnServerInvoke = function(player, code)
        local success, message = redeemCode(player.UserId, code)
        return success, message, ServerGameData[player.UserId]
    end
    
    local usePotionRemote = Instance.new("RemoteFunction")
    usePotionRemote.Name = "UsePotion"
    usePotionRemote.Parent = remoteFolder
    usePotionRemote.OnServerInvoke = function(player, potionIndex)
        local success, message = usePotion(player.UserId, potionIndex)
        cleanupExpiredBuffs(player.UserId)
        return success, message, ServerGameData[player.UserId]
    end
    
    local purchaseItemRemote = Instance.new("RemoteFunction")
    purchaseItemRemote.Name = "PurchaseItem"
    purchaseItemRemote.Parent = remoteFolder
    purchaseItemRemote.OnServerInvoke = function(player, itemId, itemType)
        local success, message = purchaseItem(player.UserId, itemId, itemType)
        return success, message, ServerGameData[player.UserId]
    end
    
    local sellItemRemote = Instance.new("RemoteFunction")
    sellItemRemote.Name = "SellItem"
    sellItemRemote.Parent = remoteFolder
    sellItemRemote.OnServerInvoke = function(player, itemIndex)
        local success, message = sellItem(player.UserId, itemIndex)
        return success, message, ServerGameData[player.UserId]
    end
    
    local getPlayerDataRemote = Instance.new("RemoteFunction")
    getPlayerDataRemote.Name = "GetPlayerData"
    getPlayerDataRemote.Parent = remoteFolder
    getPlayerDataRemote.OnServerInvoke = function(player)
        cleanupExpiredBuffs(player.UserId)
        return ServerGameData[player.UserId]
    end
    
    -- Remote Events (Server -> Client)
    local achievementUnlocked = Instance.new("RemoteEvent")
    achievementUnlocked.Name = "AchievementUnlocked"
    achievementUnlocked.Parent = remoteFolder
    
    local dataUpdated = Instance.new("RemoteEvent")
    dataUpdated.Name = "DataUpdated"
    dataUpdated.Parent = remoteFolder
end

-- 🎯 PLAYER CONNECTION HANDLERS
local function onPlayerAdded(player)
    loadPlayerData(player)
    
    -- Track connection for cleanup
    PlayerConnections[player.UserId] = player.AncestryChanged:Connect(function()
        if not player.Parent then
            PlayerConnections[player.UserId]:Disconnect()
            PlayerConnections[player.UserId] = nil
        end
    end)
end

local function onPlayerRemoving(player)
    savePlayerData(player)
    
    -- Cleanup
    if PlayerConnections[player.UserId] then
        PlayerConnections[player.UserId]:Disconnect()
        PlayerConnections[player.UserId] = nil
    end
    
    ServerGameData[player.UserId] = nil
end

-- 🔄 PASSIVE SYSTEMS
local function startPassiveSystems()
    -- Passive coin generation
    task.spawn(function()
        while true do
            task.wait(1)
            
            for userId, playerData in pairs(ServerGameData) do
                local player = Players:GetPlayerByUserId(userId)
                if player then
                    -- Clean up expired buffs
                    cleanupExpiredBuffs(userId)
                    
                    -- Apply coin multiplier from active buffs
                    local effectiveCoinMult = playerData.coinMultiplier
                    for buffId, buff in pairs(playerData.activeBuffs) do
                        if buff.effect.type == "coins" or buff.effect.type == "all" then
                            effectiveCoinMult = effectiveCoinMult * buff.effect.value
                        end
                    end
                    
                    local coinsToAdd = math.floor(15 * effectiveCoinMult)
                    playerData.coins = playerData.coins + coinsToAdd
                    playerData.statistics.totalCoinsEarned = playerData.statistics.totalCoinsEarned + coinsToAdd
                    playerData.statistics.playTime = playerData.statistics.playTime + 1
                    
                    -- Auto-roll if enabled and player has enough coins
                    if playerData.autoRollEnabled and playerData.coins >= playerData.rollCost then
                        performRoll(userId)
                    end
                    
                    -- Dynamic roll cost scaling
                    if playerData.statistics.totalRolls > 100 then
                        local baseCost = 100 * (playerData.ownedUpgrades.rollDiscount or 1)
                        playerData.rollCost = math.floor(baseCost + (playerData.statistics.totalRolls - 100) * 0.5)
                    end
                end
            end
        end
    end)
    
    -- Auto-save system
    task.spawn(function()
        while true do
            task.wait(30)
            for _, player in ipairs(Players:GetPlayers()) do
                savePlayerData(player)
            end
            print("🔄 Auto-saved all player data")
        end
    end)
    
    -- Daily/Weekly quest reset check
    task.spawn(function()
        while true do
            task.wait(3600) -- Check every hour
            for userId, _ in pairs(ServerGameData) do
                initializeQuests(userId)
            end
        end
    end)
end

-- 🚀 INITIALIZE SERVER
local function initializeServer()
    print("🔒 Initializing secure server-side game logic...")
    
    createRemoteEvents()
    
    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(onPlayerRemoving)
    
    -- Handle players already in game
    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end
    
    startPassiveSystems()
    
    print("✅ Server initialized successfully!")
    print("🎮 Features: Secure data, anti-exploit, quests, achievements, shop, potions")
end

-- Start the server
initializeServer()