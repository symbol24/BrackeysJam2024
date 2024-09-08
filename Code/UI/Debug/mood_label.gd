extends Label


func _ready() -> void:
	Signals.MoodUpdated.connect(_update_mood)

func _update_mood(_mood:Cat.Mood) -> void:
	var _text:String
	match _mood:
		Cat.Mood.NORMAL:
			_text = "Normal"
		Cat.Mood.LIGHTLY_STRESSED:
			_text = "Lightly Stressed"
		Cat.Mood.STRESSED:
			_text = "Stressed"
		Cat.Mood.HIGHLY_STRESSED:
			_text = "Highly Stresses"
		Cat.Mood.OVERSTIMULATED:
			_text = "Overstimulated"
		Cat.Mood.SLIGHTLY_HAPPY:
			_text = "Slightly Happy"
		Cat.Mood.HAPPY:
			_text = "Happy"
		Cat.Mood.REALLY_HAPPY:
			_text = "Really Happy"
		Cat.Mood.CONTENT:
			_text = "Content"
		_:
			_text = ""
	text = _text
