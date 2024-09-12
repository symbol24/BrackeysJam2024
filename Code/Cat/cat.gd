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

enum Reaction {
				NONE,
				ANGRY_MEOW,
				GROWL,
				HISS,
				ATTACK,
				CURIOUS_MEOW,
				HAPPY_MEOW,
				TRILL,
				PURR,
				}

@export_group("Petting")
@export var target_time_change:Array[float] = [3, 7]
@export var no_hand_mood_multiplier:float = 2
@export var no_hand_stim_multiplier:float = 5
@export var outside_stim_reducer:float = 1
@export var perfect_pet_bonus:float = 3
@export var perfect_pet_lengths:Array[float] = [1000000, 5000000]

@export_group("Attacks and Reactions")
@export var lighty_stressed_delay:float = 4
@export var stressed_delay:float = 3
@export var highly_stressed_delay:float = 2
@export var over_stimulated_delay:float = 1
@export var attack_damage_range:Array[int] = [1, 10]
@export var reaction_timer_range:Array[float] = [1, 10]
@export var overstimated_timer_delay:float = 20

# Debug
@onready var target_part_label: Label = %target_part
@onready var delta_label: Label = %delta_label

# PARTS
@onready var head: CatPart = %head
@onready var back: CatPart = %back
@onready var butt: CatPart = %butt
@onready var paws: CatPart = %paws
@onready var tummy: CatPart = %tummy
@onready var tail: CatPart = %tail

# Highlights
@onready var head_highlight: Sprite2D = %head_highlight
@onready var back_highlight: Sprite2D = %back_highlight
@onready var butt_highlight: Sprite2D = %butt_highlight
@onready var tail_highlight: Sprite2D = %tail_highlight
@onready var tummy_highlight: Sprite2D = %tummy_highlight
@onready var paws_highlight: Sprite2D = %paws_highlight
@onready var all_highlights:Array[Sprite2D] = [%head_highlight, %back_highlight, %butt_highlight, %tail_highlight, %tummy_highlight, %paws_highlight]


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
		_highlight_part(target_part)
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

# Target TIMER
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

# Reaction TIMER
var run_reaction_timer:bool = false
var damage:int:
	get:
		if attack_damage_range.size() > 1: damage = randi_range(attack_damage_range[0], attack_damage_range[1])
		else: 
			damage = 1
			push_error("Cat attack damage range does not contain 2 value.")
		return damage
var reaction_delay:float = 0.0
var reaction_timer:float = 0.0:
	set(_value):
		reaction_timer = _value
		if reaction_timer >= reaction_delay:
			reaction_timer = 0.0
			var reaction = _reaction_check(current_mood)
			Signals.DisplayCatReaction.emit(reaction)
			if reaction == Reaction.ATTACK: Signals.CatAttack.emit(damage)
			if reaction_timer_range.size() > 1: reaction_delay = randf_range(reaction_timer_range[0], reaction_timer_range[1])
			else:
				reaction_delay = 3
				push_error("Cat reaction timer range does not contain 2 value.")

# Overstimulation Timer
var overstimulated:bool = false:
	set(_value):
		overstimulated = _value
		if not overstimulated: overstimulated_timer = 0.0
var overstimulated_timer:float = 0.0:
	set(_value):
		overstimulated_timer = _value 
		if overstimulated_timer >= overstimated_timer_delay:
			overstimulated = false
			Signals.StormAttack.emit(100)

# Other
var pet_signal_sent:bool = false
var perfect_pet_signal_sent:bool = false


func _ready() -> void:
	Signals.HandReleased.connect(_pet_stopped)
	if not target_part_label.is_node_ready(): await target_part_label.ready
	target_part = _update_target(target_part)


func _process(_delta: float) -> void:
	if GM.playing:
		current_mood = _check_mood(mood_percent, stimulation)

		if run_target_timer: timer += _delta
		if run_reaction_timer: reaction_timer += _delta
		if overstimulated: overstimulated_timer += _delta

		mood_percent += _delta * mood_multiplier
		stimulation += _delta * stim_multiplier


func pet_part(_body_part:CatPart, _mouse_vel:Vector2, _in_area:bool) -> void:
	if !pet_signal_sent:
		Signals.PettingStarted.emit()
		pet_signal_sent = true
	Signals.NoPetToggle.emit(false)
	run_reaction_timer = true
	being_pet = true
	var mood_multi:float = 1.0
	var stim_multi:float = 1.0
	if _in_area:
		if target_part == _body_part.body_part: mood_multi = _body_part.positive_multiplier
		else: mood_multi = -_body_part.negative_multiplier
		stim_multi = _body_part.stimuli_multiplier
	else:
		stim_multi = max(1, _body_part.stimuli_multiplier - outside_stim_reducer)
	hand_velocity = _mouse_vel
	lengths.append(hand_velocity.length_squared())
	lengths.sort()
	if lengths.size() > 1:
		if (lengths[-1] - lengths[0])/2 >= perfect_pet_lengths[0] and (lengths[-1] - lengths[0])/2 <= perfect_pet_lengths[1]:
			#print("in perfect pet range")
			if mood_multi > 0.0 and _mouse_vel != Vector2.ZERO:
				mood_multi += perfect_pet_bonus
				if not perfect_pet_signal_sent: 
					Signals.PlayPerfectPet.emit()
					perfect_pet_signal_sent = true
			
		delta_label.text = str((lengths[-1] - lengths[0])/2)
	
	stim_multiplier = stim_multi
	mood_multiplier = mood_multi


func _pet_stopped() -> void:
	perfect_pet_signal_sent = false
	being_pet = false
	run_reaction_timer = false
	hand_velocity = Vector2.ZERO
	stim_multiplier = -no_hand_stim_multiplier
	mood_multiplier = -no_hand_mood_multiplier
	lengths.clear()
	Signals.NoPetToggle.emit(true)


func _update_target(_current:CatPart.Part) -> CatPart.Part:
	var new_part:CatPart.Part = randi_range(0, CatPart.Part.size()) as CatPart.Part
	while new_part == _current:
		new_part = randi_range(0, CatPart.Part.size()) as CatPart.Part
	return new_part


func _get_target_part() -> CatPart:
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


func _highlight_part(_part:CatPart.Part) -> void:
	var to_highlight:Sprite2D
	match _part:
		CatPart.Part.HEAD:
			to_highlight = head_highlight
		CatPart.Part.BACK:
			to_highlight = back_highlight
		CatPart.Part.BUTT:
			to_highlight = butt_highlight
		CatPart.Part.PAWS:
			to_highlight = paws_highlight
		CatPart.Part.TUMMY:
			to_highlight = tummy_highlight
		CatPart.Part.TAIL:
			to_highlight = tail_highlight
		_:
			pass
	
	for each in all_highlights:
		each.hide()
	
	if to_highlight != null:	to_highlight.show()


func _reaction_check(_mood:Mood) -> Reaction:
	var new_reaction:Reaction = Reaction.NONE
	match _mood:
		Mood.NORMAL:
			new_reaction = Reaction.NONE
		Mood.LIGHTLY_STRESSED:
			new_reaction = Reaction.ANGRY_MEOW
		Mood.STRESSED:
			new_reaction = Reaction.GROWL
		Mood.HIGHLY_STRESSED:
			new_reaction = Reaction.HISS
		Mood.OVERSTIMULATED:
			new_reaction = Reaction.ATTACK
		Mood.SLIGHTLY_HAPPY:
			new_reaction = Reaction.CURIOUS_MEOW
		Mood.HAPPY:
			new_reaction = Reaction.HAPPY_MEOW
		Mood.REALLY_HAPPY:
			new_reaction = Reaction.TRILL
		Mood.CONTENT:
			new_reaction = Reaction.PURR
		_:
			pass
	
	return new_reaction


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
	
	if new_mood == Mood.OVERSTIMULATED: overstimulated = true
	else: overstimulated = false
	
	return new_mood
