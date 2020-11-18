import 'package:drug_delivery/database/database_provider.dart';
import 'package:drug_delivery/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao{

  final dbProvider = DatabaseProvider.dbProvider;
  String colId = DatabaseProvider.colId;

  // Get number of Patient objects in database
  Future<int> getCount() async {
    Database db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $userTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> insert(User user) async {
    Database db = await dbProvider.database;
    var result = await db.insert(userTable, user.toMapLocal());
    return result;
  }

  Future<int> deleteAll() async {
    Database db = await dbProvider.database;
    int x = await db.rawDelete('delete from $userTable');
    return x;
  }

  Future<List<Map<String, dynamic>>> getUser() async {
    final Database db = await dbProvider.database;
    var result = await db.rawQuery('SELECT * FROM $userTable');
    return result;
  }

}