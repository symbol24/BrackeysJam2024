class_name GameTimer extends Label


func _ready() -> void:
	Signals.GameTimerUpdated.connect(_update_text)


func _update_text(_value:float) -> void:
	text = _get_time_string(_value)


func _get_time_string(_timer := 0.0) -> String:
	var msec := fmod(_timer, 1) * 100
	var sec := fmod(_timer, 60)
	var mins := fmod(_timer, 3600) / 60
	return "%02d:%02d.%03d" % [mins, sec, msec]
