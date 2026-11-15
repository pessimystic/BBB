extends Node2D
## Main scene controller: starts rounds and spawns batteries and sparks.

const BatteryScene: PackedScene = preload("res://scenes/battery.tscn")
const SparkScene: PackedScene = preload("res://scenes/spark.tscn")
const PLAYER_START := Vector2(240, 230)
const MAX_SPARKS := 4

@onready var platforms: Array[Node] = $Platforms.get_children()
@onready var items: Node2D = $Items
@onready var foes: Node2D = $Foes
@onready var player: Player = $Player

var over_ms := 0


func _ready() -> void:
	randomize()
	Game.state_changed.connect(_on_state_changed)


func _input(event: InputEvent) -> void:
	var kind_ok := event is InputEventKey or event is InputEventMouseButton or event is InputEventScreenTouch
	if not kind_ok or not event.is_pressed() or event.is_echo():
		return
	if Game.state == Game.State.PLAYING:
		return
	if Game.state == Game.State.OVER and Time.get_ticks_msec() - over_ms < 400:
		return
	start_round()


func start_round() -> void:
	for n in items.get_children():
		n.queue_free()
	for n in foes.get_children():
		n.queue_free()
	player.reset(PLAYER_START)
	Game.start()
	spawn_battery()
	spawn_battery()


func spawn_battery() -> void:
	if Game.state != Game.State.PLAYING:
		return
	var p := platforms.pick_random() as PlatformBody
	var b: Battery = BatteryScene.instantiate()
	b.position = p.position + Vector2(20.0 + randf() * (p.size.x - 40.0), -16.0)
	items.add_child(b)
	b.collected.connect(_on_battery_collected)
	b.expired.connect(spawn_battery)


func spawn_foe() -> void:
	var p := platforms.slice(1).pick_random() as PlatformBody
	var s: Spark = SparkScene.instantiate()
	s.min_x = p.position.x + 5.0
	s.max_x = p.position.x + p.size.x - 5.0
	s.position = Vector2(randf_range(s.min_x, s.max_x), p.position.y - 5.0)
	s.speed = minf(120.0, 48.0 + Game.score * 1.8)
	foes.add_child(s)


func _on_battery_collected() -> void:
	Game.collect_battery()
	spawn_battery()
	if Game.score % 3 == 0 and foes.get_child_count() < MAX_SPARKS:
		spawn_foe()


func _on_state_changed(new_state: int) -> void:
	if new_state == Game.State.OVER:
		over_ms = Time.get_ticks_msec()
		for f in foes.get_children():
			f.set_process(false)
