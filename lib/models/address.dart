
class Address {
  String name;
  double latitude;
  double longitude;

  Address({
    this.name,
    this.latitude,
    this.longitude
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      name: map["name"] as String,
      latitude: map["latitude"] as double,
      longitude: map["longitude"] as double,
    );
  }

  Map<String, dynamic>  toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}