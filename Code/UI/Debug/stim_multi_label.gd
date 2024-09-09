extends Label

func _ready() -> void:
	Signals.StimMultiplierUpdated.connect(_update_text)

func _update_text(_value:float) -> void:
	text = "%10.2f" % _value
