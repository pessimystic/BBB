class_name Player
extends CharacterBody2D
## The robot. Sprite and speed change with the battery level.

const SPEED := 144.0
const LOW_SPEED := 90.0
const JUMP_VELOCITY := -540.0
const GRAVITY := 1800.0
const HURT_TIME := 1.2

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var hurt_time := 0.0


func _ready() -> void:
	sprite.sprite_frames = SheetFrames.robot_frames()
	sprite.play(&"full_idle")


func reset(at: Vector2) -> void:
	position = at
	velocity = Vector2.ZERO
	hurt_time = 0.0
	sprite.modulate.a = 1.0


## Called by sparks. Returns true if the hit landed (not invulnerable).
func take_hit() -> bool:
	if hurt_time > 0.0 or Game.state != Game.State.PLAYING:
		return false
	hurt_time = HURT_TIME
	velocity.y = -360.0
	return true


func _physics_process(delta: float) -> void:
	var playing := Game.state == Game.State.PLAYING
	var dir := Input.get_axis(&"move_left", &"move_right") if playing else 0.0
	velocity.x = dir * (LOW_SPEED if Game.battery < 15.0 else SPEED)
	if dir != 0.0:
		sprite.flip_h = dir < 0.0
	velocity.y += GRAVITY * delta
	if is_on_floor() and playing and Input.is_action_pressed(&"jump"):
		velocity.y = JUMP_VELOCITY
	move_and_slide()
	position.x = clampf(position.x, 8.0, 472.0)
	hurt_time = maxf(0.0, hurt_time - delta)
	sprite.modulate.a = 0.35 if (hurt_time > 0.0 and int(hurt_time * 15.0) % 2 == 0) else 1.0
	_update_animation()


func _update_animation() -> void:
	var prefix := "empty"
	if Game.state != Game.State.OVER:
		prefix = "full" if Game.battery > 66.0 else ("mid" if Game.battery > 33.0 else "low")
	var suffix := "idle"
	if not is_on_floor():
		suffix = "jump"
	elif absf(velocity.x) > 1.0:
		suffix = "walk"
	var anim := StringName(prefix + "_" + suffix)
	if sprite.animation != anim:
		sprite.play(anim)
