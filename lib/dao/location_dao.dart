import 'package:drug_delivery/database/database_provider.dart';
import 'package:drug_delivery/models/location.dart';
import 'package:drug_delivery/models/location_new.dart';
import 'package:sqflite/sqflite.dart';

class LocationDao{

  final dbProvider = DatabaseProvider.dbProvider;
  String colId = DatabaseProvider.colId;

  Future<List<Map<String, dynamic>>> getLocation() async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery('SELECT * FROM $locationTable order by $colId ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getLocationByCode(String code) async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery('SELECT distinct * FROM $locationTable where (division_code = $code or district_code = $code or upazila_code = $code) order by $colId ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getDistrict() async {
    final Database db = await dbProvider.database;
    String query = "SELECT location_id id, name FROM $locationTable where tag = 'District' order by $colId ASC";
    print(query);
    var result = await db.rawQuery(query);
    return result;
  }

  Future<List<Map<String, dynamic>>> getLocationByParent(int parentId) async {
    final Database db = await dbProvider.database;
    String query = "SELECT location_id id, name FROM $locationTable where parent_id = $parentId order by $colId ASC";
    print("Query: "+query);
    var result = await db.rawQuery(query);
    return result;
  }

  // Insert Operation: Insert a Location object to database
  Future<int> insertLocation(Location location) async {
    Database db = await dbProvider.database;
    var result = await db.insert(locationTable, location.toMapLocal());
    return result;
  }

  Future<dynamic> batchInsert(List<Location> locationList) async {
    Database db = await dbProvider.database;
    dynamic batch = db.batch();
    for(int i = 0; i < locationList.length; i++) {
      batch.insert(locationTable, locationList[i].toMapLocal());
    }
    dynamic results = await batch.commit();
    return results;
  }

  Future<int> getCount() async {
    Database db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $locationTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}