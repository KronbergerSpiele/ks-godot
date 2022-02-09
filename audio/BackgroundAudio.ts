export default class BackgroundAudio extends Node {
  private get Player0() {
    return this.get_node("Background0");
  }
  private get Player1() {
    return this.get_node("Background1");
  }
  nextBackgroundPlayer = 0;
  currentBackgroundResourcePath = "";
  playBackground(stream: AudioStream | null) {
    if (!stream) return;
    if (stream.resource_path == this.currentBackgroundResourcePath) return;
    this.currentBackgroundResourcePath = stream.resource_path;
    const current =
      this.nextBackgroundPlayer == 0 ? this.Player1 : this.Player0;
    const next = this.nextBackgroundPlayer == 0 ? this.Player0 : this.Player1;
    current.stop();
    next.stop();
    next.stream = stream;
    const length = stream.get_length();
    let random = new RandomNumberGenerator();
    random.randomize();
    next.play(random.randi_range(0, length));
    this.nextBackgroundPlayer = this.nextBackgroundPlayer == 0 ? 1 : 0;
  }
}
