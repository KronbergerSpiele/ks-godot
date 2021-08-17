namespace KSGodot

open Godot

type Stick(internalNode: Node) =
    member this.Output() : Vector2 = internalNode.Get("output") :?> Vector2
