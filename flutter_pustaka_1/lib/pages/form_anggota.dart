import 'package:flutter/material.dart';

class FormAnggota extends StatelessWidget {
  const FormAnggota({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA47458),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Background image as in AdminMenuPage
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/picture1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scrollbar(
            thumbVisibility: true, // Membuat scrollbar selalu terlihat
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_add,
                      size: 60,
                      color: Colors.white,
                    ),
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
                    // Nama field
                    SizedBox(
                      width: 300, // Lebar TextFormField sesuai kebutuhan
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'Nama',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Kode field
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'Kode',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // NIM field
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'NIM',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Alamat field
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'Alamat',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Jenis Kelamin field
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'Jenis Kelamin',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Elevated Button to submit the form
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data Anggota Disimpan')),
                        );
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
}
