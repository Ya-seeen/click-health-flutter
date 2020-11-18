import 'package:drug_delivery/patient_list_screen.dart';
import 'package:drug_delivery/prescription_screen.dart';
import 'package:drug_delivery/services.dart';
import 'package:drug_delivery/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/user_login.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool _showPassword = false;
  bool isLoginProcessStart = false;

  _login() {
    setState(() {
      isLoginProcessStart = true;
    });

    UserLogin userLogin = UserLogin(username: usernameController.text, password: passwordController.text);
    Services().login(userLogin).then((value) {
      Services.addStringToSF('username', usernameController.text);
      Services.addStringToSF('password', passwordController.text);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                PatientListPage()
        ),
      );
      setState(() {
        isLoginProcessStart = false;
      });
    }).catchError((e) {
      scaffoldState.currentState.showSnackBar(
        SnackBar(
          content: Text(e.message),
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {
        isLoginProcessStart = false;
      });
    });
  }

  _initiateValues() async {
    print("Location Timestamp");
    String locationTimestamp = await Services.getStringValuesSF('location_timestamp');
    String encounterTimestamp = await Services.getStringValuesSF('encounter_timestamp');
    String patientTimestamp = await Services.getStringValuesSF('patient_timestamp');
    if(locationTimestamp == null) Services.addStringToSF('location_timestamp', '0');
    if(encounterTimestamp == null) Services.addStringToSF('encounter_timestamp', '0');
    if(patientTimestamp == null) Services.addStringToSF('patient_timestamp', '0');
    usernameController.text = await Services.getStringValuesSF('username');
    passwordController.text = await Services.getStringValuesSF('password');
  }

  @override
  void initState() {
    _initiateValues();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        leading: Container(),
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 24,),
                    Form(
                      key: formState,
                      child: Container(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter(RegExp("^[a-zA-Z0-9]*"))
                              ],
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.verified_user),
                                labelText: "Username",
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
                                  ? "Enter your Username"
                                  : null,
                              controller: usernameController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Password",
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
                                prefixIcon: Icon(Icons.security),
                                suffixIcon: IconButton(
                                  icon: Icon(this._showPassword?Icons.visibility_off:Icons.visibility),
                                  onPressed: () {
                                    setState(() => this._showPassword = !this._showPassword);
                                  },
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              obscureText: this._showPassword?false:true,
                              validator: (value) => (value.length > 8)
                                  ? "Enter your password"
                                  : null,
                              controller: passwordController,
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
                                    if(formState.currentState.validate() && !isLoginProcessStart)_login();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isLoginProcessStart?
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
                                        "Login",
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
              )
            ]
        ),
      ),
    );
  }
}
