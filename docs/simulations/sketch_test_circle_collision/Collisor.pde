class Collisor {
  Actor actor;
  Polygon perimeter;
  Polygon obstacles;
  BoundingCircle bc;


  Collisor(Actor actor, Polygon perimeter, Polygon obstacles, BoundingCircle bc) {
    this.bc = bc;
    this.actor = actor;
    this.perimeter = perimeter;
    this.obstacles = obstacles;
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
    CollisionResponse cResp = perimeter.bcInside(bc);
    boolean inside = !cResp.collided;
    if (inside) {
      actor.setPosition(nextPos);
    } else {
      PVector correctPosition = correctPosition(actor.getPosition(), nextPos, cResp);
      bc.set(new PVector(correctPosition.x - actor.getSize().x / 2, correctPosition.y - actor.getSize().x / 2), bc.radius);
      // SAFE CHECK FOR CORNERS - se dopo la correzione si finisce fuori perimetro (in caso di angoli tra lati) si resetta la posizione precedente
      if (perimeter.bcInside(bc).collided) {
        bc.set(new PVector(actor.getPosition().x - actor.getSize().x / 2, actor.getPosition().y - actor.getSize().x / 2), bc.radius);
      } else {
        actor.setPosition(correctPosition);
      }
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
