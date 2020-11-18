class Patient {
  int id;
  int patientId;
  String name;
  String mobileNumber;
  String gender;
  String familyHistory;
  int year;
  int month;
  String socialHistory;
  String pastMedicalHistory;
  String districtName;
  int districtId;
  String upazilaName;
  int upazilaId;
  String unionName;
  int unionId;
  String createdDate;
  int timestamp;
  String status;

  Patient({
    this.id,
    this.patientId,
    this.name,
    this.mobileNumber,
    this.gender,
    this.familyHistory,
    this.year,
    this.month,
    this.socialHistory,
    this.pastMedicalHistory,
    this.districtName,
    this.districtId,
    this.upazilaName,
    this.upazilaId,
    this.unionName,
    this.unionId,
    this.createdDate,
    this.timestamp,
    this.status
  });

  factory Patient.fromMap(Map<String, dynamic> mp) {
    return Patient(
        patientId: mp["id"] as int,
        name: mp["name"] as String,
        mobileNumber: mp["mobile_number"] as String,
        familyHistory: mp["family_history"] as String,
        socialHistory: mp["social_history"] as String,
        pastMedicalHistory: mp["past_medical_history"] as String,
        year: mp["year"] as int,
        month: mp["month"] as int,
        gender: mp["gender"] as String,
        districtName: mp['district'] as String,
        districtId: mp['district_id'] as int,
        upazilaName: mp['upazila'] as String,
        upazilaId: mp['upazila_id'] as int,
        unionName: mp['union'] as String,
        unionId: mp['union_id'] as int,
        timestamp: mp['timestamp'] as int,
        createdDate: mp['created_date'] as String,
    );
  }

  factory Patient.fromMapLocal(Map<String, dynamic> mp) {
    return Patient(
      id: mp["id"] as int,
      patientId: mp["patient_id"] as int,
      name: mp["name"] as String,
      mobileNumber: mp["mobile_number"] as String,
      familyHistory: mp["family_history"] as String,
      socialHistory: mp["social_history"] as String,
      pastMedicalHistory: mp["past_medical_history"] as String,
      year: mp["year"] as int,
      month: mp["month"] as int,
      gender: mp["gender"] as String,
      districtName: mp['district_name'] as String,
      districtId: mp['district_id'] as int,
      upazilaName: mp['upazila_name'] as String,
      upazilaId: mp['upazila_id'] as int,
      unionName: mp['union_name'] as String,
      unionId: mp['union_id'] as int,
      timestamp: mp['timestamp'] as int,
      createdDate: mp['created_date'] as String,
      status: mp['status'] as String,
    );
  }

  Map<String, dynamic>  toMap() {
    return {
      'id': patientId,
      'name': name,
      'mobile_number': mobileNumber,
      'gender': gender,
      'family_history': familyHistory,
      'social_history': socialHistory,
      'past_medical_history': pastMedicalHistory,
      'year': year,
      'month': month,
      'district': districtName,
      'district_id': districtId,
      'upazila': upazilaName,
      'upazila_id': upazilaId,
      'union': unionName,
      'union_id': unionId,
      'timestamp': timestamp,
      'created_date': createdDate,
    };
  }

  Map<String, dynamic>  toMapLocal(int id) {
    return {
      'id': id,
      'patient_id': patientId,
      'name': name,
      'mobile_number': mobileNumber,
      'gender': gender,
      'family_history': familyHistory,
      'social_history': socialHistory,
      'past_medical_history': pastMedicalHistory,
      'year': year,
      'month': month,
      'district_name': districtName,
      'district_id': districtId,
      'upazila_name': upazilaName,
      'upazila_id': upazilaId,
      'union_name': unionName,
      'union_id': unionId,
      'timestamp': timestamp,
      'created_date': createdDate,
    };
  }

  Map<String, dynamic>  toMapPost() {
    print("IN MAPPER: "+patientId.toString());
    return {
      'id': patientId==null?0:patientId,
      'name': name,
      'mobile_number': mobileNumber,
      'gender': gender,
      'year': year.toString(),
      'month': month.toString(),
      'district': districtName,
      'district_id': districtId,
      'upazila': upazilaName,
      'upazila_id': upazilaId,
      'unions': unionName,
      'union_id': unionId
    };
  }

}