extends Node
class_name BackgroundAudio

func Player0() -> AudioStreamPlayer:
  return $Background0 as AudioStreamPlayer
func Player1() -> AudioStreamPlayer:
  return $Background1 as AudioStreamPlayer

var nextBackgroundPlayer: int = 0
var currentBackgroundResourcePath: String = ""

func playBackground(stream):
  if not stream || stream.resource_path == self.currentBackgroundResourcePath:
    return
  
  self.currentBackgroundResourcePath = stream.resource_path
  
  var current = self.Player1() if self.nextBackgroundPlayer == 0 else self.Player0()
  var next = self.Player0() if self.nextBackgroundPlayer == 0 else self.Player1()
  
  current.stop()
  next.stop()
  next.stream = stream
  var length = stream.get_length()
  
  var random = RandomNumberGenerator.new()
  
  random.randomize()
  next.play(random.randi_range(0, length))
  self.nextBackgroundPlayer = 1 if self.nextBackgroundPlayer == 0 else 0
