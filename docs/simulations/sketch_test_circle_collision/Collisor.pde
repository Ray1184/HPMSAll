class Collisor {
  Actor actor;
  Polygon polygon;
  BoundingCircle bc;
  

  Collisor(Actor actor, Polygon polygon, BoundingCircle bc) {
    this.bc = bc;   
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
    PVector nextPos = actor.getPosition().get();
    PVector dir = actor.getDir();
    nextPos.add(ratio * dir.x, ratio * dir.y);
    actor.move(ratio);
    bc.set(nextPos, 20);
    boolean inside = polygon.bcInside(bc);
    if (!inside) {
      
    }
    //if (inside) {
    //  actor.setPosition(shadow.getPosition());
    //} else {
    //  shadow.setPosition(actor.getPosition());
    //}
    //actor.move(ratio);
  }

  BoundingCircle getBc() {
    return bc;
  }

  void render(float moveRatio, float rotRatio) {
    move(moveRatio);
    actor.render(moveRatio, rotRatio);
    bc.set(new PVector(actor.getPosition().x - actor.getSize().x / 2, actor.getPosition().y - actor.getSize().x / 2), 20);
    bc.render();
  }
}
