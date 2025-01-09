import 'package:flutter/material.dart';
import '../models/anggota.dart';
import '../services/anggota_service.dart';

class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({super.key});

  @override
  _AnggotaScreenState createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  final AnggotaService _anggotaService = AnggotaService();
  late Future<List<Anggota>> _anggotaList;

  @override
  void initState() {
    super.initState();
    _refreshAnggotaList();
  }

  void _refreshAnggotaList() {
    setState(() {
      _anggotaList = _anggotaService.getAnggota();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota'),
      ),
      body: FutureBuilder<List<Anggota>>(
        future: _anggotaList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data anggota'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var anggota = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(anggota.nama),
                  subtitle: Text('NIM: ${anggota.nim}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showFormDialog(anggota),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(anggota),
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

  void _showFormDialog(Anggota? anggota) {
    final formKey = GlobalKey<FormState>();
    final nimController = TextEditingController(text: anggota?.nim ?? '');
    final namaController = TextEditingController(text: anggota?.nama ?? '');
    final alamatController = TextEditingController(text: anggota?.alamat ?? '');
    String jenisKelamin = anggota?.jenisKelamin ?? 'L';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(anggota == null ? 'Tambah Anggota' : 'Edit Anggota'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nimController,
                  decoration: const InputDecoration(labelText: 'NIM'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIM tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  maxLines: 2,
                ),
                DropdownButtonFormField<String>(
                  value: jenisKelamin,
                  decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                  items: const [
                    DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                    DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                  ],
                  onChanged: (value) {
                    jenisKelamin = value!;
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
                final newAnggota = Anggota(
                  nim: nimController.text,
                  nama: namaController.text,
                  alamat: alamatController.text,
                  jenisKelamin: jenisKelamin,
                );

                try {
                  if (anggota == null) {
                    await _anggotaService.createAnggota(newAnggota);
                  } else {
                    await _anggotaService.updateAnggota(
                        anggota.id!, newAnggota);
                  }
                  Navigator.pop(context);
                  _refreshAnggotaList();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        anggota == null
                            ? 'Data berhasil ditambahkan'
                            : 'Data berhasil diupdate',
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

  void _showDeleteDialog(Anggota anggota) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Anggota'),
        content: Text('Apakah Anda yakin ingin menghapus ${anggota.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _anggotaService.deleteAnggota(anggota.id!);
                Navigator.pop(context);
                _refreshAnggotaList();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data berhasil dihapus')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menghapus data')),
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
