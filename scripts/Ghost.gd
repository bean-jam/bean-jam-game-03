extends CharacterBody2D
class_name Ghost
## The base script for all ghost characters

var tween = create_tween()

func _ready():
	# Start the initial bobbing loop
	bob_up_down()

func bob_up_down():
	# Set the tween to loop
	tween.set_loops()
	# Move up
	tween.tween_property(self, "position:y", position.y - 1, 1)
	# Chain the down movement
	tween.tween_property(self, "position:y", position.y + 1, 1)
