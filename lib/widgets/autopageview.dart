import 'dart:async';
import 'package:flutter/cupertino.dart';

class AutoPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AutoPageViewState();
}

class AutoPageViewState extends State<AutoPageView> {
  int _currentPage = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: <Widget>[
        Text("জনসমাগম বর্জন করুন"),
        Text("২০ সেকেন্ড ধরে হাত ধুয়ে নিন"),
        Text("খুব প্রয়োজন না হলে বাইরে যাবেন না"),
      ],
    );
  }
}
