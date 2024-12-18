import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/anggota_provider.dart';
import '../../models/anggota.dart';

class FormAnggota extends StatefulWidget {
  final Anggota? anggota; // null jika tambah baru, berisi data jika edit

  const FormAnggota({super.key, this.anggota});

  @override
  State<FormAnggota> createState() => _FormAnggotaState();
}

class _FormAnggotaState extends State<FormAnggota> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  String _jenisKelamin = 'L';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.anggota != null) {
      // Jika mode edit, isi form dengan data yang ada
      _nimController.text = widget.anggota!.nim;
      _namaController.text = widget.anggota!.nama;
      _alamatController.text = widget.anggota!.alamat ?? '';
      _jenisKelamin = widget.anggota!.jenisKelamin;
    }
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final anggotaProvider =
            Provider.of<AnggotaProvider>(context, listen: false);

        if (widget.anggota == null) {
          // Mode tambah
          await anggotaProvider.addAnggota(
            _nimController.text,
            _namaController.text,
            _alamatController.text,
            _jenisKelamin,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil menambah anggota')),
            );
            Navigator.pop(context);
          }
        } else {
          // Mode edit
          await anggotaProvider.editAnggota(
            widget.anggota!.id,
            _nimController.text,
            _namaController.text,
            _alamatController.text,
            _jenisKelamin,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil mengubah data anggota')),
            );
            Navigator.pop(context);
          }
        }
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error!'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.anggota == null ? 'Tambah Anggota' : 'Edit Anggota',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA47458),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nimController,
                      decoration: const InputDecoration(
                        labelText: 'NIM',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIM tidak boleh kosong';
                        }
                        if (value.length > 20) {
                          return 'NIM maksimal 20 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        if (value.length > 100) {
                          return 'Nama maksimal 100 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _alamatController,
                      decoration: const InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _jenisKelamin,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Kelamin',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'L',
                          child: Text('Laki-laki'),
                        ),
                        DropdownMenuItem(
                          value: 'P',
                          child: Text('Perempuan'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _jenisKelamin = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA47458),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _saveForm,
                        child: Text(
                          widget.anggota == null ? 'Tambah' : 'Simpan',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
