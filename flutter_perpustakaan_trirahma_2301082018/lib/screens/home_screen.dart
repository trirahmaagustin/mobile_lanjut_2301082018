import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../services/statistics_service.dart';
import '../services/data_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, int>> statisticsFuture;
  late Future<List<Buku>> bukuFuture;

  @override
  void initState() {
    super.initState();
    // Memanggil service
    statisticsFuture = StatisticsService.getStatistics();
    bukuFuture = DataService.getBuku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Menampilkan statistik
          FutureBuilder<Map<String, int>>(
            future: statisticsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Jumlah Buku: ${snapshot.data!['buku']}');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),

          // Menampilkan daftar buku
          FutureBuilder<List<Buku>>(
            future: bukuFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].judul),
                      subtitle: Text(snapshot.data![index].pengarang),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
