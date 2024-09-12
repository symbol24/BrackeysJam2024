class_name HowToPlayScreen extends SMenuControl

@onready var htp_return_btn: Button = $htp_return_btn



func _ready() -> void:
	super()
	htp_return_btn.pressed.connect(_btn_pressed)
	htp_return_btn.position = (Vector2(UI.width, UI.height)*0.95) - htp_return_btn.size


func _btn_pressed() -> void:
	UI.ToggleUi.emit("main_menu", true, id)
