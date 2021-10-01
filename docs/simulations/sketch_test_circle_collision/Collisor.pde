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
    PVector nextPos = actor.getPosition().copy();
    PVector dir = actor.getDir();
    nextPos.add(ratio * dir.x, ratio * dir.y);
    bc.set(new PVector(nextPos.x - actor.getSize().x / 2, nextPos.y - actor.getSize().x / 2), bc.radius);
    CollisionResponse cResp = polygon.bcInside(bc);
    boolean inside = !cResp.collided;
    if (inside) {
      actor.setPosition(nextPos);   
    } else {
      PVector correctPosition = correctPosition(actor.getPosition(), nextPos, cResp);
      actor.setPosition(correctPosition);
      bc.set(new PVector(correctPosition.x - actor.getSize().x / 2, correctPosition.y - actor.getSize().x / 2), bc.radius);
    }
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
