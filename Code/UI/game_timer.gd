class_name GameTimer extends Label


func _ready() -> void:
	Signals.GameTimerUpdated.connect(_update_text)


func _update_text(_value:float) -> void:
	text = GM.get_time_string(_value)
