extends Node2D

@onready var animator: AnimationPlayer = %animator

var step := 0
var step_running := false


func _input(_event: InputEvent) -> void:
	if Input.is_anything_pressed():
		_skip()


func _ready() -> void:
	animator.animation_finished.connect(_anim_check)
	await get_tree().create_timer(1).timeout
	_start()


func _start() -> void:
	animator.play("godot")


func _anim_check(_anim_name:="") -> void:
	animator.play("RESET")
	if _anim_name == "godot": animator.play("rid")
	elif _anim_name == "rid": animator.play("epilepsie")
	elif _anim_name == "epilepsie": animator.play("cat_warning")
	elif _anim_name == "cat_warning":
		UI.ToggleUi.emit("main_menu", true, "main_menu")
		queue_free.call_deferred()


func _skip() -> void:
	var anim:String = animator.current_animation
	animator.stop()
	animator.play("RESET")
	if anim == "godot": animator.play("rid")
	elif anim == "rid": animator.play("epilepsie")
	elif anim == "epilepsie": animator.play("cat_warning")
	elif anim == "cat_warning":
		UI.ToggleUi.emit("main_menu", true, "main_menu")
		queue_free.call_deferred()
