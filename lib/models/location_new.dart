
class LocationNew {
  int id;
  String name;

  LocationNew({
      this.id,
      this.name
  });

  factory LocationNew.fromMap(Map<String, dynamic> map) {
    return LocationNew(
      id: map["id"] as int,
      name: map["name"] as String,
    );
  }

  Map<String, dynamic>  toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}