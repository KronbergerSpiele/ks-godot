namespace KSGodot.Audio

open Godot

type LocalAudio() =
    inherit Node2D()

    member this.Play(stream: AudioStream, ?uniquifier: string) = ()
