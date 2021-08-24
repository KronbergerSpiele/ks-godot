module KSGodotUtils

open Godot

type Node with
    member this.getNode<'a when 'a :> Node>(path: string) = this.GetNode(new NodePath(path)) :?> 'a
    member this.hasNode(path: string) = this.HasNode(new NodePath(path))

type Node2D with
    member this.getNode<'a when 'a :> Node>(path: string) = this.GetNode(new NodePath(path)) :?> 'a
    member this.hasNode(path: string) = this.HasNode(new NodePath(path))
