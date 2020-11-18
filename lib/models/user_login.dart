import 'package:drug_delivery/models/address.dart';

class UserLogin {
  String username;
  String password;

  UserLogin({
    this.username,
    this.password
  });
//
//  factory User.fromSnapshot(DocumentSnapshot snapshot) {
//    return User(
//      firebaseId: snapshot["firebaseId"] as String,
//      firstName: snapshot["firstName"] as String,
//      lastName: snapshot["lastName"] as String,
//      emailAddress: snapshot["emailAddress"] as String,
//      mobile: snapshot["mobile"] as String,
//      profilePicture: snapshot["profilePicture"] as String,
//      firebaseToken: snapshot["firebaseToken"] as String,
//      addresses: (snapshot["addresses"] as List).map((e) => Address.fromMap(e)).toList(),
//    );
//  }

  Map<String, dynamic>  toMap() {
    return {
      'username': username,
      'password': password
    };
  }
}