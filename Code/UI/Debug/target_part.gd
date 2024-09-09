extends Label


func _ready() -> void:
	Signals.TargetUpdated.connect(_update_part)

func _update_part(_value:CatPart.Part) -> void:
	match _value:
		CatPart.Part.HEAD:
			text = "HEAD"
		CatPart.Part.BACK:
			text = "BACK"
		CatPart.Part.BUTT:
			text = "BUTT"
		CatPart.Part.TAIL:
			text = "TAIL"
		CatPart.Part.TUMMY:
			text = "TUMMY"
		CatPart.Part.PAWS:
			text = "PAWS"
		
