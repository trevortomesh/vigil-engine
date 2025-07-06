# 🔧 The Vigil Engine

![logo](/img/logo.png)

**The Vigil Engine** is a lightweight Lua/LÖVE-based roguelike engine designed for building atmospheric, choice-rich horror games with ease.

<p align="center">
  <img alt="Love2D" src="https://img.shields.io/badge/LÖVE-11.x-ff69b4?logo=love&logoColor=white&style=flat-square"/>
  <img alt="Vibe-Coded" src="https://img.shields.io/badge/Vibe%20Coded-%F0%9F%92%8C-purple?style=flat-square"/>
  <a href="https://github.com/trevortomesh/fearfully-coded">
    <img alt="Fearfully Coded" src="https://img.shields.io/badge/🕊️Fearfully%20Coded-blue?style=flat-square"/>
  </a>
</p>

---

## 🚀 Quickstart

### 1. Install LÖVE

Download and install [LÖVE](https://love2d.org) for your OS.

### 2. Clone the repository

```bash
git clone https://github.com/yourusername/vigil-engine.git
```

### 3. Run the engine

```bash
love vigil-engine
```

---

## 📁 Project Structure

```
vigil-engine/
├── assets/         # Game assets (sound, fonts, music)
├── data/           # Game data (items, world, etc.)
├── engine/         # Core engine modules (map loader, status)
├── img/            # Images, including logo.png
├── maps/           # ASCII map files
├── conf.lua        # LÖVE window config
├── main.lua        # Engine entry point and game loop
├── settings.lua    # Runtime tuning (floating-text colors, speeds)
├── README.md       # This file
└── vigil2          # An early experimental engine with carts
```

---

## 🛠️ How to Use

### 🌍 World Table Format

The heart of the engine is the World Table data structure, found in `data/world.lua`.

This file defines all the playable maps in your game world, along with player
start position, map exits, and interactive events.

```lua
return {
    start = {
        map = "church1",                     -- ID of the starting map
        position = { x = 18, y = 5 }         -- Starting coordinates of the player
    },

    mapId = {
        file = "maps/mapname.txt",           -- Path to the map's text layout file
        exits = {
            { x = X, y = Y, map = "otherMapId", spawn = { x = X, y = Y } }
            -- Teleport the player when they walk onto this tile
        },
        events = {
            {
                type = "dialog" or "floating_text", -- Event type
                x = X, y = Y,                        -- Trigger location
                text = "Message to display",         -- Dialog or floating message
                once = true or false,                -- Whether it only triggers once
                color = {r, g, b} (optional)         -- Color for floating text
            }
        }
    }
```

📌 NOTES FOR CUSTOMIZATION:

* To add a new map:

  1. Create an ASCII map file in the `maps/` folder (e.g., `graveyard.txt`).
  2. Add a new entry to this table with a unique key (e.g., "graveyard").
  3. Define any `exits` or `events` within that map.

* To change the starting location:

  * Modify the `start.map` and `start.position` fields at the top of the file.

* To add an exit between maps:

  * Add an entry under `exits` for each map that needs to connect.
  * Remember: exits are one-way unless you define them both directions.

* To add a floating text or dialog event:

  * Add an `event` table at the desired `x, y` location.
  * Use `type = "dialog"` to pause the game with a message box.
  * Use `type = "floating_text"` to show a short-lived message on screen.
  * Set `once = true` to have it trigger only once per game session.

* All coordinates (x, y) are based on tile positions (not pixels).

* Map IDs must match the key used in this table and the file name in `maps/`.

🛠 EXAMPLE:

```lua
    garden = {
        file = "maps/garden.txt",
        exits = {
            { x = 10, y = 1, map = "church1", spawn = { x = 5, y = 8 } }
        },
        events = {
            {
                type = "floating_text",
                x = 6, y = 4,
                text = "You hear bees humming nearby.",
                once = false,
                color = {1, 1, 0.5}
            }
        }
    }
```

---

## ✅ TODOs for Vigil Engine Development

* NPC System

  * Friendly NPCs with dialog trees
  * Hostile NPCs with pathfinding and basic combat AI
* Combat System

  * Basic attack mechanics (melee, ranged)
  * Enemy health/status
  * Weapon/item integration
* Inventory Enhancements

  * Equip slots (weapon, armor, relic)
  * Item stacking and weight system
  * Crafting or combining items
* Save/Load System

  * Persistent game state (player stats, map state, items)
  * Save checkpoints or manual save/load
* Audio System

  * Ambient sounds per map
  * Music triggers (event-based or map-based)
  * SFX for movement, combat, dialog, pickups
* Lighting & Vision

  * Basic fog-of-war / visibility radius
  * Light sources (torches, candles, etc.)
  * Hidden areas revealed via light
* Status Effect System

  * Temporary buffs/debuffs (e.g. fear drain, poison, bless)
  * Visual indicators for active effects
* Dynamic Events System

  * Timed or chained events (e.g. doors open after dialog)
  * Environmental triggers (pressure plates, puzzles)
* Lore & Codex System

  * Collectible journal pages or entries
  * Optional hidden story elements
* Cutscene Engine

  * Simple script-based cutscenes (text, camera pan, NPC move)
  * Event chaining for scripted intros/outros
* Title Screen / Main Menu

  * New game, continue, settings
  * Stylized splash/logo display
* Credits Roll System

  * Scroll or animated ending screen with credits
  * Optional “true ending” reveal based on player status
* Controller Support

  * Gamepad input mapping
  * Dynamic prompts based on input device
* Modding Support

  * Hot-reload maps/events
  * External file parsing (JSON or Lua sandboxing)
* Debug Console

  * In-game console for teleporting, adding items, setting statuses

---
## What’s Vigil2?

Vigil2 is a little side experiment that allows you to build rich, narrative-driven tile-based games using nothing but a single .vc file. The core idea is cartridge simplicity: you drop a .vc “virtual cart” into the CartSlot folder, and the engine loads it—no extra assets, no code changes, just pure data-driven storytelling.

Vigil2 is inspired by old-school cartridge systems and minimalist design. Rooms, NPCs, dialogue, and logic are all defined inline using a lightweight, human-readable format. The engine parses this structure and handles rendering, navigation, dialog, and interaction—all with a minimal Lua/LÖVE codebase.

VERY MINIMAL. BARELY DOES ANYTHING!


## 📄 License

### Vigil Public License (VPL-1.0)

Copyright (c) 2025 Trevor Tomesh

Permission is hereby granted to any individual or organization to use, study, and modify this software for non-commercial, non-malicious, and non-distributive purposes, subject to the following conditions:

✅ You MAY:

* Use and run the software for personal, educational, or research purposes.
* Modify the code for personal or internal use.
* Share feedback, ideas, or improvements with the original author.
* Submit contributions to the project via pull request, under the same license.

❌ You MAY NOT:

* Sell, sublicense, or distribute this software or derivatives, in part or in full.
* Use this software or its assets in any commercial or for-profit product or service.
* Rebrand or misrepresent this software as your own work.
* Use this software for any unlawful, harmful, or deceptive purposes.

⚖️ Additional Terms:

* All copies or substantial portions of the Software must retain this license and copyright notice.
* This software is provided “as is”, without warranty of any kind, express or implied.
* The author reserves the right to relicense future versions under different terms.

For commercial licensing, redistribution inquiries, or collaboration requests, please contact: [tmtomesh@hotmail.com](mailto:tmtomesh@hotmail.com)

---

## ✨ Credits

* Engine by: Trevor Tomesh
* Logo: Designed for The Vigil Engine
* Built with: [LÖVE](https://love2d.org), Lua

---

## 🕊️ Dedication

This project is dedicated to the Lord.

All logic, structure, and order — including the very foundations of programming — reflect the perfection of His design. May this tool, in its small way, point toward the beauty and coherence He has written into the fabric of creation.

> “I praise you, for I am fearfully and wonderfully made.
> Wonderful are your works; my soul knows it very well.”
> — Psalm 139:14

**Soli Deo Gloria.**

> “And through the shadows, light endures.”
