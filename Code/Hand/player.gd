class_name Player extends Node2D

var current_hp:int = 100:
	set(_value):
		current_hp = max(0, _value)
		Signals.PlayerHpUpdated.emit(current_hp)
		if current_hp == 0:
			Signals.PlayerDefeated.emit("hp_zero")


func _ready() -> void:
	Signals.CatAttack.connect(_receive_damage)
	Signals.StormAttack.connect(_receive_damage)
	await get_tree().create_timer(0.1).timeout
	Signals.PlayerHpUpdated.emit(current_hp)


func _receive_damage(_value:int) -> void:
	current_hp -= _value
