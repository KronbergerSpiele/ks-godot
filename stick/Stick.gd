extends Node2D
class_name Stick

@export var baseTexture: Texture2D = load("res://ksgodot/stick/base.png")
@export var baseActiveTexture: Texture2D = load("res://ksgodot/stick/baseActive.png")
@export var buttonTexture: Texture2D = load("res://ksgodot/stick/button.png")
@export var maxDistance: int = 45
@export var output: Vector2 = Vector2.ZERO

func Base() -> Sprite2D:
  return $Base as Sprite2D

func Button() -> Sprite2D:
  return $Button as Sprite2D

func _ready():
  self.output = Vector2.ZERO
  self.Base().texture = self.baseTexture
  self.Button().texture = self.buttonTexture

func activateStick(touchedPosition):
  self.Base().texture = self.baseActiveTexture
  self.position = touchedPosition

func deactiveStick():
  self.Base().texture = self.baseTexture
  self.Button().position = Vector2.ZERO
  self.output = Vector2.ZERO

func updateStick(direction):
  var limit_length = direction.limit_length(self.maxDistance)
  self.Button().position = limit_length
  self.output = limit_length

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
      self.updateStick(Vector2.ZERO)

