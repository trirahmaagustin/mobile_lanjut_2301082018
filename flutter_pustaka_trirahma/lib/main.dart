import 'package:flutter/material.dart';
import 'package:flutter_pustaka_trirahma/pages/form_buku.dart';
import 'pages/started.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/admin_page.dart';
import 'pages/form_anggota.dart';
import 'pages/anggota_page.dart';
import 'pages/buku_page.dart';
import 'pages/user_home.dart';
import 'package:provider/provider.dart';
import 'providers/anggota_provider.dart';
import 'providers/buku_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnggotaProvider()),
        ChangeNotifierProvider(create: (_) => BukuProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pustaka',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartedPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/admin_home': (context) => const AdminPage(),
        '/user_home': (context) => const UserHome(),
        '/form_anggota': (context) => const FormAnggota(),
        '/anggota': (context) => const AnggotaPage(),
        '/form_buku': (context) => const FormBuku(),
        '/buku': (context) => const BukuPage(),
      },
    );
  }
}
