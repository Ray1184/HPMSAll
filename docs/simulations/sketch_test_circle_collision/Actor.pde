class Actor {

  PVector SIZE = new PVector(20, 20);
  float BC_SIZE = 30;
  PVector AXIS = new PVector(0, 0, 1);
  PVector position;
  PVector dir;
  PVector bcPosition = new PVector();
  Quaternion rotation;
  BoundingCircle bc;
  PShape graphics;
  float currentRot;

  Actor(BoundingCircle bc) {
    this.bc = bc;    
    position = new PVector(0, 0);
    dir = new PVector(0, -1);
    rotation = new Quaternion();
    graphics = loadShape("arrow.svg");
    shapeMode(CENTER);
    graphics.rotate(0);
  }

  void setPosition(PVector pos) {
    position.set(pos);
  }

  void rotate(float ratio) {
    pushMatrix();
    graphics.rotate(ratio);
    dir.rotate(ratio);
    popMatrix();
  }

  void move(float ratio) {
    position.add(ratio * dir.x, ratio * dir.y, 1);    
  }

  BoundingCircle getBc() {
    return bc;
  }

  void render(float moveRatio, float rotRatio) {
    rotate(rotRatio);
    bcPosition.set(position.x - SIZE.x / 2, position.y - SIZE.y / 2);
    bc.set(bcPosition, 20);
    bc.render();
    shape(graphics, position.x, position.y, SIZE.x, SIZE.y);
  }
}
