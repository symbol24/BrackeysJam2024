extends Button

func _pressed() -> void:
	Signals.StormAttack.emit(100)
