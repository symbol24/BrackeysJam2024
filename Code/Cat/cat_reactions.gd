class_name CatReactions extends Node2D

@export_group("Music and SFX")
@export var normal_cat_music:AudioFile
@export var anxty_cat_music:AudioFile
@export var angry_meow:AudioFile
@export var growl:AudioFile
@export var hiss:AudioFile
@export var curious_meow:AudioFile
@export var happy_meow:AudioFile
@export var trill:AudioFile
@export var purr:AudioFile
@export var perfect_pet:AudioFile

var current_music:AudioFile


func _ready() -> void:
	Signals.DisplayCatReaction.connect(_react)
	Signals.MoodUpdated.connect(_change_song)
	Signals.PlayPerfectPet.connect(_play_perfect_pet)


func _react(_reaction:Cat.Reaction) -> void:
	match _reaction:
		Cat.Reaction.ANGRY_MEOW:
			Audio.play_audio(angry_meow)
		Cat.Reaction.GROWL:
			Audio.play_audio(growl)
		Cat.Reaction.HISS:
			Audio.play_audio(hiss)
		Cat.Reaction.CURIOUS_MEOW:
			Audio.play_audio(curious_meow)
		Cat.Reaction.HAPPY_MEOW:
			Audio.play_audio(happy_meow)
		Cat.Reaction.TRILL:
			Audio.play_audio(trill)
		Cat.Reaction.PURR:
			Audio.play_audio(purr)


func _change_song(_mood:Cat.Mood) -> void:
	var to_play:AudioFile
	match _mood:
		Cat.Mood.NORMAL, Cat.Mood.HAPPY, Cat.Mood.REALLY_HAPPY, Cat.Mood.CONTENT:
			to_play = normal_cat_music
		Cat.Mood.LIGHTLY_STRESSED, Cat.Mood.STRESSED, Cat.Mood.HIGHLY_STRESSED, Cat.Mood.OVERSTIMULATED:
			to_play = anxty_cat_music
	
	if to_play != current_music:
		current_music = to_play
		Audio.play_audio(to_play)

func _play_perfect_pet() -> void:
	Audio.play_audio(perfect_pet)
