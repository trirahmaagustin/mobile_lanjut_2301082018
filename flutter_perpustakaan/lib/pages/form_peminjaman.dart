import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import 'package:intl/intl.dart';

class FormPeminjaman extends StatefulWidget {
  final Peminjaman? peminjaman;
  
  const FormPeminjaman({Key? key, this.peminjaman}) : super(key: key);

  @override
  State<FormPeminjaman> createState() => _FormPeminjamanState();
}

class _FormPeminjamanState extends State<FormPeminjaman> {
  final _formKey = GlobalKey<FormState>();
  final _anggotaController = TextEditingController();
  final _bukuController = TextEditingController();
  DateTime _tanggalPinjam = DateTime.now();
  DateTime? _tanggalKembali;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.peminjaman != null) {
      _anggotaController.text = widget.peminjaman!.anggota.toString();
      _bukuController.text = widget.peminjaman!.buku.toString();
      _tanggalPinjam = widget.peminjaman!.tanggalPinjam;
      _tanggalKembali = widget.peminjaman!.tanggalKembali;
    }
  }

  @override
  void dispose() {
    _anggotaController.dispose();
    _bukuController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        //final peminjamanProvider =
        //    Provider.of<PeminjamanProvider>(context, listen: false);

        final newPeminjaman = Peminjaman(
          id: widget.peminjaman?.id ?? '0',
          tanggalPinjam: _tanggalPinjam,
          tanggalKembali: _tanggalKembali,
          anggota: int.parse(_anggotaController.text),
          buku: int.parse(_bukuController.text),
        );

        print('Sending data:');
        print('Tanggal Pinjam: ${_formatDate(_tanggalPinjam)}');
        print('Tanggal Kembali: ${_tanggalKembali != null ? _formatDate(_tanggalKembali!) : null}');
        print('Anggota ID: ${_anggotaController.text}');
        print('Buku ID: ${_bukuController.text}');

        if (widget.peminjaman == null) {
          //await peminjamanProvider.addPeminjaman(newPeminjaman);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil menambah peminjaman')),
            );
            Navigator.pop(context);
          }
        } else {
          //await peminjamanProvider.editPeminjaman(newPeminjaman);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Berhasil mengubah data peminjaman')),
            );
            Navigator.pop(context);
          }
        }
      } catch (error) {
        print('Error in _saveForm: $error');
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

  Future<void> _selectDate(BuildContext context, bool isReturnDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isReturnDate ? _tanggalKembali ?? DateTime.now() : _tanggalPinjam,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (isReturnDate) {
          _tanggalKembali = picked;
        } else {
          _tanggalPinjam = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.peminjaman == null ? 'Tambah Peminjaman' : 'Edit Peminjaman',
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
                      controller: _anggotaController,
                      decoration: const InputDecoration(
                        labelText: 'ID Anggota',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ID Anggota tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'ID Anggota harus berupa angka';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bukuController,
                      decoration: const InputDecoration(
                        labelText: 'ID Buku',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ID Buku tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'ID Buku harus berupa angka';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Tanggal Pinjam'),
                      subtitle: Text(_formatDate(_tanggalPinjam)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context, false),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Tanggal Kembali'),
                      subtitle: Text(_tanggalKembali != null
                          ? _formatDate(_tanggalKembali!)
                          : 'Belum ditentukan'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context, true),
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
                          widget.peminjaman == null ? 'Tambah' : 'Simpan',
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
