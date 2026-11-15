# Low Battery (Godot 4.2+)

Open `project.godot` in Godot, then press F5.
Move: arrows / A D. Jump: Space / Up / W. Press any key to start.

## Scene tree (scenes/main.tscn)
Main (Node2D, main.gd)
- Background (Node2D, static night city)
- Platforms (Ground + Platform1..5, StaticBody2D with one-way collision)
- Items (batteries spawn here)
- Foes (sparks spawn here)
- Player (CharacterBody2D + CollisionShape2D + AnimatedSprite2D)
- HUD (CanvasLayer: BatteryBar, ScoreLabel, Overlay)

## Scenes
player, battery (Area2D + Timer + CPUParticles2D), spark (Area2D), platform, background, hud, main

## Scripts
game.gd (autoload "Game": state, battery, score, best, input actions), main.gd, player.gd, battery.gd,
spark.gd, platform_body.gd, background.gd, hud.gd, sheet_frames.gd (builds animations from the sprite sheet)

## Physics layers
1 world, 2 player, 3 pickups, 4 hazards

## Tuning
game.gd: drain_rate(), BATTERY_GAIN. spark.gd: DAMAGE. battery.tscn: LifeTimer wait_time. main.gd: MAX_SPARKS.
