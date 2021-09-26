class Collisor {
  Actor actor;
  Polygon polygon;

  Collisor(Actor actor, Polygon polygon) {
    this.actor = actor;
    this.polygon = polygon;
  }

  void setPosition(PVector pos) {
    actor.setPosition(pos);
  }

  void rotate(float ratio) {
    actor.rotate(ratio);
  }

  void move(float ratio) {
    actor.move(ratio);
    boolean inside = polygon.bcInside(actor.getBc());
    println(inside);
    //if (inside) {
    //  actor.setPosition(shadow.getPosition());
    //} else {
    //  shadow.setPosition(actor.getPosition());
    //}
    //actor.move(ratio);
  }

  BoundingCircle getBc() {
    return actor.getBc();
  }

  void render(float moveRatio, float rotRatio) {
    move(moveRatio);
    actor.render(moveRatio, rotRatio);
  }
}
