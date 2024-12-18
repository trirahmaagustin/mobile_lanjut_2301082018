import 'package:flutter/material.dart';
import 'package:flutter_perpustakaan/pages/form_anggota.dart';
import 'package:flutter_perpustakaan/pages/form_pengembalian.dart';
import 'pages/awal.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/admin.dart';
import 'pages/form_buku.dart';
import 'package:provider/provider.dart';
import 'providers/anggota_provider.dart';
import 'providers/buku_provider.dart';
import 'pages/user.dart';
import 'pages/form_peminjaman.dart';
import 'providers/pengembalian_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AnggotaProvider()),
        ChangeNotifierProvider(create: (ctx) => BukuProvider()),
        ChangeNotifierProvider(create: (ctx) => PengembalianProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Perpustakaan App',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Awal(),
          '/login': (context) => const Login(),
          '/register': (context) => const Register(),
          '/admin': (context) => const Admin(),
          '/admin/anggota/form': (context) => const FormAnggota(),
          '/admin/buku/form': (context) => const FormBuku(),
          '/user_home': (context) => const User(peminjamanData: null),
          '/user/peminjaman/form': (context) => const FormPeminjaman(),
          '/user/pengembalian/form': (context) => const FormPengembalian(),
        },
      ),
    );
  }
}
