import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarBack extends StatelessWidget {
  final String title;
  final Object data;
  AppBarBack({@required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 100,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 2.0),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 40,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: SvgPicture.asset(
                  "assets/images/ic_back_arrow.svg",
                  width: 25,
                  height: 25,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.of(context).pop(data),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Opacity(
                opacity: 0,
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/images/ic_notification.svg",
                    width: 25,
                    height: 25,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
