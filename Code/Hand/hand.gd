class_name Hand extends Area2D

enum State {
			OPEN,
			FULL_HAND,
			ONE_FINGER,
			}

@export var delay:float = 0.05
@export var min_time:float = 3
@export var bad_min_timer:float = 1

@onready var speed_label:Label = %mouse_speed
@onready var area_label: Label = %area_label
@onready var timer_label: Label = %timer_label

var current_state:State = State.OPEN
var body_part:CatPart
var backup_part:CatPart
var rubbing:bool = false
var in_area:bool = false
var good_timer:float = 0
var bad_timer:float = 0
var rub_multiplier:float = 1
var released_multiplier:float = 5
var rub_bad_multiplier:float = 3

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("interact") and body_part != null:
		rubbing = true
	
	if Input.is_action_just_released("interact") and rubbing:
		rubbing = false
		good_timer = 0
		bad_timer = 0
		body_part = null
		if backup_part != null: 
			body_part = backup_part
			area_label.text = body_part.name
			in_area = true
		timer_label.set_deferred("theme_type_variation", "")

func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)

func _process(delta: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", get_global_mouse_position(), delta+delay)

	speed_label.text = str(Input.get_last_mouse_velocity())
	
	if Input.get_last_mouse_velocity() != Vector2.ZERO and in_area and rubbing:
		good_timer += delta
		timer_label.text = str(good_timer)
		if good_timer >= min_time: 
			timer_label.set_deferred("theme_type_variation", "GoodRubLabel")
			Signals.UpdateStimuli.emit(delta * rub_multiplier)
	elif Input.get_last_mouse_velocity() != Vector2.ZERO and not in_area and rubbing:
		bad_timer += delta
		if bad_timer >= bad_min_timer: timer_label.set_deferred("theme_type_variation", "BadRubLabel")
		Signals.UpdateStimuli.emit(delta * rub_bad_multiplier)
	elif Input.get_last_mouse_velocity() == Vector2.ZERO and in_area and rubbing:
		bad_timer += delta
		if bad_timer >= bad_min_timer: timer_label.set_deferred("theme_type_variation", "BadRubLabel")
		Signals.UpdateStimuli.emit(delta * rub_bad_multiplier)
	elif not in_area and not rubbing:
			Signals.UpdateStimuli.emit(-delta * released_multiplier)
		

func _area_entered(_area) -> void:
	if _area is CatPart: backup_part = _area
	if _area is CatPart and not rubbing:
		body_part = _area as CatPart
		area_label.text = _area.name
		in_area = true
	elif _area is CatPart and rubbing:
		in_area = true

func _area_exited(_area) -> void:
	if backup_part == _area: backup_part = null
	if body_part == _area and not rubbing:
		body_part = null
		area_label.text = "none"
		in_area = false
	elif body_part == _area and rubbing:
		in_area = false
