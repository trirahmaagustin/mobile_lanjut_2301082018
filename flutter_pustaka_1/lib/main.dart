import 'package:flutter/material.dart';
import 'package:flutter_pustaka_1/pages/anggota_list_screen.dart';
import 'package:flutter_pustaka_1/pages/form_buku.dart';
import 'package:flutter_pustaka_1/providers/buku.dart';
import 'package:provider/provider.dart';
import 'pages/library_screen.dart';
import 'pages/form_anggota.dart';
//import 'pages/anggota_list_screen.dart';
import 'providers/anggota.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Anggotas()),
        ChangeNotifierProvider(create: (context) => Bukus()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pustaka',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LibraryScreen(),
        routes: {
          AnggotaListScreen.routeName: (context) => const AnggotaListScreen(),
          FormAnggota.routeName: (context) => FormAnggota(),
          FormBuku.routeName: (context) => FormBuku(),
        },
      ),
    );
  }
}
