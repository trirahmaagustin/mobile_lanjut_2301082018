import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/buku_provider.dart';
import '../models/buku.dart';

class FormBuku extends StatefulWidget {
  final Buku? buku;
  const FormBuku({Key? key, this.buku}) : super(key: key);

  @override
  State<FormBuku> createState() => _FormBukuState();
}

class _FormBukuState extends State<FormBuku> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _pengarangController = TextEditingController();
  final TextEditingController _penerbitController = TextEditingController();
  final TextEditingController _tahunTerbitController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.buku != null) {
      _judulController.text = widget.buku!.judul;
      _pengarangController.text = widget.buku!.pengarang ?? '';
      _penerbitController.text = widget.buku!.penerbit ?? '';
      _tahunTerbitController.text = widget.buku!.tahun_terbit ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Buku',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA47458),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pengarangController,
                  decoration: InputDecoration(
                    labelText: 'Pengarang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _penerbitController,
                  decoration: InputDecoration(
                    labelText: 'Penerbit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tahunTerbitController,
                  decoration: InputDecoration(
                    labelText: 'Tahun Terbit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveBuku,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA47458),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveBuku() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        final buku = Buku(
          id: widget.buku?.id,
          judul: _judulController.text,
          pengarang: _pengarangController.text.isEmpty ? null : _pengarangController.text,
          penerbit: _penerbitController.text.isEmpty ? null : _penerbitController.text,
          tahun_terbit: _tahunTerbitController.text.isEmpty ? null : _tahunTerbitController.text,
        );

        final provider = Provider.of<BukuProvider>(context, listen: false);
        bool success = false;

        if (widget.buku != null) {
          success = await provider.updateBuku(buku);
        } else {
          success = await provider.addBuku(buku);
        }

        if (!mounted) return;

        setState(() {
          _isSaving = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil disimpan')),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan data'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error saving buku: $e');
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _pengarangController.dispose();
    _penerbitController.dispose();
    _tahunTerbitController.dispose();
    super.dispose();
  }
}
