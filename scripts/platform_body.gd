class_name PlatformBody
extends StaticBody2D
## A platform. Node position is its top-left corner. Set size per instance.

@export var size := Vector2(110, 8)
@export var one_way := true
@export var body_color := Color("#4b54a3")
@export var top_color := Color("#8f9af0")


func _ready() -> void:
    var shape := RectangleShape2D.new()
    shape.size = size
    var cs: CollisionShape2D = $CollisionShape2D
    cs.shape = shape
    cs.position = size / 2.0
    cs.one_way_collision = one_way
    queue_redraw()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), body_color)
    draw_rect(Rect2(Vector2.ZERO, Vector2(size.x, 2)), top_color)
