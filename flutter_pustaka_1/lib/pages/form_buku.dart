import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/buku.dart';

class FormBuku extends StatelessWidget {
  static const routeName = '/add-buku';

  final TextEditingController kodeController = TextEditingController();
  final TextEditingController judulController = TextEditingController();
  final TextEditingController pengarangController = TextEditingController();
  final TextEditingController penerbitController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();

  FormBuku({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil provider Bukus
    final bukus = Provider.of<Bukus>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA47458),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _submitData(context, bukus);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/buku.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.my_library_books, size: 60, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      'Input Data Buku',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Text Fields
                    _buildTextField(kodeController, 'Kode Buku'),
                    const SizedBox(height: 15),
                    _buildTextField(judulController, 'Judul Buku'),
                    const SizedBox(height: 15),
                    _buildTextField(pengarangController, 'Pengarang Buku'),
                    const SizedBox(height: 15),
                    _buildTextField(penerbitController, 'Penerbit Buku'),
                    const SizedBox(height: 15),
                    _buildTextField(
                      tahunController,
                      'Tahun Terbit',
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        _submitData(context, bukus);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA47458),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text}) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFA47458),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _submitData(BuildContext context, bukus) {
    // Validasi input
    if (kodeController.text.isEmpty ||
        judulController.text.isEmpty ||
        pengarangController.text.isEmpty ||
        penerbitController.text.isEmpty ||
        tahunController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field harus diisi!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Validasi tahun harus angka
    if (int.tryParse(tahunController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tahun harus berupa angka!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Submit data ke provider
    bukus
        .addBuku(
      kodeController.text,
      judulController.text,
      pengarangController.text,
      penerbitController.text,
      tahunController.text,
    )
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Buku Berhasil Disimpan"),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacementNamed(context, '/anggota-list');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal Menyimpan Data: $error"),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}
