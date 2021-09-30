class BoundingCircle {
  PVector origin;
  float radius;
  
  BoundingCircle(PVector origin, float radius) {
    this.origin = new PVector(0, 0);
    this.origin.set(origin);
    this.radius = radius;
  }


  void set(PVector origin, float radius) {
    this.origin.set(origin);
    this.radius = radius;
  }

  void render() {
    ellipseMode(CENTER);
    ellipse(origin.x, origin.y, radius * 2, radius * 2);
  }
}
