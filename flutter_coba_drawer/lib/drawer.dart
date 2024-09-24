import 'package:flutter_coba_drawer/page_satu.dart';
import 'package:flutter_coba_drawer/setting_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            color: Colors.green,
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(20),
            child: Text(
              "Menu",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(PageSatu.routesName);
            },
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(SettingPage.routesName);
            },
            leading: Icon(Icons.settings),
            title: Text("Setting"),
          ),
        ],
      ),
    );
  }
}