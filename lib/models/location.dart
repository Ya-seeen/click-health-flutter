
class Location {
  int id;
  int locationId;
  int parentId;
  String name;
  String code;
  String tag;

  Location({
    this.id,
    this.locationId,
    this.parentId,
    this.name,
    this.code,
    this.tag
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      name: map["name"] as String,
      id: map["id"] as int,
      parentId: map["parent"] as int,
      code: map["code"] as String,
      tag: map["tag"] as String
    );
  }

  factory Location.fromMapLocal(Map<String, dynamic> map) {
    return Location(
        name: map["name"] as String,
        locationId: map["id"] as int,
        parentId: map["parent_id"] as int,
        code: map["code"] as String,
        tag: map["tag"] as String
    );
  }

  Map<String, dynamic>  toMap() {
    return {
      'name': name,
      'id': id,
      'parent_id': parentId,
      'code': code,
      'tag': tag
    };
  }

  Map<String, dynamic>  toMapLocal() {
    return {
      'name': name,
      'location_id': id,
      'parent_id': parentId,
      'code': code,
      'tag': tag
    };
  }
}