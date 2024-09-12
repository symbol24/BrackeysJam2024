extends Node

# Game Mode
signal GameTimerUpdated(value:float)
signal TogglePlaying(value:bool)
signal LastRunTime(timer:float)

# Hand
signal HandReleased()

# Player
signal PlayerHpUpdated(value:int)
signal PlayerDefeated(reason:String)

# Cat
signal PettingStarted()
signal UpdateStimuli(value:float)
signal StimulationUpdated(value:float)
signal MoodPercentUpdated(value:float)
signal UpdateMood(value:float)
signal MoodUpdated(mood:Cat.Mood)
signal TargetUpdated(part:CatPart.Part)
signal BeingPet(value:bool)
signal MoodMultiplierUpdated(value:float)
signal StimMultiplierUpdated(value:float)
signal CatAttack(damage:int)
signal StormAttack(damage:int)
signal DisplayCatReaction(value:Cat.Reaction)
signal NoPetToggle(value:bool)
signal PlayPerfectPet()

# UI
signal ToggleUi(value:bool)
signal AnimationComplete()
