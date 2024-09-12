class_name ResultScreen extends SMenuControl

@export var failure_jingle:AudioFile
@export var result_screen_music:AudioFile

@onready var result: Label = %result
@onready var return_btn: Button = %return_btn


func _ready() -> void:
	super()
	Signals.PlayerDefeated.connect(_update_result_text)
	return_btn.pressed.connect(_return_pressed)
	return_btn.position = (Vector2(UI.width, UI.height)*0.95) - return_btn.size


func _update_result_text(_value:String) -> void:
	result.text = _value


func _return_pressed() -> void:
	UI.ToggleUi.emit("main_menu", true, id)


func _toggle_control(_id:String, _value:bool, _previous:String = "") -> void:
	if id == "":
		push_error(name, " does not have an id set.")
	else:
		UI.previous_menu = _previous
		if _id == id:
			set_deferred("visible", _value)
			Audio.play_audio(failure_jingle)
			Audio.play_audio(result_screen_music)
		else:
			set_deferred("visible", false)
