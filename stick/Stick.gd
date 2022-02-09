extends Node2D
class_name Stick

export(Texture) var baseTexture = load("res://ksgodot/stick/base.png")
export(Texture) var baseActiveTexture = load("res://ksgodot/stick/baseActive.png")
export(Texture) var buttonTexture = load("res://ksgodot/stick/button.png")
export(int) var maxDistance: int = 45
export(Vector2) var output = Vector2.ZERO

func Base() -> Sprite:
  return $Base as Sprite

func Button() -> Sprite:
  return $Button as Sprite

func _ready():
  self.Base().texture = self.baseTexture
  self.Button().texture = self.buttonTexture

func activateStick(touchedPosition):
  self.Base().texture = self.baseActiveTexture
  self.position = touchedPosition

func deactiveStick():
  self.Base().texture = self.baseTexture
  self.Button().position = Vector2.ZERO
  self.output = Vector2.ZERO

func updateStick(direction = Vector2.ZERO):
  var clamped = direction.clamped(self.maxDistance)
  self.Button().position = clamped
  self.output = clamped

func _unhandled_input(event):
  if event is InputEventScreenTouch:
    if event.pressed:
      self.activateStick(event.position)
    else:
      self.deactiveStick()
  else:
    if event is InputEventScreenDrag:
      self.updateStick(event.position - self.position)

var wasKeyPressedBefore: bool = false

func _process(_delta: float):
  var direction = Vector2.ZERO
  
  if Input.is_key_pressed(KEY_LEFT):
    direction = direction + Vector2(-1, 0)
  
  if Input.is_key_pressed(KEY_RIGHT):
    direction = direction + Vector2(1, 0)
  
  if Input.is_key_pressed(KEY_UP):
    direction = direction + Vector2(0, -1)
  
  if Input.is_key_pressed(KEY_DOWN):
    direction = direction + Vector2(0, 1)
  
  if Input.is_key_pressed(KEY_SHIFT):
    direction = direction + 0.5
  
  if direction.length() > 0:
    self.wasKeyPressedBefore = true
    self.updateStick(direction * self.maxDistance)
  else:
    if self.wasKeyPressedBefore:
      self.wasKeyPressedBefore = false
      self.updateStick()

