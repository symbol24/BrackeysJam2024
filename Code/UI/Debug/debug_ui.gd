extends Control

func _ready() -> void:
	Signals.ToggleUi.connect(_toggle_debug)
	if GM.debug: _toggle_debug(true)
	else: _toggle_debug(false)

func _toggle_debug(_value:bool) -> void:
	set_deferred("visible", _value)
