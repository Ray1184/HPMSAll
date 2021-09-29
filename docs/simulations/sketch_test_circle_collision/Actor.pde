class Actor {

  PVector SIZE = new PVector(20, 20);
  
  PVector AXIS = new PVector(0, 0, 1);
  PVector position;
  PVector dir;
  Quaternion rotation;
  
  PShape graphics;
  float currentRot;

  Actor() {
     
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
  
  PVector getSize() {
    return SIZE;
  }

  void rotate(float ratio) {
    pushMatrix();
    graphics.rotate(ratio);
    dir.rotate(ratio);
    popMatrix();
  }
  
  PVector getPosition() {
    return position;
  }
  
  PVector getDir() {
    return dir;
  }


  void move(float ratio) {
    position.add(ratio * dir.x, ratio * dir.y);    
  }


  void render(float moveRatio, float rotRatio) {
    rotate(rotRatio);    
    shape(graphics, position.x, position.y, SIZE.x, SIZE.y);
  }
}
