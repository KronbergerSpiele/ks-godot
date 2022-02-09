export default class Page extends Node2D {
  @exports
  frontTexture: ImageTexture | null = null;
  @exports
  backTexture: ImageTexture | null = null;

  lastTexture: ImageTexture | null = null;

  passedTime: float = 0.0;
  processTicks: int = 0;

  private get Screen() {
    return this.get_node("Screen");
  }

  private get Viewport() {
    return this.get_node("Viewport");
  }

  private get FrontMaterial() {
    return (this.get_node("Viewport/Front").mesh as PlaneMesh)
      .material as ShaderMaterial;
  }

  private get BackMaterial() {
    return (this.get_node("Viewport/Back").mesh as PlaneMesh)
      .material as ShaderMaterial;
  }

  _enter_tree() {
    if (this.frontTexture || this.backTexture) {
      this.startWith(this.frontTexture, this.backTexture);
    }
  }

  _process(delta: float) {
    this.passedTime = clamp(this.passedTime + delta, 0, 1);
    this.FrontMaterial.set_shader_param("time", this.passedTime);
    this.BackMaterial.set_shader_param("time", this.passedTime);
    const texture = this.Viewport.get_texture();
    this.Screen.texture = texture;
    if (this.passedTime >= 1) {
      this.removeOneself();
    }
  }

  startWith(front: ImageTexture | null, back: ImageTexture | null) {
    if (front || back) {
      this.FrontMaterial.set_shader_param("tex", front);
      this.BackMaterial.set_shader_param("tex", back);
    } else {
      this.removeOneself();
    }
  }

  removeOneself() {
    this.get_parent().remove_child(this);
  }
}
