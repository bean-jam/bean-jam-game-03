extends CharacterBody2D
class_name Ghost
## The base script for all ghost characters

## Adjust the speed the ghosts move in the queue
@export var movement_speed: float = 10.0

## Used to set speed back to movement speed after every stop.
var speed = movement_speed

## The forward raycast to detect collisions
@onready var ray: RayCast2D = $InteractionRaycast

## This signal checks whether the booth has been touched.
## Will be moved to the global signal bus eventually.
signal booth_touched(ghost: Node)

func _ready():
	randomize()
	add_to_group("ghosts")
	booth_touched.connect(_on_booth_touched)

## Temporary disappearing to test queueing
func _on_booth_touched(ghost):
	await get_tree().create_timer(5.0).timeout
	queue_free()

## This is the queue physics and movement.
## The ghosts stop when they reach the desk or the next ghost in line
func _physics_process(delta: float) -> void:
	if ray.is_colliding():
		var collider = ray.get_collider()
		if not collider:
			return
		
		# If it's the booth, emit the signal and stop
		if collider.is_in_group("booth"):
			booth_touched.emit(self)
			speed = 0.0
			return

		# Otherwise, stop if it's another ghost
		if collider.is_in_group("ghosts"):
			speed = 0.0
			return

	# no blocking object ahead -> keep moving
	speed = movement_speed
	velocity = Vector2(0, -1) * speed
	move_and_slide()
