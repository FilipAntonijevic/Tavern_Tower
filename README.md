# Tavern Tower

Tavern Tower is a single‑player roguelike solitaire game for desktop, built in Godot. The project is a solo effort — all game design, programming, artwork, music and sound effects were created by me. The game combines classic solitaire mechanics with roguelike progression: clear levels, earn gold, and spend it on card upgrades.
There is also Legacy mode, that offers a pure, traditional, solitaire experience.

---

## Features
- Two game modes:
  - **Roguelike (Default)** — clear progressively harder levels, earn gold after each successful level, and spend gold in the shop on card upgrades and bonuses.
  - **Legacy** — classic solitaire deal/opening without roguelike progression; ideal for quick games or testing mechanics.
- Solo-developed: code, visuals, music and sound design by the author.
- Minimalist, tactical design tuned for short sessions and replayability.
- Configurable difficulty progression and upgrade system.
- Desktop builds (exported from Godot).

---

## How to play
- Objective: complete the current level by reaching a certain score, clearing cards according to the solitaire rules used in the game. Completing a level advances you to the next, more challenging stage.
- Roguelike progression: after finishing a level you receive gold. Between levels you can visit the shop to purchase upgrades that alter card behavior, provide bonuses, or unlock persistent improvements.
- Legacy mode: select Legacy to play a straightforward solitaire round without economy or upgrades.

(Controls and exact rules depend on the chosen variant — see in‑game Help or Controls screen for precise keybindings.)

---

## Installation & Running (development)

Windows

Download Tavern_Tower.zip.
Extract the .zip (right‑click → Extract/Extract All or use 7‑Zip).
Open the extracted Tavern_Tower folder.
Double‑click Tavern_tower.exe to run.

Linux — running the Windows .exe with Wine

Install Wine (example commands):
    Ubuntu/Debian: sudo apt update && sudo apt install wine64 winetricks -y
    Fedora: sudo dnf install wine
    Arch: sudo pacman -S wine
Extract and enter the folder:
    unzip Tavern_Tower.zip
    cd Tavern_Tower
Run the Windows executable with Wine:
    wine Tavern_tower.exe


