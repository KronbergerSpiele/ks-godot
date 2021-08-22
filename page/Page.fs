namespace KSGodot

open Godot

type Page(internalNode: Node, texture: Option<ImageTexture>) =
    do
        match texture with
        | None -> internalNode.Call("startWith", null, null)
        | Some tex -> internalNode.Call("startWith", tex, tex)
        |> ignore
