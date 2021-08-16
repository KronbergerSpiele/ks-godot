using Godot;
using System;

public class KSPage
{
    private Node InternalNode;

    public KSPage(Node node, ImageTexture texture)
    {
        InternalNode = node;
        InternalNode.Call("startWith", texture, texture);
    }
}