import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/buku_provider.dart';
import '../../models/buku.dart';

class FormBuku extends StatefulWidget {
  final Buku? buku; // null jika tambah baru, berisi data jika edit

  const FormBuku({super.key, this.buku});

  @override
  State<FormBuku> createState() => _FormBukuState();
}

class _FormBukuState extends State<FormBuku> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _pengarangController = TextEditingController();
  final _penerbitController = TextEditingController();
  String? _tahunTerbit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.buku != null) {
      // Jika mode edit, isi form dengan data yang ada
      _judulController.text = widget.buku!.judul;
      _pengarangController.text = widget.buku!.pengarang ?? '';
      _penerbitController.text = widget.buku!.penerbit ?? '';
      _tahunTerbit = widget.buku!.tahunTerbit;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _pengarangController.dispose();
    _penerbitController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final bukuProvider = Provider.of<BukuProvider>(context, listen: false);

        if (widget.buku == null) {
          // Mode tambah
          await bukuProvider.addBuku(
            _judulController.text,
            _pengarangController.text.isEmpty
                ? null
                : _pengarangController.text,
            _penerbitController.text.isEmpty ? null : _penerbitController.text,
            _tahunTerbit,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil menambah buku')),
            );
            Navigator.pop(context);
          }
        } else {
          // Mode edit
          await bukuProvider.editBuku(
            widget.buku!.id,
            _judulController.text,
            _pengarangController.text.isEmpty
                ? null
                : _pengarangController.text,
            _penerbitController.text.isEmpty ? null : _penerbitController.text,
            _tahunTerbit,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil mengubah data buku')),
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
          widget.buku == null ? 'Tambah Buku' : 'Edit Buku',
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
                      controller: _judulController,
                      decoration: const InputDecoration(
                        labelText: 'Judul',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul tidak boleh kosong';
                        }
                        if (value.length > 200) {
                          return 'Judul maksimal 200 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pengarangController,
                      decoration: const InputDecoration(
                        labelText: 'Pengarang',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null && value.length > 100) {
                          return 'Pengarang maksimal 100 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _penerbitController,
                      decoration: const InputDecoration(
                        labelText: 'Penerbit',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null && value.length > 100) {
                          return 'Penerbit maksimal 100 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _tahunTerbit,
                      decoration: const InputDecoration(
                        labelText: 'Tahun Terbit (YYYY)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!Buku.isValidTahunTerbit(value)) {
                            return 'Format tahun tidak valid';
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _tahunTerbit = value.isEmpty ? null : value;
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
                          widget.buku == null ? 'Tambah' : 'Simpan',
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
