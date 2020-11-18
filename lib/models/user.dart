
class User {
  int userId;
  String firstName;
  String lastName;
  String email;
  String username;
  String mobile;
  String gender;
  String medicalRegistrationNumber;
  String address;

  User({
    this.userId,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.gender,
    this.medicalRegistrationNumber,
    this.address
  });

  factory User.fromMap(Map<String, dynamic> mp) {
    return User(
      userId: mp["id"] as int,
      firstName: mp["firstName"] as String,
      lastName: mp["lastName"] as String,
      email: mp["email"] as String,
      mobile: mp["mobile"] as String,
      username: mp["username"] as String,
      gender: mp["gender"] as String,
      address: mp["address"] as String,
      medicalRegistrationNumber: mp["medicalRegistrationNumber"] as String,
    );
  }

  factory User.fromMapLocal(Map<String, dynamic> mp) {
    return User(
      userId: mp["id"] as int,
      firstName: mp["first_name"] as String,
      lastName: mp["last_name"] as String,
      email: mp["email"] as String,
      mobile: mp["mobile"] as String,
      username: mp["username"] as String,
      gender: mp["gender"] as String,
      address: mp["address"] as String,
      medicalRegistrationNumber: mp["medical_registration_number"] as String,
    );
  }


  Map<String, dynamic>  toMap() {
    return {
      'id': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobile': mobile,
      'username': username,
      'gender': gender,
      'address': address,
      'medicalRegistrationNumber':medicalRegistrationNumber
    };
  }

  Map<String, dynamic>  toMapLocal() {
    return {
      'id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'username': username,
      'gender': gender,
      'address': address,
      'medical_registration_number':medicalRegistrationNumber
    };
  }
}