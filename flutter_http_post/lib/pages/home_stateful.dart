import 'package:flutter/material.dart';
import 'package:flutter_http_post/models/http_stateful.dart';


class HomeStateful extends StatefulWidget {
  @override
  _HomeStatefulState createState() => _HomeStatefulState();
}

class _HomeStatefulState extends State<HomeStateful> {
  @override
  Widget build(BuildContext context) {
    HttpStateful dataHttp = HttpStateful();
    return Scaffold(
      appBar: AppBar(
        title: Text("POST - STATEFUL"),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                (dataHttp.id == null)
                    ? "ID : Belum ada data"
                    : "id : ${dataHttp.id}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            FittedBox(
              child: Text(
                "Nama :",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            FittedBox(
              child: Text(
                (dataHttp.name == null)
                    ? "Belum ada data"
                    : dataHttp.name.toString(),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            FittedBox(child: Text("Job : ", style: TextStyle(fontSize: 20))),
            FittedBox(
              child: Text(
                "Belum ada data",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            FittedBox(
              child: Text(
                "Created At : ",
                style: TextStyle(fontSize: 20),
              ),
            ),
            FittedBox(
              child: Text(
                "Belum ada data",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 100),
            OutlinedButton(
              onPressed: () {
                HttpStateful.connectAPI("Jon", "Backend").then(
                  (value) {
                    print(value.name);
                    print(value.job);
                    setState(() {
                      dataHttp = value;
                      print(dataHttp.createAt);
                    });
                  },
                );
              },
              child: Text(
                "POST DATA",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}