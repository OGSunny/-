# 📋 Clicking Simulator - Installation Guide

## Step-by-Step Setup Instructions

### Prerequisites
- Roblox Studio installed and updated
- Basic knowledge of Roblox Studio interface
- Internet connection for DataStore functionality

---

## 🏗️ Part 1: Project Setup

### 1. Create New Place
1. Open Roblox Studio
2. Create a new Baseplate or Empty template
3. Save your place with a descriptive name (e.g., "Clicking Simulator")

### 2. Enable Required Services
1. Go to **File** → **Game Settings**
2. Navigate to **Security** tab
3. ✅ Enable "Allow HTTP Requests"
4. ✅ Enable "Enable Studio Access to API Services"
5. Click **Save**

---

## 📁 Part 2: Script Installation

### Order Matters! Install in this exact sequence:

#### Step 1: RemoteEvents Setup
1. Right-click **ServerScriptService**
2. Insert → **ServerScript**
3. Rename to `RemoteEventsSetup`
4. Copy contents from `ServerScriptService/RemoteEventsSetup.lua`
5. **Test**: Run the game, check Output for "RemoteEvents created successfully!"

#### Step 2: Shop Configuration
1. Right-click **ReplicatedStorage**
2. Insert → **ModuleScript**
3. Rename to `ShopItems`
4. Copy contents from `ReplicatedStorage/ShopItems.lua`

#### Step 3: Unlock System
1. Right-click **ServerScriptService**
2. Insert → **ServerScript**
3. Rename to `UnlockSystem`
4. Copy contents from `ServerScriptService/UnlockSystem.lua`
5. **Test**: Check Output for "Unlock System loaded!"

#### Step 4: Main Data Service
1. Right-click **ServerScriptService**
2. Insert → **ServerScript**
3. Rename to `PlayerDataService`
4. Copy contents from `ServerScriptService/PlayerDataService.lua`

#### Step 5: Main GUI
1. Right-click **StarterGui**
2. Insert → **LocalScript**
3. Rename to `ClickingSimulatorGUI`
4. Copy contents from `StarterGui/ClickingSimulatorGUI.lua`

#### Step 6: Unlock Notifications
1. Right-click **StarterGui**
2. Insert → **LocalScript**
3. Rename to `UnlockNotifications`
4. Copy contents from `StarterGui/UnlockNotifications.lua`

---

## 🧪 Part 3: Testing

### Initial Test
1. Click **Play** (F5) in Studio
2. You should see:
   - Main GUI with click button
   - Stats panel on the left
   - Shop panel on the right
   - Leaderboard at bottom left

### Functionality Test
1. **Click the main button** - Should see:
   - Button animation
   - Floating "+1" text
   - Stats update
2. **Buy first upgrade** (Better Finger at 10 clicks)
3. **Check achievement** at 100 total clicks

---

## 🔧 Part 4: Troubleshooting

### Common Issues & Solutions

#### ❌ "RemoteEvents not found" Error
**Solution**: Ensure `RemoteEventsSetup` runs first
- Check it's a **ServerScript** in **ServerScriptService**
- Restart the test session

#### ❌ GUI Not Appearing
**Solutions**:
- Verify scripts are **LocalScripts** in **StarterGui**
- Check **ResetOnSpawn** is set to false in GUI properties
- Look for errors in Output window

#### ❌ Shop Items Not Loading
**Solutions**:
- Confirm `ShopItems` is a **ModuleScript** in **ReplicatedStorage**
- Check for syntax errors in the module
- Verify return statement exists

#### ❌ Data Not Saving
**Solutions**:
- Enable API Services in Game Settings
- Publish your game (File → Publish to Roblox)
- DataStore only works in published games, not Studio testing

#### ❌ Achievements Not Working
**Solutions**:
- Ensure `UnlockSystem` loads before `PlayerDataService`
- Check for `_G.CheckUnlocks` function availability
- Verify UnlockRemote exists in RemoteEvents

---

## 📊 Part 5: Verification Checklist

### ✅ File Structure Check
```
ServerScriptService/
├── ✅ RemoteEventsSetup (ServerScript)
├── ✅ UnlockSystem (ServerScript)
└── ✅ PlayerDataService (ServerScript)

ReplicatedStorage/
└── ✅ ShopItems (ModuleScript)

StarterGui/
├── ✅ ClickingSimulatorGUI (LocalScript)
└── ✅ UnlockNotifications (LocalScript)
```

### ✅ Functionality Check
- [ ] Click button responds with animation
- [ ] Stats update correctly
- [ ] Shop items show proper prices
- [ ] First upgrade purchasable at 10 clicks
- [ ] Auto-clickers work when purchased
- [ ] Achievement notification at 100 clicks
- [ ] Leaderboard shows player name

---

## 🎨 Part 6: Customization (Optional)

### Quick Customizations

#### Change Click Button Color
In `ClickingSimulatorGUI.lua`, find:
```lua
clickButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
```
Change RGB values for different colors.

#### Adjust First Upgrade Price
In `ShopItems.lua`, modify:
```lua
basePrice = 10,  -- Change this value
```

#### Add Your Own Achievement
In `UnlockSystem.lua`, add to `unlockThresholds`:
```lua
{
    clicks = 250,
    unlock = "myAchievement",
    title = "My Custom Achievement!",
    description = "Reached 250 total clicks!",
    reward = "clickPower",
    rewardValue = 2
}
```

---

## 🚀 Part 7: Publishing

### Final Steps
1. **Test thoroughly** in Studio
2. **File** → **Publish to Roblox**
3. Set game to **Public** or **Friends Only**
4. **Test in actual game** (not Studio) for DataStore functionality

### Post-Launch
- Monitor player feedback
- Check game analytics
- Update balancing as needed
- Add new features gradually

---

## 📞 Support

### If You Need Help
1. **Check Output Window** for error messages
2. **Review this guide** step-by-step
3. **Verify script types** and locations
4. **Test in published game** for DataStore issues

### Success Indicators
- ✅ No errors in Output
- ✅ GUI appears immediately on spawn
- ✅ Clicking works and updates stats
- ✅ Shop purchases function
- ✅ Achievements trigger at milestones

---

**🎉 Congratulations!** Your Roblox Clicking Simulator is now ready for players to enjoy!

---

*Installation Guide v1.0 | Created for Roblox Studio*