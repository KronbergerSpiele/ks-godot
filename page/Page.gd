extends Node2D
class_name Page

@export var frontTexture: ImageTexture = null
@export var backTexture: ImageTexture = null

var lastTexture = null
var passedTime: float = 0.0
var processTicks: int = 0

func Screen() -> Sprite2D:
  return $Screen as Sprite2D
  
func SubViewport():
  return $SubViewport as SubViewport
  
func FrontMaterial() -> Material:
  return $SubViewport/Front.mesh.material

func BackMaterial() -> Material:
  return $SubViewport/Back.mesh.material

func _enter_tree():
  if self.frontTexture or self.backTexture:
    self.startWith(self.frontTexture, self.backTexture)

func _process(delta: float):
  self.passedTime = clamp(self.passedTime + delta, 0, 1)
  self.FrontMaterial().set_shader_parameter("time", self.passedTime)
  self.BackMaterial().set_shader_parameter("time", self.passedTime)
  var texture = self.SubViewport().get_texture()
  
  self.Screen().texture = texture
  if self.passedTime >= 1:
    self.removeOneself()
    
func startWith(front, back):
  if front or back:
    self.FrontMaterial().set_shader_parameter("tex", front)
    self.BackMaterial().set_shader_parameter("tex", back)
  else:
    self.removeOneself()

func removeOneself():
  self.get_parent().remove_child(self)
