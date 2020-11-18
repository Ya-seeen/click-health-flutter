import 'dart:io';

import 'package:drug_delivery/appointment_list_screen.dart';
import 'package:drug_delivery/models/location_new.dart';
import 'package:drug_delivery/models/patient.dart';
import 'package:drug_delivery/patient_list_screen.dart';
import 'package:drug_delivery/services.dart';
import 'package:drug_delivery/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'models/encounter.dart';
import 'models/patient_encounter.dart';

class AddAppointmentPage extends StatefulWidget {
  final Patient patient;
  AddAppointmentPage({@required this.patient});
  @override
  State<StatefulWidget> createState() => _AddAppointmentPageState(patient);
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final Patient patient;
  _AddAppointmentPageState(this.patient);
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  LocationNew selectedDistrict;
  LocationNew selectedUpazila;
  LocationNew selectedUnion;

  List<LocationNew> districts = List();
  List<LocationNew> upazilas = List();
  List<LocationNew> unions = List();
  List<String> imagePaths = List();
  String bpImagePath = "";
  String bsImagePath = "";
  String pulseImagePath = "";
  String btImagePath = "";

  String selectedGender;

  final picker = ImagePicker();

  bool isAddProcessStart = false;


  @override
  void initState() {
    _loadLocations();
    nameController.text = patient.name;
    mobileController.text = patient.mobileNumber;
    ageController.text = patient.year.toString();
    selectedGender = patient.gender;
    super.initState();
  }

  _loadLocations() async{

    await Services().getDistrict().then((value) {
      setState(() {
        districts = value;
        for (int i = 0; i < districts.length; i++) {
          if (districts[i].id == patient.districtId) {
            selectedDistrict = districts[i];
            break;
          }
        }
      });
    });
    if(selectedDistrict != null)
      await Services().getLocationByParent(selectedDistrict.id).then((value) {
        setState(() {
          upazilas = value;
          for (int i = 0; i < upazilas.length; i++) {
            if (upazilas[i].id == patient.upazilaId) {
              selectedUpazila = upazilas[i];
              break;
            }
          }
        });
      });
    if(selectedUpazila != null)
      await Services().getLocationByParent(selectedUpazila.id).then((value) {
        setState(() {
          unions = value;
          for (int i = 0; i < unions.length; i++) {
            if (unions[i].id == patient.unionId) {
              selectedUnion = unions[i];
              break;
            }
          }
        });
      });
  }

  _addAppointment() {

    setState(() {
      isAddProcessStart = true;
    });

    Patient updatedPatient = Patient(
      patientId: patient.patientId,
      name: nameController.text,
      mobileNumber: mobileController.text,
      districtName: selectedDistrict.name,
      districtId: selectedDistrict.id,
      upazilaName: selectedUpazila.name,
      upazilaId: selectedUpazila.id,
      unionName: selectedUnion.name,
      unionId: selectedUnion.id,
      gender: selectedGender,
      year: int.parse(ageController.text),
    );

    Encounter encounter = Encounter(
        bodyTemperature: btImagePath,
        bloodPressure: bpImagePath,
        bsl: bsImagePath,
        pulse: pulseImagePath,
        height: heightController.text,
        weight: weightController.text
    );

    PatientEncounter patientEncounter = PatientEncounter(patient: updatedPatient, encounter: encounter);

    print('before server call');

    Services().addAppointment(patientEncounter, imagePaths).then((value) {
      setState(() {
        isAddProcessStart = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                PatientListPage()
        ),
      );
    }).catchError((onError) {
      setState(() {
        isAddProcessStart = false;
      });
    });
  }



  Future getImageFromCamera() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera, maxHeight: 500, maxWidth: 500, imageQuality: 90);
    setState(() {
      if (pickedFile != null) {
        imagePaths.add(pickedFile.path);
      }
    });
  }

  Future getImageFromCameraSingle(String which) async {
    var pickedFile = await picker.getImage(source: ImageSource.camera, maxHeight: 500, maxWidth: 500, imageQuality: 90);
    setState(() {
      if (pickedFile != null) {
        switch(which) {
          case 'bp': {
            bpImagePath = pickedFile.path;
            break;
          }
          case 'bs': {
            bsImagePath = pickedFile.path;
            break;
          }
          case 'bt': {
            btImagePath = pickedFile.path;
            break;
          }
          case 'pulse': {
            pulseImagePath = pickedFile.path;
            break;
          }
          default: break;
        }
      }
    });
  }

  Future getImageFromGallerySingle(String which) async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500, imageQuality: 90);
    setState(() {
      if (pickedFile != null) {
        switch(which) {
          case 'bp': {
            bpImagePath = pickedFile.path;
            break;
          }
          case 'bs': {
            bsImagePath = pickedFile.path;
            break;
          }
          case 'bt': {
            btImagePath = pickedFile.path;
            break;
          }
          case 'pulse': {
            pulseImagePath = pickedFile.path;
            break;
          }
          default: break;
        }      }
    });
  }

  Future getImageFromGallery() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500, imageQuality: 90);
    setState(() {
      if (pickedFile != null) {
        imagePaths.add(pickedFile.path);
      }
    });
  }

  Future<void> _askedToLoad() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select image'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, getImageFromCamera()); },
                child: const Text('Take picture'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, getImageFromGallery()); },
                child: const Text('Select from gallery'),
              ),
            ],
          );
        }
    );
  }

  Future<void> _askedToLoadSingle(String which) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select image'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, getImageFromCameraSingle(which)); },
                child: const Text('Take picture'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, getImageFromGallerySingle(which)); },
                child: const Text('Select from gallery'),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: ()=> Navigator.pop(context),
        ),
        title: Text("Add Appointment"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Stack(
          children: <Widget>[
//                Opacity(
//                  opacity: 0.1,
//                  child: SvgPicture.asset(
//                    ImageUtil.of(context).cattleSvgIcon,
//                    fit: BoxFit.fill,
//                    height: double.infinity,
//                    width: double.infinity,
//                  ),
//                ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Form(
                      key: formState,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z .]*"))
                              ],
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: "Name",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2
                                    )
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => (value.length < 1)
                                  ? "Enter beneficiary name"
                                  : null,
                              controller: nameController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Mobile Number",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2
                                    )
                                ),
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) => (value.length != 11)
                                  ? "Enter patient 11 digit phone number"
                                  : null,
                              controller: mobileController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<LocationNew>(
                              onTap: ()=> FocusScope.of(context).requestFocus(new FocusNode()),
                              value: selectedDistrict,
                              validator: (value) => (value == null) ? "Select Patient District" : null,
                              decoration: InputDecoration(
                                labelText: "District",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2
                                    )
                                ),
                              ),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),
                              onChanged: (LocationNew newValue) {
                                setState(() {
                                  selectedDistrict = newValue;
                                  selectedUpazila = null;
                                  selectedUnion = null;
                                  upazilas = List();
                                  unions = List();
                                  Services().getLocationByParent(selectedDistrict.id).then((value) {
                                    setState(() {
                                      upazilas = value;
                                    });
                                  });
                                });
                              },
                              items: districts.map((LocationNew value) {
                                return DropdownMenuItem<LocationNew>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<LocationNew>(
                              onTap: ()=> FocusScope.of(context).requestFocus(new FocusNode()),
                              value: selectedUpazila,
                              validator: (value) => (value == null) ? "Select Patient Upazila" : null,
                              decoration: InputDecoration(
                                labelText: "Upazila",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2
                                    )
                                ),
                              ),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),
                              onChanged: (LocationNew newValue) {
                                setState(() {
                                  selectedUnion = null;
                                  unions = List();
                                  selectedUpazila = newValue;
                                  Services().getLocationByParent(selectedUpazila.id).then((value) {
                                    setState(() {
                                      unions = value;
                                    });
                                  });                                });
                              },
                              items: upazilas.map((LocationNew value) {
                                return DropdownMenuItem<LocationNew>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<LocationNew>(
                              onTap: ()=> FocusScope.of(context).requestFocus(new FocusNode()),
                              value: selectedUnion,
                              validator: (value) => (value == null) ? "Select Patient Union" : null,
                              decoration: InputDecoration(
                                labelText: "Union",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2
                                    )
                                ),
                              ),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),
                              onChanged: (LocationNew newValue) {
                                setState(() {
                                  selectedUnion = newValue;
                                });
                              },
                              items: unions.map((LocationNew value) {
                                return DropdownMenuItem<LocationNew>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<String>(
                              value: selectedGender,
                              validator: (value) => (value == null) ? "Select Patient Gender" : null,
                              decoration: InputDecoration(
                                labelText: "Gender",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2
                                    )
                                ),
                              ),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                              items: ["Male", "Female", "Other"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Age",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2
                                    )
                                ),
                                suffix: Text('y'),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) => (value.length < 1)
                                  ? "Enter patient age"
                                  : null,
                              controller: ageController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Height",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2
                                    )
                                ),
                                suffix: Text('cm'),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) => (value.length < 1)
                                  ? "Enter patient height"
                                  : null,
                              controller: heightController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Weight",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2
                                    )
                                ),
                                suffix: Text('kg'),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) => (value.length < 1)
                                  ? "Enter patient weight"
                                  : null,
                              controller: weightController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Blood Pressure",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              bpImagePath.length == 0?Container(
                                                child: InkWell(
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    color: Colors.white,
                                                    child: SvgPicture.asset(
                                                        "assets/images/ic_add_file.svg",
                                                        width: 60,
                                                        height: 60
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    FocusScope.of(context).requestFocus(new FocusNode());
                                                    _askedToLoadSingle('bp');
                                                  },
                                                ),
                                                padding: EdgeInsets.only(top: 24),
                                              ):Container(),
                                              bpImagePath.length > 0? Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              SizedBox(width: 8),
                                                              Container(
                                                                padding: EdgeInsets.only(top: 24),
                                                                child: Stack(
                                                                  overflow: Overflow.visible,
                                                                  children: <Widget>[
                                                                    Image(
                                                                      image: FileImage(
                                                                        File(bpImagePath),
                                                                      ),
                                                                      fit: BoxFit.cover,
                                                                      width: 100.0,
                                                                      height: 100.0,
                                                                    ),
                                                                    Positioned(
                                                                      top: -24,
                                                                      right: -24,
                                                                      child: IconButton(
                                                                        icon: Icon(Icons.cancel, color: Colors.red,),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            bpImagePath = "";
                                                                          });
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(width: 8)
                                                            ],
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ):Container(),
                                            ],
                                          )
                                        ]
                                    )
                                )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Blood Sugar",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              bsImagePath.length == 0?Container(
                                                child: InkWell(
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    color: Colors.white,
                                                    child: SvgPicture.asset(
                                                        "assets/images/ic_add_file.svg",
                                                        width: 60,
                                                        height: 60
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    FocusScope.of(context).requestFocus(new FocusNode());
                                                    _askedToLoadSingle('bs');
                                                  },
                                                ),
                                                padding: EdgeInsets.only(top: 24),
                                              ):Container(),
                                              bsImagePath.length > 0? Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              SizedBox(width: 8),
                                                              Container(
                                                                padding: EdgeInsets.only(top: 24),
                                                                child: Stack(
                                                                  overflow: Overflow.visible,
                                                                  children: <Widget>[
                                                                    Image(
                                                                      image: FileImage(
                                                                        File(bsImagePath),
                                                                      ),
                                                                      fit: BoxFit.cover,
                                                                      width: 100.0,
                                                                      height: 100.0,
                                                                    ),
                                                                    Positioned(
                                                                      top: -24,
                                                                      right: -24,
                                                                      child: IconButton(
                                                                        icon: Icon(Icons.cancel, color: Colors.red,),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            bsImagePath = "";
                                                                          });
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(width: 8)
                                                            ],
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ):Container(),
                                            ],
                                          ),
                                        ]
                                    )
                                )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Body Temperature",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              btImagePath.length == 0?Container(
                                                child: InkWell(
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    color: Colors.white,
                                                    child: SvgPicture.asset(
                                                        "assets/images/ic_add_file.svg",
                                                        width: 60,
                                                        height: 60
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    FocusScope.of(context).requestFocus(new FocusNode());
                                                    _askedToLoadSingle('bt');
                                                  },
                                                ),
                                                padding: EdgeInsets.only(top: 24),
                                              ):Container(),
                                              btImagePath.length > 0? Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              SizedBox(width: 8),
                                                              Container(
                                                                padding: EdgeInsets.only(top: 24),
                                                                child: Stack(
                                                                  overflow: Overflow.visible,
                                                                  children: <Widget>[
                                                                    Image(
                                                                      image: FileImage(
                                                                        File(btImagePath),
                                                                      ),
                                                                      fit: BoxFit.cover,
                                                                      width: 100.0,
                                                                      height: 100.0,
                                                                    ),
                                                                    Positioned(
                                                                      top: -24,
                                                                      right: -24,
                                                                      child: IconButton(
                                                                        icon: Icon(Icons.cancel, color: Colors.red,),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            btImagePath = "";
                                                                          });
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(width: 8)
                                                            ],
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ):Container(),
                                            ],
                                          ),
                                        ]
                                    )
                                )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pulse",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              pulseImagePath.length == 0?Container(
                                                child: InkWell(
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    color: Colors.white,
                                                    child: SvgPicture.asset(
                                                        "assets/images/ic_add_file.svg",
                                                        width: 60,
                                                        height: 60
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    FocusScope.of(context).requestFocus(new FocusNode());
                                                    _askedToLoadSingle('pulse');
                                                  },
                                                ),
                                                padding: EdgeInsets.only(top: 24),
                                              ):Container(),
                                              pulseImagePath.length > 0? Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              SizedBox(width: 8),
                                                              Container(
                                                                padding: EdgeInsets.only(top: 24),
                                                                child: Stack(
                                                                  overflow: Overflow.visible,
                                                                  children: <Widget>[
                                                                    Image(
                                                                      image: FileImage(
                                                                        File(pulseImagePath),
                                                                      ),
                                                                      fit: BoxFit.cover,
                                                                      width: 100.0,
                                                                      height: 100.0,
                                                                    ),
                                                                    Positioned(
                                                                      top: -24,
                                                                      right: -24,
                                                                      child: IconButton(
                                                                        icon: Icon(Icons.cancel, color: Colors.red,),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            pulseImagePath = "";
                                                                          });
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(width: 8)
                                                            ],
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ):Container(),
                                            ],
                                          )
                                        ]
                                    )
                                )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Others",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: InkWell(
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                color: Colors.white,
                                                child: SvgPicture.asset(
                                                    "assets/images/ic_add_file.svg",
                                                    width: 60,
                                                    height: 60
                                                ),
                                              ),
                                              onTap: () {
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                _askedToLoad();
                                              },
                                            ),
                                            padding: EdgeInsets.only(top: 24),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  for(int i = 0; i < imagePaths.length; i++) Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(width: 8),
                                                          Container(
                                                            padding: EdgeInsets.only(top: 24),
                                                            child: Stack(
                                                              overflow: Overflow.visible,
                                                              children: <Widget>[
                                                                Image(
                                                                  image: FileImage(
                                                                    File(imagePaths[i]),
                                                                  ),
                                                                  fit: BoxFit.cover,
                                                                  width: 100.0,
                                                                  height: 100.0,
                                                                ),
                                                                Positioned(
                                                                  top: -24,
                                                                  right: -24,
                                                                  child: IconButton(
                                                                    icon: Icon(Icons.cancel, color: Colors.red,),
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        imagePaths.removeAt(i);
                                                                      });
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 8)
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 200,
                                child: MaterialButton(
                                  height: 50,
                                  minWidth: 200,
                                  onPressed: () {
                                    if(formState.currentState.validate() && !isAddProcessStart)_addAppointment();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isAddProcessStart?
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          strokeWidth: 3,
                                        ),
                                      ):Container(),
                                      SizedBox(width: 4,),
                                      Text(
                                        "Add Appointment",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white
                                        ),
                                      )
                                    ],
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  textColor: ColorUtil.of(context).circleAvatarIconColorReverse,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    ageController.dispose();
    mobileController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }
}
