class_name SheetFrames
extends RefCounted
## Builds SpriteFrames from the 128x160 sprite sheet (4 frames per row, 32x32 cells).
## Rows: 0 full, 1 mid, 2 low, 3 empty battery robot, 4 battery pickup.

const SHEET: Texture2D = preload("res://assets/robot_sheet_32.png")
const CELL := 32
const STATES := ["full", "mid", "low", "empty"]


static func _atlas(col: int, row: int) -> AtlasTexture:
	var t := AtlasTexture.new()
	t.atlas = SHEET
	t.region = Rect2(col * CELL, row * CELL, CELL, CELL)
	return t


static func robot_frames() -> SpriteFrames:
	var f := SpriteFrames.new()
	f.remove_animation(&"default")
	for row in STATES.size():
		var s: String = STATES[row]
		var idle := StringName(s + "_idle")
		var walk := StringName(s + "_walk")
		var jump := StringName(s + "_jump")
		f.add_animation(idle)
		f.set_animation_loop(idle, true)
		f.add_frame(idle, _atlas(0, row))
		f.add_animation(walk)
		f.set_animation_speed(walk, 8.0)
		f.set_animation_loop(walk, true)
		for col in 4:
			f.add_frame(walk, _atlas(col, row))
		f.add_animation(jump)
		f.set_animation_loop(jump, true)
		f.add_frame(jump, _atlas(1, row))
	return f


static func battery_frames() -> SpriteFrames:
	var f := SpriteFrames.new()
	f.remove_animation(&"default")
	f.add_animation(&"spin")
	f.set_animation_speed(&"spin", 5.0)
	f.set_animation_loop(&"spin", true)
	for col in 4:
		f.add_frame(&"spin", _atlas(col, 4))
	return f
