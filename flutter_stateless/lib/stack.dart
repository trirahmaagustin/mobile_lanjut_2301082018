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
          body: Stack(

            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.green,
              ),
              Container(
                width: 150,
                height: 150,
                color: Colors.amber,
              ),
              Container(
                width: 100,
                height: 100,
                color: const Color.fromARGB(255, 7, 255, 48),
              ),
              Container(
                width: 50,
                height: 50,
                color: const Color.fromARGB(255, 48, 7, 255),
              ),
            ],
          ),
        ),
    );
  }
}