import 'dart:developer';
import 'dart:io';

import 'package:drug_delivery/add_appointment_screen.dart';
import 'package:drug_delivery/models/encounter.dart';
import 'package:drug_delivery/patient_list_screen.dart';
import 'package:drug_delivery/services.dart';
import 'package:drug_delivery/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf/pdf.dart' as pdfDart;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'models/patient.dart';
import 'models/user.dart';

class AppointmentListPage extends StatefulWidget {
  final Patient patient;

  AppointmentListPage({@required this.patient});

  @override
  State<StatefulWidget> createState() => _AppointmentListPageState(patient);
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final Patient patient;
  var img;
  _AppointmentListPageState(this.patient);
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List<Encounter> encounterList = List();
  bool _isLoading = true;
  User user;
  pdfDart.PdfImage image;

  @override
  void initState() {
    _sync();
    rootBundle.load('assets/images/ic_click_health.jpg').then((value) {
      setState(() {
        img = value.buffer.asUint8List();
      });
    });
    super.initState();
  }

  _sync() async {
    await Services.getEncounterListFromLocal(patient.patientId).then((value) {
      setState(() {
        encounterList = value;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }


  _printDocument(Encounter encounter) {
    print(encounter.medication);
    List<String> medication = encounter.medication.toString().split('\n');
    Printing.layoutPdf(
      onLayout: (pageFormat) {
        final doc = pw.Document();
        doc.addPage(
          pw.MultiPage(
            pageFormat: pdfDart.PdfPageFormat(21.0*72.0/2.54, 29.7*72.0/2.54, marginLeft: 20.0, marginTop: 10, marginRight: 0),
            build: (pw.Context context) => [
              pw.Image(
                  pdfDart.PdfImage.jpeg(
                    doc.document,
                    image: img,
                  ),
                  width: 200,
                  height: 200
              ),

              pw.SizedBox(height: 10),

              pw.Text("Doctor Details", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
              pw.Text(encounter.doctorName.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 32)),
              pw.Text(encounter.background.toString(), style: pw.TextStyle(fontSize: 24)),
              pw.Text("BMDC NO : "+encounter.bmdc.toString(), style: pw.TextStyle(fontSize: 24)),

              pw.SizedBox(height: 10),

              pw.Text("Patient Details", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
              pw.Text("Name : "+patient.name.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 32)),
              pw.Text("Age : "+patient.year.toString(), style: pw.TextStyle(fontSize: 24)),
              pw.Text("Gender : "+patient.gender.toString(), style: pw.TextStyle(fontSize: 24)),
              pw.Text("Case Id : "+encounter.token.toString(), style: pw.TextStyle(fontSize: 24)),

              pw.SizedBox(height: 10),

              pw.Text("Chief Complaints :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
              pw.Text(encounter.chiefComplaint.toString(), style: pw.TextStyle(fontSize: 24)),
              pw.Text("Diagnosis :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
              pw.Text(encounter.diagnosis.toString(), style: pw.TextStyle(fontSize: 24)),
              pw.Text("Test Ordered :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
              pw.Text(encounter.test.toString(), style: pw.TextStyle(fontSize: 24)),

              pw.SizedBox(height: 10),

              pw.Text("Medication :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
              for(int i = 0; i < medication.length; i++)pw.Text(medication[i], style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 10),
              pw.Text("Advice :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
              pw.Text(encounter.advice.toString(), style: pw.TextStyle(fontSize: 24)),

              pw.SizedBox(height: 10),

              pw.Text("CONDITIONS APPLY :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
              pw.Text("1. We have issued a verified e-prescription which should be used upon complete user discretion and responsibility.", style: pw.TextStyle(fontSize: 20)),
              pw.Text("2. ClickHealth Services will not carry any liability for any misuse or abuse of the prescription.", style: pw.TextStyle(fontSize: 20)),
              pw.Text("3. The e-prescription is not a substitute for professional medical advice, diagnosis or treatment.", style: pw.TextStyle(fontSize: 20)),
              pw.Text("4. For verification of prescription of doctor's referral, you can review issuance with ClickHealth Service and for verification of doctor use the BMDC No at http://bmdc.org.bd/doctors.info/.", style: pw.TextStyle(fontSize: 20))
            ],
          ),
        );
        return doc.save();
      },
    );
  }

  _getStatusColor(String status) {
    switch(status.toLowerCase()) {
      case 'completed' : return Colors.green;
      case 'in queue' : return Colors.red;
      case 'in progress' : return Colors.orange;
      default : return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Encounter List"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: encounterList.isNotEmpty
                  ? Scrollbar(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 60),
                  itemCount: encounterList.length,
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
                                  encounterList[index].patientId.toString(),
                                  style: TextStyle(color: Theme.of(context).primaryColor
                                  ),
                                ),
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
                                          "Status:",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Card(
                                            color: _getStatusColor(encounterList[index].doctorApproveStatus.toString()),
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              child: Text(
                                                encounterList[index].doctorApproveStatus.toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            )
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
                                          "Doctor Name:",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          encounterList[index].doctorName.toString(),
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
                                          "Token:",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          encounterList[index].token.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.print),
                                onPressed: ()=> _printDocument(encounterList[index]),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
//                    SvgPicture.asset(
//                        "assets/images/ic_empty.svg",
//                        width: 250,
//                        height: 250
//                    ),
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
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.of(context).push(
//              MaterialPageRoute(
//                  builder: (BuildContext context) => AddAppointmentPage(patient: patient)
//              )
//          );
//        },
//        child: Icon(Icons.add),
//        backgroundColor: Theme.of(context).primaryColor,
//      ),
    );
  }
}
