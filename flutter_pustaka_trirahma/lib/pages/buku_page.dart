import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/buku_provider.dart';
import '../models/buku.dart';
import 'form_buku.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({Key? key}) : super(key: key);

  @override
  State<BukuPage> createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<BukuProvider>(context, listen: false).fetchBuku(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Buku',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA47458),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormBuku()),
          ).then((_) {
            Provider.of<BukuProvider>(context, listen: false).fetchBuku();
          });
        },
        backgroundColor: const Color(0xFFA47458),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<BukuProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.bukuList.isEmpty) {
            return const Center(child: Text('Tidak ada data buku'));
          }

          return ListView.builder(
            itemCount: provider.bukuList.length,
            itemBuilder: (context, index) {
              final buku = provider.bukuList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFA47458),
                    child: Text(
                      buku.judul[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(buku.judul),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (buku.pengarang?.isNotEmpty ?? false)
                        Text('Pengarang: ${buku.pengarang}'),
                      if (buku.penerbit?.isNotEmpty ?? false)
                        Text('Penerbit: ${buku.penerbit}'),
                      if (buku.tahun_terbit?.isNotEmpty ?? false)
                        Text('Tahun Terbit: ${buku.tahun_terbit}'),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormBuku(buku: buku),
                          ),
                        ).then((_) {
                          Provider.of<BukuProvider>(context, listen: false).fetchBuku();
                        });
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, buku);
                      }
                    },
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Buku buku) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus ${buku.judul}?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  Navigator.of(context).pop();
                  print('Attempting to delete buku with ID: ${buku.id}');
                  
                  final success = await Provider.of<BukuProvider>(context, listen: false)
                      .deleteBuku(buku.id!);
                  
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Buku berhasil dihapus')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal menghapus buku. Silakan coba lagi.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  print('Error deleting buku: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Terjadi kesalahan: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
} 