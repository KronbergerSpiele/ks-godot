namespace KSGodot.Audio

open Godot
open KSGodotUtils
open System

type BackgroundAudio() =
    inherit Node()

    member this.BackgroundPlayer0() =
        this.getNode<AudioStreamPlayer> ("Background0")

    member this.BackgroundPlayer1() =
        this.getNode<AudioStreamPlayer> ("Background1")

    member val nextBackgroundPlayer = 0 with get, set
    member val currentBackgroundResourcePath = "" with get, set

    member this.PlayBackground(stream: AudioStream) =

        if stream.ResourcePath = this.currentBackgroundResourcePath then
            ()
        else
            this.currentBackgroundResourcePath <- stream.ResourcePath

            let currentPlayer =
                if this.nextBackgroundPlayer = 0 then
                    this.BackgroundPlayer1()
                else
                    this.BackgroundPlayer0()

            let nextPlayer =
                if this.nextBackgroundPlayer = 0 then
                    this.BackgroundPlayer0()
                else
                    this.BackgroundPlayer1()

            currentPlayer.Stop()
            nextPlayer.Stop()
            nextPlayer.Stream <- stream
            let length = stream.GetLength()
            let random = Random()
            nextPlayer.Play(float32 (random.Next(int length)))

            this.nextBackgroundPlayer <-
                if this.nextBackgroundPlayer = 0 then
                    1
                else
                    0
