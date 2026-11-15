extends Node
## Autoload "Game": holds the global game state, battery, score and best score.

signal battery_changed(value: float)
signal score_changed(value: int)
signal state_changed(new_state: int)

enum State { START, PLAYING, OVER }

const SAVE_PATH := "user://best.dat"
const BATTERY_GAIN := 22.0

var state: State = State.START
var battery := 100.0
var score := 0
var best := 0


func _ready() -> void:
	_add_action(&"move_left", [KEY_LEFT, KEY_A])
	_add_action(&"move_right", [KEY_RIGHT, KEY_D])
	_add_action(&"jump", [KEY_SPACE, KEY_UP, KEY_W])
	if FileAccess.file_exists(SAVE_PATH):
		var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
		best = f.get_32()


func _add_action(action: StringName, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for k in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = k as Key
		InputMap.action_add_event(action, ev)


func start() -> void:
	battery = 100.0
	score = 0
	state = State.PLAYING
	battery_changed.emit(battery)
	score_changed.emit(score)
	state_changed.emit(state)


## Battery drain per second. Gets harsher as the score goes up.
func drain_rate() -> float:
	return minf(21.0, 5.4 + score * 0.36)


func _process(delta: float) -> void:
	if state != State.PLAYING:
		return
	battery = maxf(0.0, battery - drain_rate() * delta)
	battery_changed.emit(battery)
	if battery <= 0.0:
		_finish()


func collect_battery() -> void:
	battery = minf(100.0, battery + BATTERY_GAIN)
	score += 1
	battery_changed.emit(battery)
	score_changed.emit(score)


func damage(amount: float) -> void:
	if state != State.PLAYING:
		return
	battery = maxf(0.0, battery - amount)
	battery_changed.emit(battery)
	if battery <= 0.0:
		_finish()


func _finish() -> void:
	state = State.OVER
	if score > best:
		best = score
		var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		f.store_32(best)
	state_changed.emit(state)
