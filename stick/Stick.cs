using Godot;

public class KSStick
{
    private Node InternalNode;

    public KSStick(Node node)
    {
        InternalNode = node;
    }

    public Vector2 Output()
    {
        return (Vector2)InternalNode.Get("output");
    }
}