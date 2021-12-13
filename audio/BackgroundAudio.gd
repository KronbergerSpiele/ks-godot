
# This file has been autogenerated by ts2gd. DO NOT EDIT!


extends Node
class_name BackgroundAudio
    




var Player0 setget , Player0_get
var Player1 setget , Player1_get
func Player0_get():
  return self.get_node("Background0")
func Player1_get():
  return self.get_node("Background1")
var nextBackgroundPlayer: int = 0
var currentBackgroundResourcePath: String = ""
func playBackground(stream):
  if not stream:
    return
  
  if stream.resource_path == self.currentBackgroundResourcePath:
    return
  
  self.currentBackgroundResourcePath = stream.resource_path
  var current = self.Player1 if ((typeof(self.nextBackgroundPlayer) == typeof(0)) and (self.nextBackgroundPlayer == 0)) else self.Player0
  
  var next = self.Player0 if ((typeof(self.nextBackgroundPlayer) == typeof(0)) and (self.nextBackgroundPlayer == 0)) else self.Player1
  
  current.stop()
  next.stop()
  next.stream = stream
  var length = stream.get_length()
  
  var random = RandomNumberGenerator.new()
  
  random.randomize()
  next.play(random.randi_range(0, length))
  self.nextBackgroundPlayer = 1 if ((typeof(self.nextBackgroundPlayer) == typeof(0)) and (self.nextBackgroundPlayer == 0)) else 0
