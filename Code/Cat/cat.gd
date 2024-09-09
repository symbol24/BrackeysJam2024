class_name Cat extends Node2D

enum Mood {
			NORMAL,
			LIGHTLY_STRESSED,
			STRESSED,
			HIGHLY_STRESSED,
			OVERSTIMULATED,
			SLIGHTLY_HAPPY,
			HAPPY,
			REALLY_HAPPY,
			CONTENT,	
			}

@export var target_time_change:Array[float] = [3, 7]
@export var no_hand_mood_multiplier:float = 2
@export var no_hand_stim_multiplier:float = 5
@export var outside_stim_reducer:float = 1
@export var perfect_pet_bonus:float = 3
@export var perfect_pet_lengths:Array[float] = [1000000, 5000000]

@onready var target_part_label: Label = %target_part
@onready var delta_label: Label = %delta_label

# PARTS
@onready var head: CatPart = %head
@onready var back: CatPart = %back
@onready var butt: CatPart = %butt
@onready var paws: CatPart = %paws
@onready var tummy: CatPart = %tummy
@onready var tail: CatPart = %tail

# MOOD, STIMULATION AND TARGET PART
var current_mood:Mood:
	set(_value):
		current_mood = _value
		Signals.MoodUpdated.emit(current_mood)
var mood_percent:float = 0:
	set(_value):
		mood_percent = _value
		mood_percent = clampf(mood_percent, 0, 100)
		Signals.MoodPercentUpdated.emit(mood_percent)
var stimulation:float = 0:
	set(_value):
		stimulation = _value
		stimulation = clampf(stimulation, 0, 100)
		Signals.StimulationUpdated.emit(stimulation)
var target_part:CatPart.Part:
	set(_value):
		target_part = _value
		Signals.TargetUpdated.emit(target_part)
var being_pet:bool = false:
	set(_value):
		being_pet = _value
		Signals.BeingPet.emit(being_pet)
var stim_multiplier:float = 0:
	set(_value):
		stim_multiplier = _value
		Signals.StimMultiplierUpdated.emit(stim_multiplier)
var mood_multiplier:float = 0:
	set(_value):
		mood_multiplier = _value
		Signals.MoodMultiplierUpdated.emit(mood_multiplier)
var hand_velocity:Vector2 = Vector2.ZERO
var lengths:Array[float] = []

# TIMER
var previous_delay:float
var delay:float = 0.0:
	get:
		if delay == 0.0:
			delay = randf_range(target_time_change[0], target_time_change[1])
		return delay
var timer:float = 0.0:
	set(_value):
		timer = _value
		if timer >= delay:
			timer = 0.0
			previous_delay = delay
			delay = randf_range(target_time_change[0], target_time_change[1])
			target_part = _update_target(target_part)
var run_target_timer:bool = true


func _ready() -> void:
	Signals.HandReleased.connect(_pet_stopped)
	if not target_part_label.is_node_ready(): await target_part_label.ready
	target_part = _update_target(target_part)

func _process(_delta: float) -> void:
	current_mood = _check_mood(mood_percent, stimulation)
	if run_target_timer:
		timer += _delta
	
	if lengths.size() > 1:
		if (lengths[-1] - lengths[0])/2 >= perfect_pet_lengths[0] and (lengths[-1] - lengths[0])/2 <= perfect_pet_lengths[1]:
			#print("in perfect pet range")
			if mood_multiplier > 0.0:
				mood_multiplier *= perfect_pet_bonus
			
		delta_label.text = str((lengths[-1] - lengths[0])/2)
	mood_percent += _delta * mood_multiplier
	stimulation += _delta * stim_multiplier
		

func pet_part(_body_part:CatPart, _mouse_vel:Vector2, _in_area:bool) -> void:
	being_pet = true
	var mood_multi:float = 1.0
	var stim_multi:float = 1.0
	if _in_area:
		if target_part == _body_part.body_part: mood_multi = _body_part.positive_multiplier
		else: mood_multi = -_body_part.negative_multiplier
		stim_multi = _body_part.stimuli_multiplier
	else:
		stim_multi = max(1, _body_part.stimuli_multiplier - outside_stim_reducer)
	stim_multiplier = stim_multi
	mood_multiplier = mood_multi
	hand_velocity = _mouse_vel
	lengths.append(hand_velocity.length_squared())
	lengths.sort()

func _pet_stopped() -> void:
	being_pet = false
	hand_velocity = Vector2.ZERO
	stim_multiplier = -no_hand_stim_multiplier
	mood_multiplier = -no_hand_mood_multiplier
	lengths.clear()


func _update_target(_current:CatPart.Part) -> CatPart.Part:
	var new_part:CatPart.Part = randi_range(0, CatPart.Part.size()) as CatPart.Part
	while new_part == _current:
		new_part = randi_range(0, CatPart.Part.size()) as CatPart.Part
	return new_part

func get_target_part() -> CatPart:
	var to_return: CatPart
	match target_part:
		CatPart.Part.HEAD:
			to_return = head
		CatPart.Part.BACK:
			to_return = back
		CatPart.Part.BUTT:
			to_return = butt
		CatPart.Part.PAWS:
			to_return = paws
		CatPart.Part.TUMMY:
			to_return = tummy
		CatPart.Part.TAIL:
			to_return = tail
		_:
			pass
	
	return to_return

func _check_mood(_mood_perc:float, _stimuli:float) -> Mood:
	var new_mood:Mood
	if _mood_perc >= 0 and _mood_perc < 11:
		if _stimuli >= 0 and _stimuli < 20: new_mood = Mood.STRESSED
		elif _stimuli >= 20 and _stimuli < 40: new_mood = Mood.HIGHLY_STRESSED
		elif _stimuli >= 40 and _stimuli < 60: new_mood = Mood.OVERSTIMULATED
		elif _stimuli >= 60 and _stimuli < 80: new_mood = Mood.OVERSTIMULATED
		else: new_mood = Mood.OVERSTIMULATED
	elif _mood_perc >= 11 and _mood_perc < 22:
		if _stimuli >= 0 and _stimuli < 20: new_mood = Mood.LIGHTLY_STRESSED
		elif _stimuli >= 20 and _stimuli < 40: new_mood = Mood.STRESSED
		elif _stimuli >= 40 and _stimuli < 60: new_mood = Mood.HIGHLY_STRESSED
		elif _stimuli >= 60 and _stimuli < 80: new_mood = Mood.OVERSTIMULATED
		else: new_mood = Mood.OVERSTIMULATED
	elif _mood_perc >= 22 and _mood_perc < 33:
		if _stimuli >= 0 and _stimuli < 20: new_mood = Mood.NORMAL
		elif _stimuli >= 20 and _stimuli < 40: new_mood = Mood.LIGHTLY_STRESSED
		elif _stimuli >= 40 and _stimuli < 60: new_mood = Mood.STRESSED
		elif _stimuli >= 60 and _stimuli < 80: new_mood = Mood.HIGHLY_STRESSED
		else: new_mood = Mood.OVERSTIMULATED
	elif _mood_perc >= 33 and _mood_perc < 44:
		if _stimuli >= 0 and _stimuli < 20: new_mood = Mood.NORMAL
		elif _stimuli >= 20 and _stimuli < 40: new_mood = Mood.SLIGHTLY_HAPPY
		elif _stimuli >= 40 and _stimuli < 60: new_mood = Mood.NORMAL
		elif _stimuli >= 60 and _stimuli < 80: new_mood = Mood.LIGHTLY_STRESSED
		else: new_mood = Mood.HIGHLY_STRESSED
	elif _mood_perc >= 44 and _mood_perc < 55:
		if _stimuli >= 0 and _stimuli < 20: new_mood = Mood.NORMAL
		elif _stimuli >= 20 and _stimuli < 40: new_mood = Mood.SLIGHTLY_HAPPY
		elif _stimuli >= 40 and _stimuli < 60: new_mood = Mood.NORMAL
		elif _stimuli >= 60 and _stimuli < 80: new_mood = Mood.SLIGHTLY_HAPPY
		else: new_mood = Mood.HIGHLY_STRESSED
	elif _mood_perc >= 55 and _mood_perc < 66:
		if _stimuli >= 0 and _stimuli < 20: new_mood = Mood.SLIGHTLY_HAPPY
		elif _stimuli >= 20 and _stimuli < 40: new_mood = Mood.NORMAL
		elif _stimuli >= 40 and _stimuli < 60: new_mood = Mood.SLIGHTLY_HAPPY
		elif _stimuli >= 60 and _stimuli < 80: new_mood = Mood.HAPPY
		else: new_mood = Mood.LIGHTLY_STRESSED
	elif _mood_perc >= 66 and _mood_perc < 77:
		if _stimuli >= 0 and _stimuli < 20: new_mood = Mood.HAPPY
		elif _stimuli >= 20 and _stimuli < 40: new_mood = Mood.REALLY_HAPPY
		elif _stimuli >= 40 and _stimuli < 60: new_mood = Mood.CONTENT
		elif _stimuli >= 60 and _stimuli < 80: new_mood = Mood.SLIGHTLY_HAPPY
		else: new_mood = Mood.NORMAL
	elif _mood_perc >= 77 and _mood_perc < 88:
		if _stimuli >= 0 and _stimuli < 20: new_mood = Mood.HAPPY
		elif _stimuli >= 20 and _stimuli < 40: new_mood = Mood.REALLY_HAPPY
		elif _stimuli >= 40 and _stimuli < 60: new_mood = Mood.CONTENT
		elif _stimuli >= 60 and _stimuli < 80: new_mood = Mood.CONTENT
		else: new_mood = Mood.SLIGHTLY_HAPPY
	else:
		if _stimuli >= 0 and _stimuli < 20: new_mood = Mood.HAPPY
		elif _stimuli >= 20 and _stimuli < 40: new_mood = Mood.CONTENT
		elif _stimuli >= 40 and _stimuli < 60: new_mood = Mood.CONTENT
		elif _stimuli >= 60 and _stimuli < 80: new_mood = Mood.CONTENT
		else: new_mood = Mood.SLIGHTLY_HAPPY
	
	return new_mood
