extends ProgressBar


func _ready() -> void:
	Signals.StimulationUpdated.connect(_update_value)

func _update_value(_value:float) -> void:
	value = _value
