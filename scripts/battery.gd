class_name Battery
extends Area2D
## Collectable battery. Vanishes after its LifeTimer runs out.

signal collected
signal expired

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var life: Timer = $LifeTimer
@onready var particles: CPUParticles2D = $Particles

var done := false


func _ready() -> void:
	sprite.sprite_frames = SheetFrames.battery_frames()
	sprite.play(&"spin")
	body_entered.connect(_on_body_entered)
	life.timeout.connect(_on_expired)


func _process(_delta: float) -> void:
	if not done and life.time_left < 2.0:
		sprite.visible = int(life.time_left * 8.0) % 2 == 0


func _on_body_entered(body: Node) -> void:
	if done or not body.is_in_group("player"):
		return
	done = true
	collected.emit()
	sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	particles.emitting = true
	await get_tree().create_timer(0.7).timeout
	queue_free()


func _on_expired() -> void:
	if done:
		return
	done = true
	expired.emit()
	queue_free()
