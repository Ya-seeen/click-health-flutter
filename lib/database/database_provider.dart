import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final userTable = 'user';
final locationTable = 'location';
final patientTable = 'patient';
final encounterTable = 'encounter';
final int _databaseVersion = 1;
class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  static final String colId = 'id';

  //user
  String colUserId = 'user_id';
  String colFirstName = 'first_name';
  String colLastName = 'last_name';
  String colMobile = 'mobile';
  String colUsername = 'username';
  String colEmail = 'email';
  String colGender = 'gender';
  String colAddress = 'address';
  String colMedicalRegistrationNumber = 'medical_registration_number';

  //location
  String colLocationId = 'location_id';
  String colName = 'name';
  String colCode = 'code';
  String colParentId = 'parent_id';
  String colTag = 'tag';

  //patient
  String colPatientId = 'patient_id';
  String colFamilyHistory = 'family_history';
  String colYear = 'year';
  String colMonth = 'month';
  String colSocialHistory = 'social_history';
  String colPastMedicalHistory = 'past_medical_history';
  String colMobileNumber = 'mobile_number';
  String colDistrictName = 'district_name';
  String colDistrictId = 'district_id';
  String colUpazilaName = 'upazila_name';
  String colUpazilaId = 'upazila_id';
  String colUnionName = 'union_name';
  String colUnionId = 'union_id';
  String colCreatedDate = 'created_date';
  String colTimestamp = 'timestamp';


  //encounter
  String colEncounterId = 'encounter_id';
  String colBeforeMeals = 'before_meals';
  String colAdvice = 'advice';
  String colUponWalking = 'upon_walking';
  String colBloodPressure = 'blood_pressure';
  String colDoctorApproveStatus = 'doctor_approve_status';
//  String colPastMedicalHistory;
  String colNinetyMinAfterMeals = 'ninety_min_after_meals';
  String colDoctorName = 'doctor_name';
  String colHeight = 'height';
//  String colFamilyHistory;
  String colBmdc = 'bmdc';
  String colRespiratoryRate = 'resperatory_rate';
  String colWeight = 'weight';
  String colMedication = 'medication';
  String colToken = 'token';
  String colTargetLevelsByType = 'target_levels_by_type';
  String colBodyTemperature = 'body_temperature';
  String colDiagnosis = 'diagonsis';
  String colChiefComplaint = 'chief_complaint';
  String colBackground = 'background';
//  String colPatientId;
  String colPulse = 'pulse';
  String colBsl = 'bsl';
//  String colSocialHistory;
  String colTest = 'test';

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "click_health_ngo.db");

    var database = await openDatabase(path, version: _databaseVersion,
        onCreate: initDB,
        onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
    }
  }

  void initDB(Database database, int version) async {
    await database.execute(
        'CREATE TABLE $userTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colUserId INTEGER, $colMobile TEXT, $colEmail TEXT, '
            '$colFirstName TEXT, $colLastName TEXT, $colUsername TEXT, $colGender TEXT, $colAddress TEXT, $colMedicalRegistrationNumber TEXT)');

    await database.execute(
        'CREATE TABLE $locationTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colLocationId INTEGER, '
            '$colName TEXT, $colCode TEXT, $colTag TEXT, $colParentId INTEGER)');

    await database.execute(
        'CREATE TABLE $patientTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colPatientId INTEGER, $colMobileNumber TEXT, $colFamilyHistory TEXT, '
            '$colName TEXT, $colSocialHistory TEXT, $colPastMedicalHistory TEXT, $colGender TEXT, $colYear INTEGER, $colMonth INTEGER, '
            '$colDistrictName TEXT, $colDistrictId INTEGER, $colUpazilaName TEXT, $colUpazilaId INTEGER, $colUnionName TEXT, $colUnionId INTEGER, $colCreatedDate TEXT, $colTimestamp INTEGER)');

    await database.execute(
        'CREATE TABLE $encounterTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colEncounterId INTEGER, $colBeforeMeals TEXT, $colAdvice TEXT, '
            '$colUponWalking TEXT, $colBloodPressure TEXT, $colDoctorApproveStatus TEXT, $colPastMedicalHistory TEXT, $colNinetyMinAfterMeals TEXT, '
            '$colDoctorName TEXT, $colHeight TEXT, $colFamilyHistory TEXT, $colBmdc TEXT, $colRespiratoryRate TEXT, $colWeight TEXT, '
            '$colMedication TEXT, $colToken TEXT, $colTargetLevelsByType TEXT, $colBodyTemperature TEXT, $colDiagnosis TEXT, $colChiefComplaint TEXT, '
            '$colBackground TEXT, $colPatientId INTEGER, $colPulse TEXT, $colBsl TEXT, $colSocialHistory TEXT, $colTest TEXT, $colTimestamp INTEGER)');
  }
}