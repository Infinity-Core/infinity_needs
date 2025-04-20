# infinity_needs - RedM Needs, Inventory & Metabolism System

Advanced needs, inventory, and metabolism module for RedM, developed by Shepard & iiRedDev (ALTITUDE-DEV.COM). Designed for seamless integration with Infinity Core.

## ✨ Main Features

- Player needs system: hunger, thirst, sleep, temperature, health
- Fully integrated inventory system (items, weight, drag & drop)
- Metabolism and survival mechanics (damage, limits, tick timers)
- Payday, salary, XP and gold reward system
- Ammo, clips, and weapon management
- Admin inventory controls (reset, inspect, add/remove items)
- Modern web UI for inventory (inventory/inventory.html)
- Database integration (requires oxmysql)
- Exports for metabolism and inventory management

## 📦 Installation

1. Place this folder in your server's `resources` directory.
1.5. In the inventory folder, make sure to fully extract the .rar file — it contains the images inventory
2. Add the resource to your `server.cfg`:
   ```
    ensure oxmysql              # Module SQL
    ensure infinity_core          # Module Framework core
    ensure infinity_skin          # Module Skin (skins)
    ensure infinity_chars         # Module Multichars (verif accounts and multichars)
    
    ensure infinity_needs         # Module Metabolism, inventory (inventory and metabolism)
   ```
3. Make sure [oxmysql](https://github.com/overextended/oxmysql) is installed and started before this script.
4. Configure the files as needed.

## ⚙️ Configuration

- Main scripts:
  - `module_client/cl_inventory.lua`, `cl_foods.lua`, `cl_gunsystem.lua` (client logic)
  - `module_server/sv_inventory.lua`, `sv_payday.lua` (server logic)
  - `config.lua` (main configuration)
- User interface: `inventory/`

## 🛠 Contribution

Contributions are welcome!
Please create an issue or pull request for any suggestion or improvement.

## 🤝 Support & Links

- Documentation: [https://altitude-dev.gitbook.io/doc/](https://altitude-dev.gitbook.io/doc/)
- Discord support: [https://discord.gg/ncH7GX3XJd](https://discord.gg/ncH7GX3XJd)
- Authors: Shepard, iiRedDev

---

> Module licensed by ALTITUDE-DEV.COM. Any unauthorized reproduction or distribution is prohibited.
