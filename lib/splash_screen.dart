import 'dart:async';
import 'package:animator/animator.dart';
import 'package:drug_delivery/login_screen.dart';
import 'package:drug_delivery/patient_list_screen.dart';
import 'package:drug_delivery/services.dart';
import 'package:drug_delivery/utils/color_util.dart';
import 'package:drug_delivery/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

//  Future<void> checkFirebaseAndMoveToNext() async {
//
//    Navigator.of(context).pushReplacement(
//      MaterialPageRoute(
//        builder: (BuildContext context) => LoginPage()
////            firebaseUser == null ? LoginPage() : DashboardPage(),
//      ),
//    );
//  }

  Future<void> checkCredentialAndMoveToNext() async {

    Services().getUser().then((value) {
      if(value != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  PatientListPage()
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  LoginPage()
          ),
        );
      }
    }).catchError((e) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                LoginPage()
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 6), () {
      checkCredentialAndMoveToNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(
                  child: Animator(
                duration: Duration(seconds: 1),
                cycles: 0,
                builder: (anim) => FadeTransition(
                    opacity: anim,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 100),
                        Container(
                          padding: EdgeInsets.all(60),
                          child: Image.asset(
                              ImageUtil.of(context).clickHealthJpgIcon,
                              fit: BoxFit.contain
                          ),
                        )
                      ],
                    )),
              )),
            ),
            Container(
              height: 200,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Developed By",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SvgPicture.asset(
                        "assets/images/ic_logo_mpower.svg",
                        color: ColorUtil.of(context).mPowerIconColor,
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
