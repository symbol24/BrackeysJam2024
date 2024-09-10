extends Node

# Game parameters
var playing:bool = false
var debug:bool = true

# Play timer
var timer_running:bool = false
var game_timer:float = 0.0:
	set(_value):
		game_timer = _value
		Signals.GameTimerUpdated.emit(game_timer)


func _ready() -> void:
	Signals.PettingStarted.connect(_toggle_timer)
	UI.TogglePauseGame.connect(_toggle_pause_game) # TRUE means paused


func _process(_delta: float) -> void:
	if playing:
		if timer_running: game_timer += _delta


func _toggle_timer() -> void:
	if playing: timer_running = not timer_running


func _toggle_pause_game(_value:bool) -> void:
	playing = !_value
	get_tree().paused = _value
