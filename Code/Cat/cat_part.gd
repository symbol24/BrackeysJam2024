class_name CatPart extends Area2D

enum Part {
			HEAD,
			BACK,
			BUTT,
			TAIL,
			TUMMY,
			PAWS,
}

@export var body_part:Part
@export var positive_multiplier:float
@export var negative_multiplier:float
@export var stimuli_multiplier:float

@onready var parent:Cat = get_parent() as Cat

var max_speed:Vector2

func pet(_mouse_vel:Vector2, _in_area:bool) -> void:
	parent.pet_part(self, _mouse_vel, _in_area)
