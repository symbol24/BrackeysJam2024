extends Label


func _ready() -> void:
	Signals.BeingPet.connect(_update_text)

func _update_text(_value:bool) -> void:
	if _value: text = "TRUE"
	else: text = "FALSE"
