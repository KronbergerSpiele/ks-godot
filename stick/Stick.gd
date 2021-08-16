extends Node2D

export(Texture) var baseTexture
export(Texture) var baseActiveTexture
export(Texture) var buttonTexture
export(int) var maxDistance = 45

export(Vector2) var output = Vector2.ZERO

func _ready():
	$base.texture=baseTexture
	$button.texture=buttonTexture

func activateStick(touchedPosition: Vector2):
	$base.texture=baseActiveTexture
	position = touchedPosition
	
func deactivateStick():
	$base.texture=baseTexture
	$button.position = Vector2.ZERO
	output = Vector2.ZERO

func updateStick(direction := Vector2.ZERO):
	var clamped = direction.clamped(maxDistance)
	$button.position = clamped
	output = clamped

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			activateStick(event.position)
		else:
			deactivateStick()
	
	elif event is InputEventScreenDrag:
		updateStick(event.position - position)

var wasKeyPressedBefore = false
		
func _process(delta):
	var direction = Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1 
	if Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_key_pressed(KEY_DOWN):
		direction.y += 1
	
	if Input.is_key_pressed(KEY_SHIFT):
		direction *= 0.5
	
	if direction.length() > 0:
		wasKeyPressedBefore = true
		updateStick(direction * maxDistance)
	elif wasKeyPressedBefore:
		wasKeyPressedBefore = false
		updateStick()
		
