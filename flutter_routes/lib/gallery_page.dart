import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery Page"),
      ), // AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Gallery Page"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/homepage');
                  },
                  child: Text("<< Back"),
                ), // TextButton
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/homepage');
                  },
                  child: Text("Next >>"),
                ), // TextButton
              ],
            ), // Row
          ],
        ), // Column
      ), // Center
    ); // Scaffold
  }
}
