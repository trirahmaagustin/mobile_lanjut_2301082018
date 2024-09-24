import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  String data = "Belum ada input";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dialog"),
      ),
      body: Center(
        child: Text(data,
        style: TextStyle(fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton
      (onPressed:() {
        print("Telah di klik");
        showDialog(
          context: context,
           builder: (context) {
            return AlertDialog(
              title: Text("OK"),
              content: Text("Apakah di hapus?"),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    setState(() {
                      data = "TRUE";
                    });

                  },
                  child: Text("Yes")),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        data = "FALSE";
                      });
                    }, child: Text("No"))
              ],
            );
           },
           ).then((value) => print(value) );
      },
      child: Icon(Icons.delete),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}