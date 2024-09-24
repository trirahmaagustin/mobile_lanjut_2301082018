import 'package:flutter/material.dart';
import 'package:flutter_routes/home_page.dart';
import 'package:flutter_routes/gallery_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ), // AppBar
      body: Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 50),
        ), // Text
      ), // Center
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return GalleryPage();
            },
          ));
        },
        child: Icon(Icons.arrow_right_alt),
      ), // FloatingActionButton
    ); // Scaffold
  }
}
