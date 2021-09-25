import java.util.ArrayList;
import java.util.List;


BoundingCircle bc;
Polygon poly;
String objData = "v -1.000000 -1.000000 0.000000"
  + "\nv 1.000000 -1.000000 0.000000"
  + "\nv -1.505155 1.137769 0.000000"
  + "\nv 3.365042 2.033271 0.000000"
  + "\nv -0.678538 3.893158 0.000000"
  + "\nv -5.408622 3.824274 0.000000"
  + "\nv -8.301780 0.265230 0.000000"
  + "\nv -5.615276 -4.097469 0.000000"
  + "\nv 7.495781 -0.102155 0.000000"
  + "\nv 6.003279 0.196345 0.000000"
  + "\nv -0.104498 -1.801312 0.000000"
  + "\nl 3 5"
  + "\nl 1 2"
  + "\nl 2 4"
  + "\nl 4 3"
  + "\nl 5 6"
  + "\nl 6 7"
  + "\nl 7 8"
  + "\nl 8 9"
  + "\nl 9 10"
  + "\nl 10 11"
  + "\nl 11 1";


void setup() {
  size(1000, 600);
  bc = new BoundingCircle(new PVector(0, 0), 30);
  poly = new Polygon(objData, 60, 500, 300);

  noFill();
  
}

void draw() {
  background(0);
  bc.set(new PVector(mouseX, mouseY), 20);
  stroke(255);
  strokeWeight(1);
  boolean inside = poly.bcInside(bc);


  pushMatrix();
  if (inside) {
    stroke(255, 0, 0);
    strokeWeight(1);
  } else {
    stroke(255);
    strokeWeight(1);
  }
  poly.render();
  bc.render();
  popMatrix();
}
