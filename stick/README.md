# Kronberger Spiele Joystick

## Installation

Recommende usage:
Add as submodule within your project.

You can either use the straight GDScript implementation, for which you just instantiate the Stick.tscn scene.

Or use the C# Wrapper which you initialize with the following within the Node instantiating it:

```
public KSStick Stick;

public override void _Ready()
{
   base._Ready();
   Stick = new KSStick(
        GetNode("UI/Stick")
    );
}
```

To add the files to your `Project.csproj` you can use:

```
  <ItemGroup>
    <Compile Include="addons\**\*.cs" />
  </ItemGroup>
```

## Usage

TODO