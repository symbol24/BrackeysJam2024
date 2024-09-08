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

var current_mood:Mood:
	set(_value):
		current_mood = _value
		Signals.MoodUpdated.emit(current_mood)
var mood_percent:float = 0:
	set(_value):
		mood_percent = _value
		mood_percent = clampf(stimulation, 0, 100)
var stimulation:float = 0:
	set(_value):
		stimulation = _value
		stimulation = clampf(stimulation, 0, 100)
		Signals.StimulationUpdated.emit(stimulation)

func _ready() -> void:
	Signals.UpdateStimuli.connect(_update_stimuli)

func _process(_delta: float) -> void:
	current_mood = _check_mood(mood_percent, stimulation)

func _update_stimuli(_value:float) -> void:
	stimulation += _value

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
	
	_mood_perc
	
	
	return new_mood
