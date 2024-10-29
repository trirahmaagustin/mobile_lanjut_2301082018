import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/http_provider.dart';
import './pages/home_provider.dart';
//import './models/http_stateful.dart';

void main(){
  runApp(Myapp());
}

class Myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => HttpProvider(), 
        child: HomeProvider(),
        ),
    );
  }
}