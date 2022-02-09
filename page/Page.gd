extends Node2D
class_name Page

export(ImageTexture) var frontTexture = null
export(ImageTexture) var backTexture = null

var lastTexture = null
var passedTime: float = 0.0
var processTicks: int = 0

func Screen() -> Sprite:
  return $Screen as Sprite
  
func Viewport():
  return $Viewport as Viewport
  
func FrontMaterial() -> Material:
  return $Viewport/Front.mesh.material

func BackMaterial() -> Material:
  return $Viewport/Back.mesh.material

func _enter_tree():
  if self.frontTexture or self.backTexture:
    self.startWith(self.frontTexture, self.backTexture)

func _process(delta: float):
  self.passedTime = clamp(self.passedTime + delta, 0, 1)
  self.FrontMaterial().set_shader_param("time", self.passedTime)
  self.BackMaterial().set_shader_param("time", self.passedTime)
  var texture = self.Viewport().get_texture()
  
  self.Screen().texture = texture
  if self.passedTime >= 1:
    self.removeOneself()
    
func startWith(front, back):
  if front or back:
    self.FrontMaterial().set_shader_param("tex", front)
    self.BackMaterial().set_shader_param("tex", back)
  else:
    self.removeOneself()

func removeOneself():
  self.get_parent().remove_child(self)
