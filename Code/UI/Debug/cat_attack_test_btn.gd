extends Button


func _pressed() -> void:
	Signals.CatAttack.emit(randi_range(1, 10))
