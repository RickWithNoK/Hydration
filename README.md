# Hydration Game

A SwiftUI iOS app that gamifies daily water intake tracking. Log drinks, grow your Hydra pet, maintain streaks, and complete daily quests — all persisted with SwiftData.

---

## Features

### Home
- Log water with preset buttons: **250 ml**, **500 ml**, **1000 ml**
- Enter a **custom amount** via a text field
- **Undo** the last logged drink
- Progress bar showing % of daily goal reached
- **Set a custom daily goal** (default: 2000 ml) via an editor sheet
- Auto-resets intake at the start of each new day

### Stats
- Current water intake and daily goal with % progress
- Current and best streak (in days)
- Hydra boost multiplier derived from streak
- **7-day bar chart** of daily intake vs. goal line (Swift Charts)
- **7-day rolling average** intake
- **All-time total** water ever logged
- Last updated timestamp

### Pet (Hydra)
- A Hydra that **grows more heads** as you drink more water
- Head count scales via a square-root curve using boosted water
- **Mood system**: thirsty → sleepy → content → ecstatic
- **Streak boost** (up to 2×): more consecutive days = faster hydra growth
- Milestone messages at 3, 7, 14, and 30-day streaks

### Quests
- Three daily quests that **scale with your custom goal** (25%, 50%, 100%)
- Checkmark indicators per quest
- Overall completion progress bar
- "All quests completed!" banner

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI |
| Persistence | SwiftData (`@Model`) |
| Minimum Target | iOS 17+ |
| Language | Swift 5.9+ |

---

## Project Structure

```
Hydration Game/
├── Hydration_GameApp.swift   # App entry point, SwiftData container setup
├── ContentView.swift         # Root TabView (Home, Stats, Pet, Quest)
├── HomeView.swift            # Water logging, goal setting, undo, reset
├── StatsView.swift           # Read-only stats summary
├── PetView.swift             # Hydra pet visuals and mood/streak display
├── QuestView.swift           # Daily quests scaled to user goal
└── WaterData.swift           # SwiftData model — all persisted state
```

---

## Getting Started

1. Clone the repo and open `Hydration Game.xcodeproj` in **Xcode 15+**
2. Select an iOS 17+ simulator or a physical device
3. Build and run (`⌘R`)

No external dependencies or package manager setup required.

---

## Streak Rules

- A streak increments when you hit your daily goal on **consecutive calendar days**
- Missing a day resets the streak to 1 on the next goal hit
- Hitting the goal multiple times in the same day only counts once
- Best streak is preserved across resets
