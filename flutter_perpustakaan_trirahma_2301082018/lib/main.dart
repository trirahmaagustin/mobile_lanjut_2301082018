import 'package:flutter/material.dart';
import 'screens/get_started_screen.dart';
import 'screens/anggota_screen.dart';
import 'screens/buku_screen.dart';
import 'screens/peminjaman_screen.dart';
import 'screens/pengembalian_screen.dart';
import 'services/statistics_service.dart';

void main() {
  runApp(const MyApp());
}

// Definisikan tema kustom
class CustomTheme {
  static const Color primaryBrown = Color.fromARGB(255, 112, 51, 13);
  static const Color lightBrown = Color.fromARGB(184, 183, 126, 85);
  static const Color darkBrown = Color(0xFF654321);
  static const Color cream = Color(0xFFF5DEB3);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpustakaan App',
      theme: ThemeData(
        primaryColor: CustomTheme.primaryBrown,
        scaffoldBackgroundColor: CustomTheme.cream,
        appBarTheme: const AppBarTheme(
          backgroundColor: CustomTheme.primaryBrown,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: CustomTheme.cream,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomTheme.primaryBrown,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: CustomTheme.darkBrown,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: CustomTheme.darkBrown),
          bodyMedium: TextStyle(color: CustomTheme.darkBrown),
        ),
      ),
      home: const GetStartedScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, int> statistics = {
    'anggota': 0,
    'buku': 0,
    'peminjaman': 0,
    'pengembalian': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final stats = await StatisticsService.getStatistics();
    setState(() {
      statistics = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perpustakaan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            color: CustomTheme.cream,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFA67B5B),
                  image: DecorationImage(
                    image: AssetImage('assets/images/buku.jpeg'),
                    fit: BoxFit.cover,
                    opacity: 0.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu Perpustakaan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.person,
                title: 'Anggota',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnggotaScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.book,
                title: 'Buku',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BukuScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.book_online,
                title: 'Peminjaman',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PeminjamanScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.assignment_return,
                title: 'Pengembalian',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PengembalianScreen()),
                ),
              ),
              const Divider(color: CustomTheme.darkBrown),
              _buildDrawerItem(
                context,
                icon: Icons.logout,
                title: 'Sign Out',
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GetStartedScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/buku.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.modulate,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.library_books,
                size: 80,
                color: CustomTheme.primaryBrown,
              ),
              const SizedBox(height: 16),
              Text(
                'Selamat Datang\ndi Perpustakaan',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 3.0,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                        'Anggota', statistics['anggota'] ?? 0, Icons.person),
                    _buildStatCard('Buku', statistics['buku'] ?? 0, Icons.book),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Peminjaman', statistics['peminjaman'] ?? 0,
                        Icons.book_online),
                    _buildStatCard(
                        'Pengembalian',
                        statistics['pengembalian'] ?? 0,
                        Icons.assignment_return),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CustomTheme.lightBrown.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: CustomTheme.darkBrown),
        title: Text(
          title,
          style: const TextStyle(
            color: CustomTheme.darkBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: CustomTheme.lightBrown.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: CustomTheme.darkBrown),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomTheme.darkBrown,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CustomTheme.darkBrown,
            ),
          ),
        ],
      ),
    );
  }
}
