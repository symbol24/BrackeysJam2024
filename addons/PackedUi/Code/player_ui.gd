class_name PlayerUi extends SControl

@export var storm_time:float = 3

@export var hit_sfx:AudioFile

@onready var atk_color: ColorRect = %atk_color
@onready var attack_sprite: Sprite2D = %attack_sprite
@onready var shake_rect: ColorRect = %shake_rect

# Screen shaker
var current_shake_strength:float = 0
var shake_time:float = 0:
	set(_value):
		shake_time = _value
		if shake_time <= 0:
			shake = false
var shake:bool = false:
	set(_value):
		shake = _value
		if shake: shake_rect.material.set_shader_parameter("ShakeStrength", max(current_shake_strength,0))
		else: shake_rect.material.set_shader_parameter("ShakeStrength", 0)


func _ready() -> void:
	super()
	Signals.CatAttack.connect(_displays_attack)
	Signals.StormAttack.connect(_display_storm)


func _process(delta: float) -> void:
	if shake:
		shake_time -= delta
		


func _shake(_time:float, _strength:float) -> void:
	shake_time = _time
	current_shake_strength = _strength
	shake = true


func _displays_attack(_value:int) -> void:
	atk_color.show()
	for i in min(10,_value):
		await _attack_cycle(0.1, 0.07, 0.1, 1)
	await get_tree().create_timer(0.05).timeout
	atk_color.hide()
	Signals.AnimationComplete.emit()
	

func _display_storm(_value:int) -> void:
	atk_color.show()
	for i in 20:
		await _attack_cycle(0.1, 0.04, 0.1, 1)
	await get_tree().create_timer(0.05).timeout
	atk_color.hide()
	Signals.AnimationComplete.emit()

func _attack_cycle(_display_time:float, _wait_time:float, _shake_time:float, _shake_strength:float) -> void:
	attack_sprite.global_position = Vector2(randf_range(200, 1080), randf_range(200, 520))
	attack_sprite.show()
	Audio.play_audio(hit_sfx)
	_shake(_shake_time, _shake_strength)
	# play attack sound here
	await get_tree().create_timer(_display_time).timeout
	attack_sprite.hide()
	await get_tree().create_timer(_wait_time).timeout
