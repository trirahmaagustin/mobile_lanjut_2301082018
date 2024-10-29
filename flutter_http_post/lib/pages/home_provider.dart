import 'package:flutter/material.dart';  
import 'package:flutter_http_post/models/http_provider.dart';  
import 'package:provider/provider.dart';  
  
class HomeProvider extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
   final dataProvider = Provider.of<HttpProvider>(context);  
   return Scaffold(  
    appBar: AppBar(  
      title: Text("POST - PROVIDER"),  
    ),  
    body: Container(  
      width: double.infinity,  
      margin: EdgeInsets.all(20),  
      child: Column(  
       mainAxisAlignment: MainAxisAlignment.center,  
       children: [  
        FittedBox(  
          child: Consumer<HttpProvider>(  
           builder: (context, value, child) {  
            return Text(  
              value.data["id"] == null  
                ? "ID : Belum ada data"  
                : "ID : ${value.data["id"]}",  
              style: TextStyle(fontSize: 20),  
            );  
           },  
          ),  
        ),  
        SizedBox(height: 20),  
        FittedBox(  
          child: Text(  
           "Name :",  
           style: TextStyle(fontSize: 20),  
          ),  
        ),  
        FittedBox(  
          child: Consumer<HttpProvider>(  
           builder: (context, value, child) {  
            return Text(  
              value.data["name"] == null  
                ? "Belum ada data"  
                : "Name : ${value.data["name"]}",  
              style: TextStyle(fontSize: 20),  
            );  
           },  
          ),  
        ),  
        SizedBox(height: 20),  
        FittedBox(  
          child: Text(  
           "Job :",  
           style: TextStyle(fontSize: 20),  
          ),  
        ),  
        FittedBox(  
          child: Consumer<HttpProvider>(  
           builder: (context, value, child) {  
            return Text(  
              value.data["job"] == null  
                ? "Belum ada data"  
                : "Job : ${value.data["job"]}",  
              style: TextStyle(fontSize: 20),  
            );  
           },  
          ),  
        ),  
        SizedBox(height: 100),  
        OutlinedButton(  
          onPressed: () {  
           dataProvider.connectAPI("Rahma", "Developer");  
          },  
          child: Text(  
           "POST DATA",  
           style: TextStyle(fontSize: 25),  
          ),  
        ),  
       ],  
      ),  
    ),  
   );  
  }  
}