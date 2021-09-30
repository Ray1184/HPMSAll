class Polygon {

  PVector[] perimeter;

  Polygon(String data, float factor, float tx, float ty) {
    perimeter = loadSortedSizesObj(data, factor, tx, ty);
  }

  PVector[] loadSortedSizesObj(String data, float factor, float tx, float ty) {
    String[] lines = data.split("\n");
    List<PVector> sortedData = new ArrayList<PVector>();
    List<PVector> vertices = new ArrayList<PVector>();
    List<PVector> sides = new ArrayList<PVector>();
    for (String line : lines) {
      char type = line.charAt(0);
      String content = line.substring(2).trim();
      String[] tokens = content.split(" ");
      switch (type) {
      case 'v':
        vertices.add(new PVector(Float.parseFloat(tokens[0]) * factor + tx, Float.parseFloat(tokens[1]) * factor + ty, Float.parseFloat(tokens[2]) * factor));
        break;
      case 'l':
        sides.add(new PVector(Integer.parseInt(tokens[0]), Integer.parseInt(tokens[1])));
        break;
      }
    }

    assert(sides.size() > 2); // at least a triangle
    Integer first = int(sides.get(0).x);
    Integer second = int(sides.get(0).y);
    PVector vertA = vertices.get(first - 1);
    PVector vertB = vertices.get(second - 1);
    Integer lastIndex = second;
    sortedData.add(vertA);
    sortedData.add(vertB);

    for (int i = 1; i < sides.size(); i++) {
      Integer next = getNextIndex(lastIndex, sides);
      PVector vert = vertices.get(next - 1);
      sortedData.add(vert);
      lastIndex = next;
    }


    return sortedData.toArray(new PVector[sortedData.size()]);
  }

  Integer getNextIndex(Integer index, List<PVector> sides) {

    for (PVector side : sides) {
      if (int(side.x) == index) {
        return int(side.y);
      }
    }
    println("SIDE NOT FOUND WITH INDEX " + index);
    return null;
  }

  CollisionResponse bcInside(BoundingCircle bc) {
    return circleInsidePolygon(bc, perimeter, new PVector(0, 0));
  }

  void render() {
    for (int i = 0; i < perimeter.length - 1; i++) {
      line((perimeter[i].x), (perimeter[i].y), (perimeter[i + 1].x), (perimeter[i + 1].y));
    }
  }
}
