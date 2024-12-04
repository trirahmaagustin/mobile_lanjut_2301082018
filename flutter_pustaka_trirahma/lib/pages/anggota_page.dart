import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anggota_provider.dart';
import '../models/anggota.dart';
import 'form_anggota.dart';

class AnggotaPage extends StatefulWidget {
  const AnggotaPage({Key? key}) : super(key: key);

  @override
  State<AnggotaPage> createState() => _AnggotaPageState();
}

class _AnggotaPageState extends State<AnggotaPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AnggotaProvider>(context, listen: false).fetchAnggota(),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Anggota anggota) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus ${anggota.nama}?'),
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
                  print('Attempting to delete anggota with ID: ${anggota.id}');
                  
                  final success = await Provider.of<AnggotaProvider>(context, listen: false)
                      .deleteAnggota(anggota.id!);
                  
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Anggota berhasil dihapus')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal menghapus anggota. Silakan coba lagi.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  print('Error deleting anggota: $e');
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

  void _showEditForm(BuildContext context, Anggota anggota) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditAnggotaForm(anggota: anggota),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Anggota',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA47458),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormAnggota()),
          ).then((_) {
            Provider.of<AnggotaProvider>(context, listen: false).fetchAnggota();
          });
        },
        backgroundColor: const Color(0xFFA47458),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<AnggotaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.anggotaList.isEmpty) {
            return const Center(child: Text('Tidak ada data anggota'));
          }

          return ListView.builder(
            itemCount: provider.anggotaList.length,
            itemBuilder: (context, index) {
              final anggota = provider.anggotaList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFA47458),
                    child: Text(
                      anggota.nama[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(anggota.nama),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NIM: ${anggota.nim}'),
                      Text('Jenis Kelamin: ${anggota.jenis_kelamin == JenisKelamin.L ? 'Laki-laki' : 'Perempuan'}'),
                      if (anggota.alamat.isNotEmpty) Text('Alamat: ${anggota.alamat}'),
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
                        _showEditForm(context, anggota);
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, anggota);
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
}

class EditAnggotaForm extends StatefulWidget {
  final Anggota anggota;

  const EditAnggotaForm({Key? key, required this.anggota}) : super(key: key);

  @override
  State<EditAnggotaForm> createState() => _EditAnggotaFormState();
}

class _EditAnggotaFormState extends State<EditAnggotaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nimController;
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late JenisKelamin _selectedJekel;

  @override
  void initState() {
    super.initState();
    _nimController = TextEditingController(text: widget.anggota.nim);
    _namaController = TextEditingController(text: widget.anggota.nama);
    _alamatController = TextEditingController(text: widget.anggota.alamat);
    _selectedJekel = widget.anggota.jenis_kelamin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nimController,
              decoration: const InputDecoration(labelText: 'NIM'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIM tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            DropdownButtonFormField<JenisKelamin>(
              value: _selectedJekel,
              decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              items: JenisKelamin.values.map((JenisKelamin jekel) {
                return DropdownMenuItem<JenisKelamin>(
                  value: jekel,
                  child: Text(jekel == JenisKelamin.L ? 'Laki-laki' : 'Perempuan'),
                );
              }).toList(),
              onChanged: (JenisKelamin? value) {
                if (value != null) {
                  setState(() {
                    _selectedJekel = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final updatedAnggota = Anggota(
                      id: widget.anggota.id,
                      nim: _nimController.text,
                      nama: _namaController.text,
                      alamat: _alamatController.text,
                      jenis_kelamin: _selectedJekel,
                    );

                    print('Updating anggota: ${updatedAnggota.toJson()}');

                    final success = await Provider.of<AnggotaProvider>(context, listen: false)
                        .updateAnggota(updatedAnggota);

                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data berhasil diperbarui')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal memperbarui data. Silakan coba lagi.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    print('Error in update: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Terjadi kesalahan: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA47458),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }
} 