import 'package:drug_delivery/database/database_provider.dart';
import 'package:drug_delivery/models/patient.dart';
import 'package:drug_delivery/models/user.dart';
import 'package:sqflite/sqflite.dart';

class PatientDao{

  final dbProvider = DatabaseProvider.dbProvider;
  String colId = DatabaseProvider.colId;
  String colPatientId = DatabaseProvider().colPatientId;

  // Get number of Patient objects in database
  Future<int> getCount() async {
    Database db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $patientTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> insert(Patient patient) async {
    Database db = await dbProvider.database;
    var result = await db.insert(patientTable, patient.toMap());
    return result;
  }

  Future<int> deleteAll() async {
    Database db = await dbProvider.database;
    int x = await db.rawDelete('delete from $patientTable');
    return x;
  }

  Future<List<Map<String, dynamic>>> getPatient() async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery('SELECT * FROM $patientTable ORDER BY $colPatientId DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getPatientWithStatus() async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery('select e.doctor_approve_status status, p.* from $patientTable p, $encounterTable e where p.patient_id = e.patient_id order by p.patient_id DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getTodaysPatientWithStatus() async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery("select e.doctor_approve_status status, p.* from $patientTable p, $encounterTable e where p.patient_id = e.patient_id and date(p.created_date) = date('now', 'localtime') order by p.patient_id DESC");
    return result;
  }

  Future<List<dynamic>> batchInsertOrUpdate(List<Patient> patients) async {
    Database db = await dbProvider.database;
    var batch = db.batch();
    int length = patients.length;
    for(int i = 0; i < length; i++) {
      int patientId = patients[i].patientId;
      var isExistPatient = await findByPatientId(patientId);
      if(isExistPatient == null) {
        await batch.insert(patientTable, patients[i].toMapLocal(null));
      } else {
        await batch.update(patientTable, patients[i].toMapLocal(isExistPatient['id'] as int), where: '$colPatientId = $patientId');
      }
    }
    dynamic results = await batch.commit();
    return results;
  }

  Future<Map<String, dynamic>> findByPatientId(int patientId) async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery('SELECT * FROM $patientTable WHERE $colPatientId = $patientId');
    return result.length > 0?result[0]:null;
  }
}