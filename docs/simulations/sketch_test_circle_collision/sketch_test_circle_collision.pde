import java.util.ArrayList;
import java.util.List;


BoundingCircle bc;
Polygon perimeter;
Polygon obstacles;
Collisor collisor;
float moveRatio = 0;
float rotRatio = 0;


void setup() {
  size(1000, 600);
  bc = new BoundingCircle(new PVector(0, 0), 30);
  String objData =  new String(loadBytes("perimeter.obj"));
  String objData2 =  new String(loadBytes("obstacles.obj"));
  perimeter = new Polygon(objData, 40, 500, 100);
  obstacles = new Polygon(objData2, 40, 500, 100);
  collisor = new Collisor(new Actor(), perimeter, obstacles, bc);
  collisor.setPosition(new PVector(300, 200));
  noFill();
}


void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
    case DOWN:
      moveRatio = 0.0;
      break;
    case LEFT:
    case RIGHT:
      rotRatio = 0.0;
      break;
    }
  }
}


void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      moveRatio = 2;
      break;
    case DOWN:
      moveRatio = -2;
      break;
    case LEFT:
      rotRatio = -0.1;
      break;
    case RIGHT:
      rotRatio = 0.1;
      break;
    }
  }
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(1);

  pushMatrix();
  stroke(255);
  strokeWeight(1);
  perimeter.render();
  obstacles.render();
  collisor.render(moveRatio, rotRatio);
  popMatrix();
}
