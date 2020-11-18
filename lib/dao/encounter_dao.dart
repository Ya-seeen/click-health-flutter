import 'package:drug_delivery/database/database_provider.dart';
import 'package:drug_delivery/models/encounter.dart';
import 'package:drug_delivery/models/patient.dart';
import 'package:drug_delivery/models/user.dart';
import 'package:sqflite/sqflite.dart';

class EncounterDao{

  final dbProvider = DatabaseProvider.dbProvider;
  String colId = DatabaseProvider.colId;
  String colPatientId = DatabaseProvider().colPatientId;
  String colEncounterId = DatabaseProvider().colEncounterId;

  // Get number of Encounter objects in database
  Future<int> getCount() async {
    Database db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $encounterTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> insert(Encounter encounter) async {
    Database db = await dbProvider.database;
    var result = await db.insert(encounterTable, encounter.toMap());
    return result;
  }

  Future<int> deleteAll() async {
    Database db = await dbProvider.database;
    int x = await db.rawDelete('delete from $encounterTable');
    return x;
  }

  Future<List<Map<String, dynamic>>> getEncounter() async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery('SELECT * FROM $encounterTable ORDER BY $colId DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getEncounterByPatientId(int patientId) async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery('SELECT * FROM $encounterTable WHERE $colPatientId = $patientId');
    return result;
  }

  Future<List> batchInsertOrUpdate(List<Encounter> encounters) async {
    Database db = await dbProvider.database;
    var batch = db.batch();
    int length = encounters.length;
    for(int i = 0; i < length; i++) {
      int encounterId = encounters[i].encounterId;
      var isExistEncounter = await findByEncounterId(encounterId);
      if(isExistEncounter == null) {
        await batch.insert(encounterTable, encounters[i].toMapLocal(null));
      } else {
        await batch.update(encounterTable, encounters[i].toMapLocal(isExistEncounter['id'] as int), where: '$colEncounterId = $encounterId');
      }
    }
    dynamic results = await batch.commit();
    return results;
  }

  Future<Map<String, dynamic>> findByEncounterId(int encounterId) async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery('SELECT * FROM $encounterTable WHERE $colEncounterId = $encounterId');
    return result.length > 0?result[0]:null;
  }

}