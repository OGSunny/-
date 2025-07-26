-- Shop Items Configuration (ReplicatedStorage ModuleScript)
local shopItems = {
    {
        name = "Better Finger",
        description = "+1 Click Power",
        basePrice = 10,
        priceMultiplier = 1.5,
        effect = "clickPower",
        value = 1,
        icon = "👆"
    },
    {
        name = "Strong Finger",
        description = "+2 Click Power",
        basePrice = 50,
        priceMultiplier = 1.6,
        effect = "clickPower",
        value = 2,
        icon = "💪"
    },
    {
        name = "Auto Clicker",
        description = "Clicks automatically every second",
        basePrice = 100,
        priceMultiplier = 2,
        effect = "autoClicker",
        value = 1,
        icon = "🤖"
    },
    {
        name = "Mega Finger",
        description = "+5 Click Power",
        basePrice = 500,
        priceMultiplier = 1.8,
        effect = "clickPower",
        value = 5,
        icon = "🔥"
    },
    {
        name = "Super Auto Clicker",
        description = "+3 Auto Clickers",
        basePrice = 1000,
        priceMultiplier = 2.2,
        effect = "autoClicker",
        value = 3,
        icon = "⚡"
    },
    {
        name = "Power Boost",
        description = "+2 Auto Click Power",
        basePrice = 2000,
        priceMultiplier = 2.5,
        effect = "autoClickPower",
        value = 2,
        icon = "💥"
    },
    {
        name = "Ultimate Finger",
        description = "+10 Click Power",
        basePrice = 5000,
        priceMultiplier = 2,
        effect = "clickPower",
        value = 10,
        icon = "👑"
    },
    {
        name = "Mega Auto Clicker",
        description = "+5 Auto Clickers",
        basePrice = 10000,
        priceMultiplier = 2.3,
        effect = "autoClicker",
        value = 5,
        icon = "🚀"
    },
    {
        name = "Power Multiplier",
        description = "+5 Auto Click Power",
        basePrice = 25000,
        priceMultiplier = 3,
        effect = "autoClickPower",
        value = 5,
        icon = "⭐"
    },
    {
        name = "Legendary Finger",
        description = "+25 Click Power",
        basePrice = 50000,
        priceMultiplier = 2.5,
        effect = "clickPower",
        value = 25,
        icon = "💎"
    }
}

return shopItems