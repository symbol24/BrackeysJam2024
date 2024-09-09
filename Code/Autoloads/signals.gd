extends Node

# Hand
signal HandReleased()

# Cat
signal UpdateStimuli(value:float)
signal StimulationUpdated(value:float)
signal MoodPercentUpdated(value:float)
signal UpdateMood(value:float)
signal MoodUpdated(mood:Cat.Mood)
signal TargetUpdated(part:CatPart.Part)
signal BeingPet(value:bool)
signal MoodMultiplierUpdated(value:float)
signal StimMultiplierUpdated(value:float)
