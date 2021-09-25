class Actor {

  PVector position;
  PVector dir;
  Quaternion rotation;
  BoundingCircle bc;
  PShape graphics;
  float SIZE = 10;

  Actor(BoundingCircle bc) {
    this.bc = bc;
    graphics = loadShape("arrow.svg");
    position = new PVector(0, 0);
    dir = new PVector(0, 0);
    rotation = new Quaternion();
  }

  void rotate(float ratio) {
    graphics.rotate(ratio);
    
  }
  
  void move(float ratio) {
  
  }


  void render() {

    shape(graphics, position.x, position.y, position.x + SIZE, position.x + SIZE);
  }
}
