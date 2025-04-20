# infinity_needs - Système de besoins, inventaire & métabolisme RedM

Module avancé de gestion des besoins, de l’inventaire et du métabolisme pour RedM, développé par Shepard & iiRedDev (ALTITUDE-DEV.COM). Conçu pour une intégration parfaite avec Infinity Core.

## ✨ Fonctionnalités principales

- Système de besoins joueur : faim, soif, sommeil, température, santé
- Inventaire complet (items, poids, drag & drop)
- Mécaniques de survie et métabolisme (dégâts, limites, timers)
- Système de paie, salaire, XP et gold
- Gestion des munitions, chargeurs et armes
- Contrôles admin sur l’inventaire (reset, inspecter, ajouter/retirer)
- Interface web moderne pour l’inventaire (inventory/inventory.html)
- Intégration base de données (oxmysql requis)
- Exports pour la gestion du métabolisme et de l’inventaire

## 📦 Installation

1. Placez ce dossier dans `resources` de votre serveur RedM.
2. Ajoutez la ressource à votre `server.cfg` :
   ```
    ensure oxmysql              # Module SQL
    ensure infinity_core          # Module Framework core
    ensure infinity_skin          # Module Skin (skins)
    ensure infinity_chars         # Module Multichars (verif accounts and multichars)
    
    ensure infinity_needs         # Module Metabolism, inventory (inventory and metabolism)
   ```
3. Assurez-vous que [oxmysql](https://github.com/overextended/oxmysql) est installé et lancé avant ce script.
4. Configurez les fichiers selon vos besoins.

## ⚙️ Configuration

- Scripts principaux :
  - `module_client/cl_inventory.lua`, `cl_foods.lua`, `cl_gunsystem.lua` (logique client)
  - `module_server/sv_inventory.lua`, `sv_payday.lua` (logique serveur)
  - `config.lua` (configuration principale)
- Interface utilisateur : `inventory/`

## 🛠 Contribution

Toute contribution est la bienvenue !
Merci de créer une issue ou une pull request pour toute suggestion ou amélioration.

## 🤝 Support & liens

- Documentation : [https://altitude-dev.gitbook.io/doc/](https://altitude-dev.gitbook.io/doc/)
- Discord support : [https://discord.gg/ncH7GX3XJd](https://discord.gg/ncH7GX3XJd)
- Auteurs : Shepard, iiRedDev

---

> Module sous licence ALTITUDE-DEV.COM. Toute reproduction ou distribution non autorisée est interdite.
