import 'package:flutter/material.dart';
import 'package:flutter_pustaka_1/pages/anggota_list_screen.dart';
import 'package:provider/provider.dart';
import '../providers/anggota.dart';

class FormAnggota extends StatelessWidget {
  static const routeName = '/add-anggota';

  final TextEditingController namaController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController jekelController = TextEditingController();

  FormAnggota({super.key});

  @override
  Widget build(BuildContext context) {
    final anggotas = Provider.of<Anggotas>(context, listen: false);

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
              _submitData(context, anggotas);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
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
                    const Icon(Icons.person_add, size: 60, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      'Input Data Anggota',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(namaController, 'Nama'),
                    const SizedBox(height: 15),
                    _buildTextField(kodeController, 'Kode'),
                    const SizedBox(height: 15),
                    _buildTextField(nimController, 'NIM'),
                    const SizedBox(height: 15),
                    _buildTextField(alamatController, 'Alamat'),
                    const SizedBox(height: 15),
                    _buildTextField(jekelController, 'Jenis Kelamin'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _submitData(context, anggotas);
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFA47458),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _submitData(BuildContext context, Anggotas anggotas) {
    anggotas
        .addAnggota(
      namaController.text,
      kodeController.text,
      nimController.text,
      jekelController.text,
      alamatController.text,
    )
        .then((response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Anggota Berhasil Disimpan"),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacementNamed(context, AnggotaListScreen.routeName);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal Menyimpan Data"),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
