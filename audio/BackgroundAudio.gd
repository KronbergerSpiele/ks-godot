# This file has been autogenerated by ts2gd. DO NOT EDIT!

extends Node
class_name BackgroundAudio

func player0():
  return self.get_node("Background0")
func player1():
  return self.get_node("Background1")
var nextBackgroundPlayer: int = 0
var currentBackgroundResourcePath: String = ""
func playBackground(stream):
  if not stream:
    
    return
  
  if stream.resource_path == self.currentBackgroundResourcePath:
    
    return
  
  self.currentBackgroundResourcePath = stream.resource_path
  var current = self.player1() if ((typeof(self.nextBackgroundPlayer) == typeof(0)) and (self.nextBackgroundPlayer == 0)) else self.player0()
  
  var next = self.player0() if ((typeof(self.nextBackgroundPlayer) == typeof(0)) and (self.nextBackgroundPlayer == 0)) else self.player1()
  
  current.stop()
  next.stop()
  next.stream = stream
  var length = stream.get_length()
  
  var random = RandomNumberGenerator.new()
  
  random.randomize()
  next.play(random.randi_range(0, length))
  self.nextBackgroundPlayer = 1 if ((typeof(self.nextBackgroundPlayer) == typeof(0)) and (self.nextBackgroundPlayer == 0)) else 0