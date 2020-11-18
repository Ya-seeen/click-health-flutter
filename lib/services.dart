import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:drug_delivery/dao/encounter_dao.dart';
import 'package:drug_delivery/dao/patient_dao.dart';
import 'package:drug_delivery/models/encounter.dart';
import 'package:drug_delivery/models/location.dart';
import 'package:drug_delivery/models/location_new.dart';
import 'package:drug_delivery/models/patient.dart';
import 'package:drug_delivery/models/patient_encounter.dart';
import 'package:drug_delivery/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dao/location_dao.dart';
import 'dao/user_dao.dart';
import 'models/user_login.dart';

class Services {
  static const String stagingUrl = 'https://clicktest.mpower-social.com/up/rest/api/v1';
  static const String prodUrl = 'http://clickhealth.mpower-social.com/up/rest/api/v1';
  static const String devUrl = 'http://192.168.22.249:8088/telemed/rest/api/v1';
  static const String baseUrl = stagingUrl;
  static const String loginUrl = '/user/login';
  static const String patientSyncUrl = '/patient/sync?userId=';
  static const String encounterSyncUrl = '/patient/encounter/sync?userId=';
  static const String locationSyncUrl = '/location/sync';
  static const String addAppointmentUrl = '/patient/mobile/add?username=';
//  static const String imageUploadUrl = '/patient/upload/';
  static const String imageUploadUrl = '/patient/upload/encouter/';

  Future<User> getUser() async {
    try {
      UserDao userDao = UserDao();
      var result = await userDao.getUser();
      List<User> users = List();
      users = result.map<User>((json) => User.fromMapLocal(json)).toList();
      return users.length>0?users[0]:null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<LocationNew>> getDistrict() async {
    try {
      LocationDao locationDao = LocationDao();
      var result = await locationDao.getDistrict();
      List<LocationNew> districts = List();
      districts = result.map<LocationNew>((json) => LocationNew.fromMap(json)).toList();
      return districts;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<LocationNew>> getLocationByParent(int parentId) async {
    try {
      LocationDao locationDao = LocationDao();
      var result = await locationDao.getLocationByParent(parentId);
      print("RESULT");
      print(result.length);
      List<LocationNew> locations = List();
      locations = result.map<LocationNew>((json) => LocationNew.fromMap(json)).toList();
      return locations;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<String> login(UserLogin userLogin) async {
    try {
      String username = userLogin.username;
      String password = userLogin.password;
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
      http.Response response = await http.get(
        baseUrl+loginUrl,
        headers: <String, String> {
          'Authorization': basicAuth
        },
      );
      Map<String, dynamic> responseMap = json.decode(response.body);
      if(response.statusCode == 200) {
        print(responseMap);
        Services.addStringToSF('user_id', responseMap['id'].toString());
        User user = User.fromMap(responseMap);
        UserDao userDao = UserDao();
        userDao.deleteAll();
        userDao.insert(user);
        return responseMap["message"];
      } else {
        throw Exception(responseMap["message"]);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  static Future<List<Patient>> getPatientList() async {
    try {
      List<Patient> patients = List();
      String username = await getStringValuesSF('username');
      String password = await getStringValuesSF('password');
      String userId = await getStringValuesSF('user_id');
      String patientTimestamp = await getStringValuesSF('patient_timestamp');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print("URL: "+baseUrl+patientSyncUrl+userId+'&timestamp='+patientTimestamp);
      http.Response response = await http.get(
          baseUrl+patientSyncUrl+userId+'&timestamp='+patientTimestamp,
        headers: <String, String>{
          'Authorization': basicAuth
        },
      );
      patients = parsePatient(response.body);
      PatientDao patientDao = PatientDao();
      await patientDao.batchInsertOrUpdate(patients);
      if(patients != null && patients.length > 0) {
        int size = patients.length;
        await Services.addStringToSF('patient_timestamp', patients[size-1].timestamp.toString());
        print("SIZE PATIENT LIST: "+size.toString());
        print("PATIENT LAST TIMESTAMP: "+patients[size-1].timestamp.toString());
      }
      return patients;
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  static Future<List<Patient>> getPatientListFromLocal() async {
    try {
      List<Patient> patients = List();
      PatientDao patientDao = PatientDao();
      List<Map<String, dynamic>> results = await patientDao.getPatientWithStatus();
      patients = results.map<Patient>((json) => Patient.fromMapLocal(json)).toList();
      return patients;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<Patient>> getTodaysPatientListFromLocal() async {
    try {
      List<Patient> patients = List();
      PatientDao patientDao = PatientDao();
      List<Map<String, dynamic>> results = await patientDao.getTodaysPatientWithStatus();
      patients = results.map<Patient>((json) => Patient.fromMapLocal(json)).toList();
      return patients;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<Encounter>> getEncounterList() async {
    try {
      List<Encounter> encounters = List();
      String username = await getStringValuesSF('username');
      String password = await getStringValuesSF('password');
      String userId = await getStringValuesSF('user_id');
      String encounterTimestamp = await getStringValuesSF('encounter_timestamp');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
      http.Response response = await http.get(
        baseUrl+encounterSyncUrl+userId+'&timestamp='+encounterTimestamp,
        headers: <String, String>{
          'Authorization': basicAuth
        },
      );
      encounters = parseEncounter(response.body);
      EncounterDao encounterDao = EncounterDao();
      await encounterDao.batchInsertOrUpdate(encounters);
      if(encounters != null && encounters.length > 0) {
        int size = encounters.length;
        await Services.addStringToSF('encounter_timestamp', encounters[size-1].timestamp.toString());
        print("SIZE ENCOUNTER LIST: "+size.toString());
        print("ENCOUNTER LAST TIMESTAMP: "+encounters[size-1].timestamp.toString());
      }
      return encounters;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<Encounter>> getEncounterListFromLocal(int patientId) async {
    try {
      List<Encounter> encounters = List();
      EncounterDao encounterDao = EncounterDao();
      List<Map<String, dynamic>> results = await encounterDao.getEncounterByPatientId(patientId);
      encounters = results.map<Encounter>((json) => Encounter.fromMapLocal(json)).toList();
      return encounters;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> addStringToSF(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getStringValuesSF(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  static Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Want to exit the app'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
            color: Theme.of(context).primaryColor,
          ),
          FlatButton(
            onPressed: () => exit(0),
            child: Text('Yes'),
            color: Colors.red,
          ),
        ],
      ),
    )) ?? false;
  }

  static Future<bool> onWillPopFromAddPatient(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Want to cancel the operation'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
            color: Theme.of(context).primaryColor,
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
            color: Colors.red,
          ),
        ],
      ),
    )) ?? false;
  }

  Future<int> checkOrInsertLocation() async {
    try {
      LocationDao locationDao = LocationDao();
      var result = await locationDao.getCount();
      if(result == 0) {
        String username = await getStringValuesSF('username');
        String password = await getStringValuesSF('password');
        String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
        http.Response response = await http.get(
          baseUrl+locationSyncUrl,
          headers: <String, String>{
            'Authorization': basicAuth
          },
        );
        final parsedLocationList = json.decode(response.body).cast<Map<String, dynamic>>();
        List<Location> locations = parsedLocationList.map<Location>((json) => Location.fromMap(json)).toList();
        await locationDao.batchInsert(locations);
      }
      return 1;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> postingFileToServer(String imagePath, String patientId) async {
    if(imagePath == null || imagePath == '')return "";
    final request = await http.MultipartRequest('POST', Uri.parse(baseUrl+imageUploadUrl+patientId+'/type'));
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    var response = await request.send();
    if(response.statusCode == 200){
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonBody = json.decode(responseBody);
      return jsonBody['map']['fileName'];
    } else {
      throw Exception("Image upload failed");
    }
  }

  Future<PatientEncounter> _uploadFiles(PatientEncounter patientEncounter, List<String> imagePaths) async {
    int patientId = patientEncounter.patient.patientId==null?0:patientEncounter.patient.patientId;
    patientEncounter.encounter.bloodPressure = await postingFileToServer(patientEncounter.encounter.bloodPressure, patientId.toString());
    patientEncounter.encounter.bsl = await postingFileToServer(patientEncounter.encounter.bsl, patientId.toString());
    patientEncounter.encounter.bodyTemperature = await postingFileToServer(patientEncounter.encounter.bodyTemperature, patientId.toString());
    patientEncounter.encounter.pulse = await postingFileToServer(patientEncounter.encounter.pulse, patientId.toString());
    patientEncounter.encounter.height = await postingFileToServer(patientEncounter.encounter.height, patientId.toString());
    patientEncounter.encounter.weight = await postingFileToServer(patientEncounter.encounter.weight, patientId.toString());
    List<String> others = List();
    for(int i = 0; i < imagePaths.length; i++) {
      others.add(await postingFileToServer(imagePaths[i], patientId.toString()));
    }
    patientEncounter.encounter.others = others.join(',');
    return patientEncounter;
  }

    Future<int> addAppointment(PatientEncounter patientEncounter, List<String> imagePaths) async {
    try {
      String userId = await getStringValuesSF('user_id');
      String username = await getStringValuesSF('username');
      String password = await getStringValuesSF('password');

      patientEncounter = await _uploadFiles(patientEncounter, imagePaths);

      String params = jsonEncode(patientEncounter.toMap(int.parse(userId)));
      print(params);
      final response = await http.post(
        baseUrl+addAppointmentUrl+username+'&'+'password='+password,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: params,
      );
      print("PRINTING RESPONSE");
      print(response.statusCode);
      print(response.body);
      final responseIds = json.decode(response.body);
      return 1;
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

}

List<Patient> parsePatient(String body) {
  final parsedPatients = json.decode(body).cast<Map<String, dynamic>>();
  return parsedPatients.map<Patient>((json) => Patient.fromMap(json)).toList();
}

List<Encounter> parseEncounter(String body) {
  final parsedEncounters = json.decode(body).cast<Map<String, dynamic>>();
  return parsedEncounters.map<Encounter>((json) => Encounter.fromMap(json)).toList();
}
