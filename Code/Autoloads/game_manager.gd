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

# No Pet Timer
var no_pet:bool = false:
	set(_value):
		no_pet = _value
		no_pet_delay = randf_range(15, 30)
var no_pet_delay:float = 15.0
var no_pet_timer:float = 0.0:
	set(_value):
		no_pet_timer = _value
		if no_pet_timer >= no_pet_delay:
			no_pet = false
			no_pet_timer = 0.0
			Signals.PlayerDefeated.emit("no_pet")
			

func _ready() -> void:
	Signals.PettingStarted.connect(_toggle_timer)
	Signals.NoPetToggle.connect(_toggle_no_pet)
	Signals.PlayerDefeated.connect(_display_result)
	UI.TogglePauseGame.connect(_toggle_pause_game) # TRUE means paused


func _process(_delta: float) -> void:
	if playing:
		if timer_running: game_timer += _delta
		if no_pet: no_pet_timer += _delta


func _toggle_timer() -> void:
	if playing: timer_running = not timer_running


func _toggle_no_pet(_value:bool) -> void:
	no_pet = _value


func _toggle_pause_game(_value:bool) -> void:
	playing = !_value
	get_tree().paused = _value


func _display_result(_result:String) -> void:
	await Signals.AnimationComplete
	playing = false
	timer_running = false
	Signals.LastRunTime.emit(game_timer)
	UI.ToggleUi.emit("result_screen", true, "result_screen")
	_reset_defaults()


func _reset_defaults() -> void:
	playing = false
	no_pet = false
	no_pet_timer = 0.0
	timer_running = false
	game_timer = 0.0

func get_time_string(_timer := 0.0) -> String:
	var msec := fmod(_timer, 1) * 100
	var sec := fmod(_timer, 60)
	var mins := fmod(_timer, 3600) / 60
	return "%02d:%02d.%03d" % [mins, sec, msec]
