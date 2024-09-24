import 'package:flutter_coba_drawer/home_page.dart';
import 'package:flutter_coba_drawer/setting_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
      routes: {
        MyHome.routesName: (context) => MyHome(),
        SettingPage.routesName: (context) => SettingPage(),
      },
    );
  }
}