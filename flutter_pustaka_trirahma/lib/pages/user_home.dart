import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/buku_provider.dart';
import '../models/buku.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String _searchQuery = '';
  late String userEmail;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BukuProvider>(context, listen: false).fetchBuku();
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        setState(() {
          userEmail = args as String;
        });
      }
    });
  }

  List<Buku> _filterBooks(List<Buku> books) {
    if (_searchQuery.isEmpty) return books;
    return books
        .where((book) =>
            book.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (book.pengarang
                    ?.toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ??
                false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.menu_book, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'hi, ${userEmail.split('@')[0]}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFA47458),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFA47458).withOpacity(0.1),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'find your best book',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildChip('fiction'),
                _buildChip('novel'),
                _buildChip('comic'),
                _buildChip('biography'),
                _buildChip('historical'),
              ],
            ),
          ),
          // Book List
          Expanded(
            child: Consumer<BukuProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredBooks = _filterBooks(provider.bukuList);

                if (filteredBooks.isEmpty) {
                  return const Center(child: Text('Tidak ada buku tersedia'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final buku = filteredBooks[index];
                    return _buildBookCard(buku);
                  },
                );
              },
            ),
          ),
          // Bottom Navigation
          BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFA47458),
            unselectedItemColor: Colors.grey,
            currentIndex: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: const Color(0xFFA47458).withOpacity(0.1),
        labelStyle: const TextStyle(color: Color(0xFFA47458)),
      ),
    );
  }

  Widget _buildBookCard(Buku buku) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => _showBookDetail(context, buku),
        leading: const Icon(Icons.book, color: Color(0xFFA47458), size: 40),
        title: Text(
          buku.judul,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFA47458),
          ),
        ),
        subtitle: Text(buku.pengarang ?? 'Pengarang tidak diketahui'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  void _showBookDetail(BuildContext context, Buku buku) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buku.judul,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA47458),
              ),
            ),
            const SizedBox(height: 16),
            if (buku.pengarang?.isNotEmpty ?? false) ...[
              Text('Pengarang: ${buku.pengarang}'),
              const SizedBox(height: 8),
            ],
            if (buku.penerbit?.isNotEmpty ?? false) ...[
              Text('Penerbit: ${buku.penerbit}'),
              const SizedBox(height: 8),
            ],
            if (buku.tahun_terbit?.isNotEmpty ?? false)
              Text('Tahun Terbit: ${buku.tahun_terbit}'),
          ],
        ),
      ),
    );
  }
}
