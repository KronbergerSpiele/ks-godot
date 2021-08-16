extends Node2D

export var FrontTexture: ImageTexture
export var BackTexture: ImageTexture

var LastTexture: ImageTexture

var passedTime: float = 0
var processTicks: int = 0

func _enter_tree():
	if FrontTexture || BackTexture:
		startWith(FrontTexture, BackTexture)

func _process(_delta):
	passedTime = clamp(passedTime+_delta, 0, 1)
	$Viewport/Front.mesh.material.set_shader_param('time', passedTime)
	$Viewport/Back.mesh.material.set_shader_param('time', passedTime)
	var texture = $Viewport.get_texture()
	$screen.texture = texture
	if passedTime >= 1:
		removeOneself()

func startWith(front: ImageTexture, back: ImageTexture):
	if front || back:
		$Viewport/Front.mesh.material.set_shader_param('tex', front)
		$Viewport/Back.mesh.material.set_shader_param('tex', back)
	else:
		removeOneself()

func removeOneself():
	get_parent().remove_child(self)