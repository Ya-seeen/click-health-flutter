class Encounter {
  int id;
  int encounterId;
  String beforeMeals;
  String advice;
  String uponWalking;
  String bloodPressure;
  String doctorApproveStatus;
  String pastMedicalHistory;
  String ninetyMinAfterMeals;
  String doctorName;
  String height;
  String familyHistory;
  String bmdc;
  String respiratoryRate;
  String weight;
  String medication;
  String token;
  String targetLevelsByType;
  String bodyTemperature;
  String diagnosis;
  String chiefComplaint;
  String background;
  int patientId;
  String pulse;
  String bsl;
  String socialHistory;
  String test;
  int timestamp;
  String others;

  Encounter({
    this.id,
    this.encounterId,
    this.beforeMeals,
    this.advice,
    this.uponWalking,
    this.bloodPressure,
    this.doctorApproveStatus,
    this.pastMedicalHistory,
    this.ninetyMinAfterMeals,
    this.doctorName,
    this.height,
    this.familyHistory,
    this.bmdc,
    this.respiratoryRate,
    this.weight,
    this.medication,
    this.token,
    this.targetLevelsByType,
    this.bodyTemperature,
    this.diagnosis,
    this.chiefComplaint,
    this.background,
    this.patientId,
    this.pulse,
    this.bsl,
    this.socialHistory,
    this.test,
    this.timestamp,
    this.others
  });

  factory Encounter.fromMap(Map<String, dynamic> mp) {
    return Encounter(
        encounterId: mp["id"] as int,
        beforeMeals: mp["before_meals"] as String,
        advice: mp["advice"] as String,
        uponWalking: mp["upon_walking"] as String,
        bloodPressure: mp["blood_pressure"] as String,
        doctorApproveStatus: mp["doctor_approve_status"] as String,
        pastMedicalHistory: mp["past_medical_history"] as String,
        ninetyMinAfterMeals: mp["ninety_min_after_meals"] as String,
        doctorName: mp["doctor_name"] as String,
        height: mp["height"] as String,
        familyHistory: mp["family_history"] as String,
        bmdc: mp["bmdc"] as String,
        respiratoryRate: mp["resperatory_rate"] as String,
        weight: mp["weight"] as String,
        medication: mp["medication"] as String,
        token: mp["token"] as String,
        targetLevelsByType: mp["target_levels_by_type"] as String,
        bodyTemperature: mp["body_temperature"] as String,
        diagnosis: mp["diagonsis"] as String,
        chiefComplaint: mp["chief_complaint"] as String,
        background: mp["background"] as String,
        patientId: mp["patient_id"] as int,
        pulse: mp["pulse"] as String,
        bsl: mp["bsl"] as String,
        socialHistory: mp["social_history"] as String,
        test: mp["test"] as String,
        timestamp: mp["timestamp"] as int
    );
  }

  factory Encounter.fromMapLocal(Map<String, dynamic> mp) {
    return Encounter(
      id: mp["id"] as int,
      encounterId: mp["encounter_id"] as int,
      beforeMeals: mp["before_meals"] as String,
      advice: mp["advice"] as String,
      uponWalking: mp["upon_walking"] as String,
      bloodPressure: mp["blood_pressure"] as String,
      doctorApproveStatus: mp["doctor_approve_status"] as String,
      pastMedicalHistory: mp["past_medical_history"] as String,
      ninetyMinAfterMeals: mp["ninety_min_after_meals"] as String,
      doctorName: mp["doctor_name"] as String,
      height: mp["height"] as String,
      familyHistory: mp["family_history"] as String,
      bmdc: mp["bmdc"] as String,
      respiratoryRate: mp["resperatory_rate"] as String,
      weight: mp["weight"] as String,
      medication: mp["medication"] as String,
      token: mp["token"] as String,
      targetLevelsByType: mp["target_levels_by_type"] as String,
      bodyTemperature: mp["body_temperature"] as String,
      diagnosis: mp["diagonsis"] as String,
      chiefComplaint: mp["chief_complaint"] as String,
      background: mp["background"] as String,
      patientId: mp["patient_id"] as int,
      pulse: mp["pulse"] as String,
      bsl: mp["bsl"] as String,
      socialHistory: mp["social_history"] as String,
      test: mp["test"] as String,
      timestamp: mp["timestamp"] as int,
    );
  }

  Map<String, dynamic>  toMap() {
    return {
      'id': encounterId,
      'before_meals': beforeMeals,
      'advice': advice,
      'upon_walking': uponWalking,
      'blood_pressure': bloodPressure,
      'doctor_approve_status': doctorApproveStatus,
      'past_medical_history': pastMedicalHistory,
      'ninety_min_after_meals': ninetyMinAfterMeals,
      'doctor_name': doctorName,
      'height': height,
      'family_history': familyHistory,
      'bmdc': bmdc,
      'resperatory_rate': respiratoryRate,
      'weight': weight,
      'medication': medication,
      'token': token,
      'target_levels_by_type': targetLevelsByType,
      'body_temperature': bodyTemperature,
      'diagonsis': diagnosis,
      'chief_complaint': chiefComplaint,
      'background': background,
      'patient_id': patientId,
      'pulse': pulse,
      'bsl': bsl,
      'social_history': socialHistory,
      'test': test,
      'timestamp': timestamp
    };
  }

  Map<String, dynamic>  toMapLocal(id) {
    return {
      'id': id,
      'encounter_id': encounterId,
      'before_meals': beforeMeals,
      'advice': advice,
      'upon_walking': uponWalking,
      'blood_pressure': bloodPressure,
      'doctor_approve_status': doctorApproveStatus,
      'past_medical_history': pastMedicalHistory,
      'ninety_min_after_meals': ninetyMinAfterMeals,
      'doctor_name': doctorName,
      'height': height,
      'family_history': familyHistory,
      'bmdc': bmdc,
      'resperatory_rate': respiratoryRate,
      'weight': weight,
      'medication': medication,
      'token': token,
      'target_levels_by_type': targetLevelsByType,
      'body_temperature': bodyTemperature,
      'diagonsis': diagnosis,
      'chief_complaint': chiefComplaint,
      'background': background,
      'patient_id': patientId,
      'pulse': pulse,
      'bsl': bsl,
      'social_history': socialHistory,
      'test': test,
      'timestamp': timestamp
    };
  }


  Map<String, dynamic>  toMapPost(int userId) {
    return {
      'id': encounterId==null?0:encounterId,
      'blood_pressure': bloodPressure,
      'bsl': bsl,
      'height': height,
      'resperatory_rate': respiratoryRate,
      'weight': weight,
      'body_temperature': bodyTemperature,
      'profile': userId,
      'pulse': pulse,
      'doctor_approve_status': 'In queue',
      'others': others
    };
  }
}