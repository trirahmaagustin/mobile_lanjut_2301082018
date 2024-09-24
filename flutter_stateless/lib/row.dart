import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("Selamat Datang di My App"),
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 200,
                color: Colors.green,
              ),
              Container(
                width: 10,
                height: 120,
                color: Colors.amber,
              ),
              Container(
                width: 25,
                height: 200,
                color: const Color.fromARGB(255, 7, 255, 48),
              ),
              Container(
                width: 15,
                height: 80,
                color: const Color.fromARGB(255, 48, 7, 255),
              ),
            ],
          ),
        ),
    );
  }
}