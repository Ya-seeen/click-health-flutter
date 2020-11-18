import 'dart:developer';
import 'dart:io';

import 'package:drug_delivery/add_patient_screen.dart';
import 'package:drug_delivery/appointment_list_screen.dart';
import 'package:drug_delivery/services.dart';
import 'package:drug_delivery/utils/color_util.dart';
import 'package:drug_delivery/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'models/patient.dart';
import 'models/user.dart';

class PatientListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List<Patient> patientList = List();
  List<Patient> todaysPatientList = List();
  List<Patient> filteredPatients = List();
  List<Patient> todaysFilteredPatients = List();
  bool _isLoading = true;
  bool _isLoadingToday = true;
  bool _isSearching = false;
  User user;
  String newDate;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
      _isLoadingToday = true;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      newDate = formattedDate;
      _syncData();
    });
    super.initState();
  }


  Future <void> _syncData() async{
    setState(() {
      _isLoadingToday = true;
      _isLoading = true;
    });
    await _getUser();
    await _initiateScreen();
    await _getPatientList();
  }

  _initiateScreen() async {
    await Services().checkOrInsertLocation();
  }

  _getUser() async {
    user = await Services().getUser();
  }

  _getStatusColor(String status) {
    switch(status.toLowerCase()) {
      case 'completed' : return Colors.green;
      case 'in queue' : return Colors.red;
      case 'in progress' : return Colors.orange;
      default : return Colors.grey;
    }
  }

  _getPatientList() async{
    await Services.getPatientList();
    await Services.getEncounterList();
    await _getPatientListFromLocal();
    await _getTodaysPatientListFromLocal();
  }

  Future _getPatientListFromLocal() async{
    Services.getPatientListFromLocal().then((onlinePatients) {
      print('success patient list from local: '+onlinePatients.length.toString());
      setState(() {
        patientList = onlinePatients.cast<Patient>();
        filteredPatients = patientList;
        _isLoading = false;
      });
    }).catchError((e) {
      print('error patient list from local');
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future _getTodaysPatientListFromLocal() async{
    Services.getTodaysPatientListFromLocal().then((onlinePatients) {
      print('success todays patient list from local: '+onlinePatients.length.toString());
      setState(() {
        todaysPatientList = onlinePatients.cast<Patient>();
        todaysFilteredPatients = todaysPatientList;
        _isLoadingToday = false;
      });
    }).catchError((e) {
      print('error patient list from local');
      setState(() {
        _isLoadingToday = false;
      });
    });
  }

  void _filteredPatients(value) {
    setState(() {
      filteredPatients = patientList
          .where((patient) =>
          patient.name.toLowerCase().contains(value.toLowerCase()))
          .toList();

      todaysPatientList = todaysPatientList
          .where((patient) =>
          patient.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Services.onWillPop(context),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scaffoldState,
          drawer: AppDrawer(),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: ()=> scaffoldState.currentState.openDrawer(),
            ),
            title: !_isSearching?Text("Patient List"):TextField(
              onChanged: (value) {
                _filteredPatients(value);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "Search patient...",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            centerTitle: true,
            actions: <Widget>[
              _isSearching
                  ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    this._isSearching = false;
                    filteredPatients = patientList;
                    todaysFilteredPatients = todaysPatientList;
                  });
                },
              )
                  : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    this._isSearching = true;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.sync),
                onPressed: () async {
                  scaffoldState.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Sync started...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  setState(() {
                    this._isSearching = false;
                    filteredPatients = patientList;
                    todaysFilteredPatients = todaysPatientList;
                  });
                  await _syncData().then((value) {
                    scaffoldState.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Sync successful...'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }).catchError((e) {
                    scaffoldState.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Sync failed...'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  });
                },
              )
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: <Widget>[
                Tab(text: "Today's Patient"),
                Tab(text: "All Patient"),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                color: Theme.of(context).canvasColor,
                child: todaysPatients(),
              ),
              Container(
                  color: Theme.of(context).canvasColor,
                  child: allPatients()
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddPatientPage()
                  )
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget allPatients() {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: filteredPatients.isNotEmpty?Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 60),
              itemCount: filteredPatients.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30,
                            child: Text(
                              filteredPatients[index].patientId.toString(),
                              style: TextStyle(color: Theme.of(context).primaryColor
                              ),
                            ),
//                                  backgroundImage: (cattleList[index].soldStatus == 1 || cattleList[index].imageUrls == null || cattleList[index].imageUrls.length == 0)?null:
//                                  cattleList[index].imageUrls[0].contains('http')?NetworkImage(
//                                      cattleList[index].imageUrls[0]
//                                  ):FileImage(File(cattleList[index].imageUrls[0])),
                            backgroundColor: ColorUtil.of(context).circleAvatarBackColor,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Patient Name",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      filteredPatients[index].name,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Mobile No",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      filteredPatients[index].mobileNumber,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Age",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      filteredPatients[index].year.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Status:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Card(
                                          color: _getStatusColor(filteredPatients[index].status.toString()),
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              filteredPatients[index].status.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                      )
                                    ]
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                          Center(
                            child: IconButton(
                              icon: Icon(Icons.assessment),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => AppointmentListPage(patient: filteredPatients[index])
                                    )
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ):Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[200],
                      ),
                    ),
                  ],
                )
                    : Text(
                  "No Records Found",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[200],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget todaysPatients() {
    return Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: todaysFilteredPatients.isNotEmpty?Scrollbar(
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 60),
                    itemCount: todaysFilteredPatients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 30,
                                  child: Text(
                                    todaysFilteredPatients[index].patientId.toString(),
                                    style: TextStyle(color: Theme.of(context).primaryColor
                                    ),
                                  ),
//                                  backgroundImage: (cattleList[index].soldStatus == 1 || cattleList[index].imageUrls == null || cattleList[index].imageUrls.length == 0)?null:
//                                  cattleList[index].imageUrls[0].contains('http')?NetworkImage(
//                                      cattleList[index].imageUrls[0]
//                                  ):FileImage(File(cattleList[index].imageUrls[0])),
                                  backgroundColor: ColorUtil.of(context).circleAvatarBackColor,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Patient Name",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            todaysFilteredPatients[index].name,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Mobile No",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            todaysFilteredPatients[index].mobileNumber,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Age",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            todaysFilteredPatients[index].year.toString()+ " Year "+ todaysFilteredPatients[index].month.toString() + " Month",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Status:",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Card(
                                                color: _getStatusColor(todaysFilteredPatients[index].status.toString()),
                                                child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  child: Text(
                                                    todaysFilteredPatients[index].status.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                )
                                            )
                                          ]
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: IconButton(
                                    icon: Icon(Icons.assessment),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => AppointmentListPage(patient: todaysFilteredPatients[index])
                                          )
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ):Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      _isLoading
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[200],
                            ),
                          ),
                        ],
                      )
                          : Text(
                        "No Records Found",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[200],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
