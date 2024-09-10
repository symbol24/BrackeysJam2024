extends Node

# Game Mode
signal GameTimerUpdated(value:float)
signal TogglePlaying(value:bool)

# Hand
signal HandReleased()

# Player
signal PlayerHpUpdated(value:int)
signal PlayerDefeated()

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
signal CatAttack(value:int)
signal DisplayCatReaction(value:Cat.Reaction)

# UI
signal ToggleUi(value:bool)
