extends Label

func _ready() -> void:
	Signals.MoodMultiplierUpdated.connect(_update_text)

func _update_text(_value:float) -> void:
	text = "Mood multi: %s" % _value
