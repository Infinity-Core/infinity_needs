Config  = {}

--- 
-- CORE
---
Config.Debug                = false  -- Only for devs
Config.AntiFloodSQL         = 655    -- Do not change this var
Config.AntiFloodSQL2        = 355    -- Do not change this var
Config.ERROR                = "Error"
Config.Lang_Nopermission    = "No permissions"
Config.NotFind              = "Player is offline"
Config.ItemModelDroped      = "p_bag01x"
Config.Str                  = 'Get Loot'

-- Metabolism --
Config.LowTemperatureLimit  = -18    -- Temp limit to make damages
Config.TemperatureExtreme   = true   -- Make damage for player is in are in -18° or > -18°
Config.TickDrink            = 90000  -- -1% Water
Config.DMGDrink             = 5      -- Player receive 5 tick dmg
Config.TickEat              = 120000 -- -1% Eat
Config.DMGEat               = 5      -- Player receive 5 tick dmg
Config.TickTemperature      = 15000  -- Every time tick s
Config.DMGTEMP              = 5      -- Player receive 5 tick dmg
Config.TickSleep            = 200000 -- -1% Rest

-- Payday --
Config.PaydayTimer          = 1200000 -- Set Time to get Salary 20min
Config.PaydaySalary         = 50      -- How $ to send to player after x time payday ?
Config.PaydayXP             = 25      -- How XP send to player after x time payday ?
Config.PaydayGolds          = 0       -- Gold Send

-- Ammo and clips --
Config.AmmoLoad             = 50     -- Ammo load in weapon with clip
Config.AmmoClipMade         = 50     -- Ammo single for made clip

-- Weight and security --
Config.MaxWeight            = 65     -- Max Weight
Config.MaxSendItems         = 650    -- Max Item sended in same time (security)

--- 
-- CORE ADMIN PERM (Needs set perms)
---
Config.ResetInventoryPerm   = "superadmin"
Config.InspectInventory     = "superadmin"
Config.AddItemPerm          = "superadmin"
Config.RemoveItemPerm       = "superadmin"