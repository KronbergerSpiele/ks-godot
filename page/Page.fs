namespace KSGodot

open Godot

type Page(internalNode: Node, texture: ImageTexture) =
    do
        internalNode.Call("startWith", texture, texture)
        |> ignore
