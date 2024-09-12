class_name Hand extends Area2D

enum State {
			OPEN,
			FULL_HAND,
			ONE_FINGER,
			}

@export var delay:float = 0.05
@export var min_time:float = 3

@onready var speed_label:Label = %mouse_speed
@onready var area_label: Label = %area_label
@onready var timer_label: Label = %timer_label
@onready var sprite: Sprite2D = %sprite

var current_state:State = State.OPEN

# Petting detection
var body_part:CatPart
var backup_part:CatPart
var fully_exit:bool = true
var rubbing:bool = false
var in_area:bool = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("interact"):
		current_state = State.FULL_HAND
		sprite.frame = 0
		rubbing = true
	
	if Input.is_action_just_released("interact"):
		current_state = State.OPEN
		sprite.frame = 1
		rubbing = false
		Signals.HandReleased.emit()

func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)

func _process(delta: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", get_global_mouse_position(), delta+delay)

	speed_label.text = str(Input.get_last_mouse_velocity())
	
	if GM.playing:
		if fully_exit:
			if body_part == null:
				if overlaps_area(backup_part):
					body_part = backup_part
					in_area = true
					area_label.text = "Over area: %s" % body_part.name
		
		if rubbing:
			if body_part != null:
				area_label.text = "Over area: %s" % body_part.name
				body_part.pet(Input.get_last_mouse_velocity(), in_area)

func _area_entered(_area) -> void:
	if _area is CatPart:
		if fully_exit:
			body_part = _area as CatPart
			area_label.text = "Over area: %s" % _area.name
			in_area = true
			fully_exit = false
		backup_part = _area as CatPart


func _area_exited(_area) -> void:
	if _area == body_part:
		fully_exit = true 
		body_part = null
		in_area = false
		area_label.text = "Over area: none" 
