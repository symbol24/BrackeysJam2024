extends Label


func _ready() -> void:
	Signals.TargetUpdated.connect(_update_part)

func _update_part(_value:CatPart.Part) -> void:
	var target:String = ""
	match _value:
		CatPart.Part.HEAD:
			target = "HEAD"
		CatPart.Part.BACK:
			target = "BACK"
		CatPart.Part.BUTT:
			target = "BUTT"
		CatPart.Part.TAIL:
			target = "TAIL"
		CatPart.Part.TUMMY:
			target = "TUMMY"
		CatPart.Part.PAWS:
			target = "PAWS"
	
	text = "Target part: %s" % target
