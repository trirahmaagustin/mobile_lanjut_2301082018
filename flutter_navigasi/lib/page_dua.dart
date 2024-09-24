import 'package:flutter/material.dart';
import 'package:flutter_navigasi/page_satu.dart';
import 'package:flutter_navigation/page/page_dua.dart';

class PageDua extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page 2"),
      ),
      body: Center(
        child: Text("Ini Page 2"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
       Navigator.of(context).pop();
      }, child: Icon(Icons.keyboard_arrow_left)),
      );
  }
}

