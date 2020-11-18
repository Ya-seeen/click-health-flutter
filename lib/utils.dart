import 'package:flutter/material.dart';

class Utils {
  static void showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(5)),
                  Center(child: CircularProgressIndicator()),
                  Padding(padding: EdgeInsets.all(5)),
                  Center(child: Text("Please wait..."))
                ],
              ),
            ),
          );
        });
  }

  static void showSnackBar(GlobalKey<ScaffoldState> scaffoldState,
      BuildContext context, String message, bool isTerminate) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        action: isTerminate
            ? SnackBarAction(
                label: "Close",
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        content: Text(message),
      ),
    );
  }
}
