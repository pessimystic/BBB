extends CanvasLayer
## Battery bar, score and the start / game over overlay.

@onready var bar: ProgressBar = $BatteryBar
@onready var score_label: Label = $ScoreLabel
@onready var overlay: ColorRect = $Overlay
@onready var title: Label = $Overlay/Box/TitleLabel
@onready var info: Label = $Overlay/Box/InfoLabel
@onready var prompt: Label = $Overlay/Box/PromptLabel


func _ready() -> void:
	Game.battery_changed.connect(_on_battery)
	Game.score_changed.connect(func(_v: int) -> void: _refresh_score())
	Game.state_changed.connect(func(_s: int) -> void: _refresh_overlay())
	_on_battery(Game.battery)
	_refresh_score()
	_refresh_overlay()


func _process(_delta: float) -> void:
	if Game.state == Game.State.PLAYING and Game.battery <= 20.0:
		var on := int(Time.get_ticks_msec() / 250.0) % 2 == 0
		bar.modulate = Color("#f04646") if on else Color("#601c1c")


func _on_battery(value: float) -> void:
	bar.value = value
	if value > 50.0:
		bar.modulate = Color("#46dc6e")
	elif value > 25.0:
		bar.modulate = Color("#ffcd3c")
	elif value > 20.0:
		bar.modulate = Color("#f04646")


func _refresh_score() -> void:
	score_label.text = "Batteries %d   Best %d" % [Game.score, Game.best]


func _refresh_overlay() -> void:
	_refresh_score()
	overlay.visible = Game.state != Game.State.PLAYING
	if Game.state == Game.State.START:
		title.text = "LOW BATTERY"
		title.add_theme_color_override("font_color", Color("#ffde46"))
		info.text = "haha I Think I'm Dying.\nBut Thats Okay .\n BMO Always Bounces Back."
		prompt.text = "Press any key to start"
	elif Game.state == Game.State.OVER:
		title.text = "Nhnn Not This Time"
		title.add_theme_color_override("font_color", Color("#f04646"))
		info.text = "Batteries collected: %d   Best: %d" % [Game.score, Game.best]
		prompt.text = "Press any key to recharge"
