import 'package:flutter/material.dart';

class User extends StatelessWidget {
  final dynamic peminjamanData;

  const User({super.key, required this.peminjamanData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA47458),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFA47458),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.library_add_check_outlined),
              title: const Text('Peminjaman'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user/peminjaman/form');
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_add_check_rounded),
              title: const Text('Pengembalian'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user/pengembalian/form');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 100,
                color: Color(0xFFA47458),
              ),
              SizedBox(height: 20),
              Text(
                'Selamat Datang, User!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA47458),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Silakan pilih menu di sidebar untuk memasukkan data peminjaman dan pengembalian',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
