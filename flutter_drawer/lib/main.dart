import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawer"),
      ), // AppBar
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "Menu Pilihan",
                style: TextStyle(fontSize: 24),
              ),
            ), // Container
            SizedBox(
              height: 10,
            ), // SizedBox
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PageSatu()),
                );
              },
              leading: Icon(Icons.home),
              title: Text("Home"),
            ), // ListTile
          ],
        ), // Column
      ), // Drawer
    ); // Scaffold
  }
}

