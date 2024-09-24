import 'package:flutter_coba_drawer/drawer.dart';
import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  static const routesName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DRAWER"),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Text(
          "HOME",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}