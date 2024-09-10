extends Label

func _ready() -> void:
	Signals.PlayerHpUpdated.connect(_update_text)

func _update_text(_value:int) -> void:
	text = "Player HP: %s" % _value
