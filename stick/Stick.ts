class Stick extends Node2D {
  @exports
  baseTexture: Texture = load("res://ksgodot/stick/base.png");
  @exports
  baseActiveTexture: Texture = load("res://ksgodot/stick/baseActive.png");
  @exports
  buttonTexture: Texture = load("res://ksgodot/stick/button.png");

  @exports
  maxDistance: int = 45;

  @exports
  output: Vector2 = Vector2.ZERO;

  get Base() {
    return this.get_node_unsafe<Sprite>("Base");
  }

  get Button() {
    return this.get_node_unsafe<Sprite>("Button");
  }

  _ready() {
    this.Base.texture = this.baseTexture;
    this.Button.texture = this.buttonTexture;
  }

  activateStick(touchedPosition: Vector2) {
    this.Base.texture = this.baseActiveTexture;
    this.position = touchedPosition;
  }

  deactiveStick() {
    this.Base.texture = this.baseTexture;
    this.Button.position = Vector2.ZERO;
    this.output = Vector2.ZERO;
  }

  updateStick(direction = Vector2.ZERO) {
    const clamped = direction.clamped(this.maxDistance);
    this.Button.position = clamped;
    this.output = clamped;
  }

  _unhandled_input(event: InputEvent) {
    if (event instanceof InputEventScreenTouch) {
      if (event.pressed) {
        this.activateStick(event.position);
      } else {
        this.deactiveStick();
      }
    } else if (event instanceof InputEventScreenDrag) {
      this.updateStick(event.position.sub(this.position));
    }
  }

  private wasKeyPressedBefore = false;
  _process() {
    let direction = Vector2.ZERO;
    if (Input.is_key_pressed(KeyList.KEY_LEFT)) {
      direction = direction.add(new Vector2(-1, 0));
    }
    if (Input.is_key_pressed(KeyList.KEY_RIGHT)) {
      direction = direction.add(new Vector2(1, 0));
    }
    if (Input.is_key_pressed(KeyList.KEY_UP)) {
      direction = direction.add(new Vector2(0, -1));
    }
    if (Input.is_key_pressed(KeyList.KEY_DOWN)) {
      direction = direction.add(new Vector2(0, 1));
    }

    if (Input.is_key_pressed(KeyList.KEY_SHIFT)) {
      direction = direction.mul(0.5);
    }

    if (direction.length() > 0) {
      this.wasKeyPressedBefore = true;
      this.updateStick(direction.mul(this.maxDistance));
    } else if (this.wasKeyPressedBefore) {
      this.wasKeyPressedBefore = false;
      this.updateStick();
    }
  }
}
