extends Node2D

@onready var animator: AnimationPlayer = %animator

var step := 0
var step_running := false


func _input(_event: InputEvent) -> void:
	if Input.is_anything_pressed():
		_skip()


func _ready() -> void:
	animator.animation_finished.connect(_anim_check)
	_start()


func _start() -> void:
	animator.play("godot")


func _anim_check(_anim_name:="") -> void:
	if _anim_name == "godot": animator.play("rid")
	elif _anim_name == "rid": animator.play("epilepsie")
	elif _anim_name == "epilepsie": 
		UI.ToggleUi.emit("main_menu", true, "main_menu")
		queue_free.call_deferred()


func _skip() -> void:
	if animator.current_animation == "godot": animator.play("rid")
	elif animator.current_animation == "rid": animator.play("epilepsie")
	elif animator.current_animation == "epilepsie": 
		UI.ToggleUi.emit("main_menu", true, "main_menu")
		queue_free.call_deferred()
