# 🎮 Roblox Glitch Aura Game System

A complete gacha-style game system for Roblox featuring glitch collection, coin earning, and code redemption mechanics.

## 📋 Features

### 🎲 Core Gameplay
- **Roll System**: Spend 100 coins to roll for random glitches
- **Glitch Collection**: Collect 6 different glitch types with varying rarities
- **Coin Generation**: Automatic coin generation based on your glitch multipliers
- **Code Redemption**: Redeem special codes for bonus coins

### ✨ Glitch Types
1. **Shadow Glitch** (Common) - 40% chance, 1.2x coin bonus
2. **Neon Glitch** (Uncommon) - 25% chance, 1.5x coin bonus  
3. **Fire Glitch** (Rare) - 20% chance, 2.0x coin bonus
4. **Rainbow Glitch** (Epic) - 10% chance, 3.0x coin bonus
5. **Void Glitch** (Legendary) - 4% chance, 5.0x coin bonus
6. **Cosmic Glitch** (Mythic) - 1% chance, 10.0x coin bonus

### 🎫 Available Codes
- `FREEGEMS` - 1000 coins
- `GLITCH2024` - 500 coins
- `LUCKY` - 750 coins
- `NEWBIE` - 300 coins
- `WELCOME` - 200 coins

### 🎨 UI Features
- Modern dark theme with gradient backgrounds
- Smooth animations and hover effects
- Notification system for important events
- Inventory system with tooltips
- Glitch index showing all available glitches
- Sound effects for interactions

## 🚀 Installation

### Method 1: Direct Script (Recommended)
1. Open Roblox Studio
2. Create a new place or open an existing one
3. In the Explorer, navigate to `StarterPlayer` > `StarterPlayerScripts`
4. Create a new `LocalScript` in `StarterPlayerScripts`
5. Copy the entire contents of `GlitchAuraGame.lua` into the LocalScript
6. Rename the LocalScript to "GlitchAuraGame" (optional)
7. Save and test your place

### Method 2: Model Import
1. Save the script as a LocalScript in StarterPlayerScripts
2. Publish to Roblox and test in-game

## 🎮 How to Play

### Getting Started
1. **Join the game** - You start with 500 coins
2. **Roll for glitches** - Click the dice button (🎲) to spend 100 coins and roll
3. **Collect glitches** - Each glitch increases your coin generation multiplier
4. **Check inventory** - Click the backpack (🎒) to view your collected glitches
5. **Redeem codes** - Click the ticket (🎫) to enter codes for bonus coins
6. **View glitch info** - Click the book (📖) to see all available glitches

### Tips for Success
- **Save coins early** to afford multiple rolls
- **Use codes** to get a head start on coin collection
- **Higher rarity glitches** provide better coin multipliers
- **Check tooltips** in your inventory to see glitch details
- **The coin multiplier** uses your highest glitch bonus, not cumulative

## 🔧 Customization

### Adding New Glitches
Edit the `glitchDatabase` table to add new glitches:
```lua
{name = "Your Glitch", rarity = "Rarity", chance = 5, coinBonus = 2.5, color = Color3.fromRGB(255, 0, 0), icon = "🔴"}
```

### Adding New Codes
Edit the `codesDatabase` table to add new codes:
```lua
["NEWCODE"] = {coins = 500, active = true}
```

### Modifying Roll Cost
Change the `rollCost` variable in the `rollGlitch()` function:
```lua
local rollCost = 100 -- Change this value
```

### Adjusting Coin Generation
Modify the coin generation loop:
```lua
local coinsToAdd = math.floor(10 * gameData.coinMultiplier) -- Change the base value (10)
```

## 🎵 Sound Effects

The game includes built-in Roblox sound effects:
- **Roll Sound**: Electronic ping for rolling
- **Coin Sound**: Impact sound for earning coins
- **Success Sound**: Action sound for successful rolls

## 🐛 Troubleshooting

### Common Issues
1. **Script not working**: Ensure it's placed in `StarterPlayerScripts` as a `LocalScript`
2. **UI not showing**: Check that the script has no syntax errors
3. **Sounds not playing**: Sounds use built-in Roblox assets and should work automatically
4. **Codes not working**: Codes are case-insensitive but must be typed exactly

### Performance Notes
- The game uses efficient UI layouts and minimal resource usage
- Notifications auto-cleanup to prevent memory leaks
- Smooth animations enhance user experience without lag

## 📱 Mobile Compatibility

The UI is designed to work on:
- ✅ Desktop/Laptop
- ✅ Mobile devices (responsive design)
- ✅ Tablet devices

## 🔄 Updates & Versions

### Version 1.0 Features
- Complete glitch rolling system
- Inventory management
- Code redemption
- Glitch index
- Sound effects
- Notification system
- Modern UI design

### Planned Features
- Potion system (framework already included)
- Trading system
- Daily rewards
- Achievement system
- Particle effects for rare glitches

## 📄 License

This project is provided as-is for educational and entertainment purposes. Feel free to modify and use in your Roblox games.

## 🤝 Contributing

Want to improve the game? Suggestions for new features:
- Additional glitch types
- New UI themes
- Enhanced animations
- Multiplayer features
- Economy balancing

---

**Created for Roblox Studio** | **LocalScript Required** | **No External Dependencies**