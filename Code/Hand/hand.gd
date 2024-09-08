class_name Hand extends Area2D

enum State {
            OPEN,
            FULL_HAND,
            ONE_FINGER,
            }

@export var delay:float = 0.05

var current_state:State = State.OPEN

func _process(delta: float) -> void:
    var tween = get_tree().create_tween()
    tween.tween_property(self, "global_position", get_global_mouse_position(), delta+delay)