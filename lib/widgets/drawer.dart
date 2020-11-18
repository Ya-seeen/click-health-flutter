import 'package:drug_delivery/dao/user_dao.dart';
import 'package:drug_delivery/login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drug_delivery/models/user.dart';
import 'package:drug_delivery/services.dart';
import 'package:drug_delivery/splash_screen.dart';
import 'package:drug_delivery/utils/color_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {

  User user;

  @override
  void initState() {
    super.initState();
    Services().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          createHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 45,
              onPressed: () => showLogoutDialog(),
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              color: ColorUtil.of(context).circleAvatarBigBackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget createHeader(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: UserAccountsDrawerHeader(
        accountName: Text(
          (user == null || user.firstName==null || user.lastName == null)?'Loading':user.firstName+ ' ' +user.lastName,
          style: TextStyle(
            fontSize: 18,
            color: ColorUtil.of(context).circleAvatarIconColor,
          ),
        ),
        accountEmail: Text(
          (user == null || user.mobile==null)?'Loading':user.mobile,
          style: TextStyle(
            color: ColorUtil.of(context).circleAvatarIconColor,
          ),
        ),
        currentAccountPicture: Material(
          elevation: 4.0,
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: Image(
            image: AssetImage(
              "assets/images/ic_user.png",
            ),
            fit: BoxFit.cover,
            width: 50.0,
            height: 50.0,
          ),
        ),
//        otherAccountsPictures: <Widget>[
//          GestureDetector(
//            onTap: () {
//              Navigator.of(context).pop();
//              Navigator.of(context).push(
//                  MaterialPageRoute(builder: (context) => LoginPage()));
//            },
//            child: CircleAvatar(
//              backgroundColor: Theme.of(context).backgroundColor,
//              child: Icon(
//                Icons.edit,
//                size: 30,
//                color: Colors.white54,
//              ),
//            ),
//          ),
//        ],
        decoration: BoxDecoration(
            color: ColorUtil.of(context).circleAvatarBackColor,
            boxShadow: [
              BoxShadow(
                color: ColorUtil.of(context).circleAvatarBackColor,
              ),
              BoxShadow(
                color: ColorUtil.of(context).circleAvatarBackColor,
              ),
              BoxShadow(
                color: ColorUtil.of(context).circleAvatarBackColor,
              ),
              BoxShadow(
                color: ColorUtil.of(context).circleAvatarBackColor,
              ),
            ]),
      ),
      decoration: BoxDecoration(
        color: ColorUtil.of(context).circleAvatarBackColor,
      ),
    );
  }

  Widget createDrawerItem(
      IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  Future<void> showLogoutDialog() async {
    Navigator.of(context).pop();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Do you want to logout?"),
            actions: <Widget>[
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text("No"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                color: Colors.red,
                child: Text("Yes"),
                onPressed: () async {
                  UserDao().deleteAll();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SplashPage(),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
}
