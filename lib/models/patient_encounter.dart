
import 'package:drug_delivery/models/encounter.dart';
import 'package:drug_delivery/models/patient.dart';

class PatientEncounter{
  Patient patient;
  Encounter encounter;

  PatientEncounter({this.patient, this.encounter});

  factory PatientEncounter.fromMap(Map<String, dynamic> mp) {
    return PatientEncounter(
        patient: Patient.fromMap(mp["patient"]),
        encounter: Encounter.fromMap(mp["encounter"])
    );
  }

  Map<String, dynamic>  toMap(int userId) {
    return {
      'patient': patient.toMapPost(),
      'encounter': encounter.toMapPost(userId),
    };
  }
}