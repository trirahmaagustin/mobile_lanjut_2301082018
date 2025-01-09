import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../services/buku_service.dart';

class BukuScreen extends StatefulWidget {
  const BukuScreen({super.key});

  @override
  _BukuScreenState createState() => _BukuScreenState();
}

class _BukuScreenState extends State<BukuScreen> {
  final BukuService _bukuService = BukuService();
  late Future<List<Buku>> _bukuList;

  @override
  void initState() {
    super.initState();
    _refreshBukuList();
  }

  void _refreshBukuList() {
    setState(() {
      _bukuList = _bukuService.getBuku();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
      ),
      body: FutureBuilder<List<Buku>>(
        future: _bukuList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data buku'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var buku = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(buku.judul),
                  subtitle: Text('${buku.pengarang} (${buku.tahunTerbit})'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showFormDialog(buku),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(buku),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFormDialog(Buku? buku) {
    final formKey = GlobalKey<FormState>();
    final judulController = TextEditingController(text: buku?.judul ?? '');
    final pengarangController = TextEditingController(text: buku?.pengarang ?? '');
    final penerbitController = TextEditingController(text: buku?.penerbit ?? '');
    final tahunTerbitController = TextEditingController(
      text: buku?.tahunTerbit.toString() ?? DateTime.now().year.toString()
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(buku == null ? 'Tambah Buku' : 'Edit Buku'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: judulController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: pengarangController,
                  decoration: const InputDecoration(labelText: 'Pengarang'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pengarang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: penerbitController,
                  decoration: const InputDecoration(labelText: 'Penerbit'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Penerbit tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: tahunTerbitController,
                  decoration: const InputDecoration(labelText: 'Tahun Terbit'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tahun terbit tidak boleh kosong';
                    }
                    final year = int.tryParse(value);
                    if (year == null) {
                      return 'Tahun terbit harus berupa angka';
                    }
                    if (year < 1900 || year > DateTime.now().year) {
                      return 'Tahun terbit tidak valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newBuku = Buku(
                  judul: judulController.text,
                  pengarang: pengarangController.text,
                  penerbit: penerbitController.text,
                  tahunTerbit: int.parse(tahunTerbitController.text),
                );

                try {
                  if (buku == null) {
                    await _bukuService.createBuku(newBuku);
                  } else {
                    await _bukuService.updateBuku(buku.id!, newBuku);
                  }
                  Navigator.pop(context);
                  _refreshBukuList();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        buku == null
                            ? 'Buku berhasil ditambahkan'
                            : 'Buku berhasil diupdate',
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menyimpan data')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Buku buku) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Buku'),
        content: Text('Apakah Anda yakin ingin menghapus ${buku.judul}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _bukuService.deleteBuku(buku.id!);
                Navigator.pop(context);
                _refreshBukuList();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buku berhasil dihapus')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menghapus buku')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
} 