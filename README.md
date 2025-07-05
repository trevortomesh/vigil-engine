# 🔧 The Vigil Engine

<p align="center">
  <img src="img/logo.png" alt="The Vigil Engine Logo" width="400"/>
</p>

<p align="center">
  <img alt="Love2D" src="https://img.shields.io/badge/LÖVE-11.x-ff69b4?logo=love&logoColor=white&style=flat-square"/>
  <img alt="Vibe-Coded" src="https://img.shields.io/badge/Vibe%20Coded-%F0%9F%92%8C-purple?style=flat-square"/>
  <a href="https://github.com/trevortomesh/fearfully-coded">
    <img alt="Fearfully Coded" src="https://img.shields.io/badge/%F0%9F%95%8A%EF%B8%8FFearfully%20Coded-blue?style=flat-square"/>
  </a>
</p>

The Vigil Engine is a lightweight Lua/LÖVE-based roguelike engine designed for building atmospheric, choice-rich horror games with ease.

Features:

* Coordinate-based map loading
* Dialog and floating-text event triggers
* Inventory with dynamic item keybinding and usage
* Extendable status, music, animation, and exit logic

---

🚀 Quickstart

1. **Install LÖVE**

Download and install [LÖVE](https://love2d.org) for your OS.

2. **Clone the repository**

```bash
git clone https://github.com/yourusername/vigil-engine.git
```

3. **Run the engine**

```bash
love vigil-engine
```

---

📁 Project Structure

```text
vigil-engine/
├── assets/         # Game assets (sound, fonts, music)
├── data/           # Game data (items, world, etc.)
├── engine/         # Core engine modules (map loader, status)
├── img/            # Images, including logo.png
├── maps/           # ASCII map files
├── conf.lua        # LÖVE window config
├── main.lua        # Engine entry point and game loop
├── settings.lua    # Runtime tuning (floating-text colors, speeds)
└── README.md       # This file
```

---

🛠️ How to Use

## 🌍 World Table Format

The heart of the engine is the World Table data structure, found in `data/world.lua`.

This file defines all the playable maps in your game world, along with player
start position, map exits, and interactive events.

### 🧱 STRUCTURE OVERVIEW:

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

### 📌 NOTES FOR CUSTOMIZATION:

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

### 🛠 EXAMPLE:

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
