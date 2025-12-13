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
  
  var front_mat = self.FrontMaterial()
  if not front_mat:
    return
  front_mat.set_shader_parameter("time", self.passedTime)
  
  var back_mat = self.BackMaterial()
  if not back_mat:
    return
  back_mat.set_shader_parameter("time", self.passedTime)
  
  var subviewport = self.SubViewport()
  if not subviewport:
    return
  var texture = subviewport.get_texture()
  
  var screen = self.Screen()
  if not screen:
    return
  screen.texture = texture
  
  if self.passedTime >= 1:
    self.removeOneself()
    
func startWith(front, back):
  if front or back:
    var front_mat = self.FrontMaterial()
    var back_mat = self.BackMaterial()
    if front_mat:
      front_mat.set_shader_parameter("tex", front)
    if back_mat:
      back_mat.set_shader_parameter("tex", back)
    self.visible = true
    self.passedTime = 0.0
  else:
    self.removeOneself()

func removeOneself():
  var parent = self.get_parent()
  if parent:
    parent.remove_child(self)
    self.queue_free()
