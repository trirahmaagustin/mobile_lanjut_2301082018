import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anggota_provider.dart';
import '../models/anggota.dart';

class FormAnggota extends StatefulWidget {
  const FormAnggota({Key? key}) : super(key: key);

  @override
  State<FormAnggota> createState() => _FormAnggotaState();
}

class _FormAnggotaState extends State<FormAnggota> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  JenisKelamin _selectedJekel = JenisKelamin.L;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Anggota',
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
                // NIM Field
                TextFormField(
                  controller: _nimController,
                  decoration: InputDecoration(
                    labelText: 'NIM',
                    labelStyle: const TextStyle(color: Color(0xFF8B5E34)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFA47458)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFA47458)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF8B5E34), width: 2),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFAF0E6),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIM tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Nama Field
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    labelStyle: const TextStyle(color: Color(0xFF8B5E34)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFA47458)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF8B5E34), width: 2),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFAF0E6),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Alamat Field
                TextFormField(
                  controller: _alamatController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    labelStyle: const TextStyle(color: Color(0xFF8B5E34)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFA47458)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFA47458)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF8B5E34), width: 2),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFAF0E6),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Jenis Kelamin Dropdown
                DropdownButtonFormField<JenisKelamin>(
                  value: _selectedJekel,
                  decoration: InputDecoration(
                    labelText: 'Jenis Kelamin',
                    labelStyle: const TextStyle(color: Color(0xFF8B5E34)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFA47458)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFA47458)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF8B5E34), width: 2),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFAF0E6),
                  ),
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
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih jenis kelamin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: _saveAnggota,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA47458),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
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

  Future<void> _saveAnggota() async {
    if (_formKey.currentState!.validate()) {
      try {
        final anggota = Anggota(
          nim: _nimController.text,
          nama: _namaController.text,
          alamat: _alamatController.text,
          jenis_kelamin: _selectedJekel,
        );

        final success = await Provider.of<AnggotaProvider>(context, listen: false)
            .addAnggota(anggota);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil disimpan')),
          );
          _clearForm();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan data. Silakan coba lagi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearForm() {
    _nimController.clear();
    _namaController.clear();
    _alamatController.clear();
    setState(() {
      _selectedJekel = JenisKelamin.L;
    });
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }
}
