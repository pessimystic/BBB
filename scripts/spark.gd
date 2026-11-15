class_name Spark
extends Area2D
## Pink spark that patrols a platform and drains the battery on contact.

const DAMAGE := 18.0

@export var min_x := 0.0
@export var max_x := 100.0
@export var speed := 48.0
@export var dir := 1.0

var blink := 0.0


func _ready() -> void:
    dir = -1.0 if randf() < 0.5 else 1.0
    body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
    position.x += dir * speed * delta
    if position.x < min_x:
        position.x = min_x
        dir = 1.0
    elif position.x > max_x:
        position.x = max_x
        dir = -1.0
    blink += delta
    queue_redraw()


func _on_body_entered(body: Node) -> void:
    if body is Player and (body as Player).take_hit():
        Game.damage(DAMAGE)


func _draw() -> void:
    var pink := Color("#ff4fd8")
    draw_rect(Rect2(-5, -2, 10, 4), pink)
    draw_rect(Rect2(-2, -5, 4, 10), pink)
    draw_rect(Rect2(-1, -1, 2, 2), Color.WHITE)
    if int(blink * 10.0) % 2 == 1:
        draw_rect(Rect2(-4, -4, 2, 2), Color("#ffd0f4"))
        draw_rect(Rect2(2, 2, 2, 2), Color("#ffd0f4"))
