import 'package:flutter/material.dart';

class FormBuku extends StatelessWidget {
  const FormBuku({Key? key}) : super(key: key);

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
            thumbVisibility: true, // Menampilkan scrollbar secara default
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.my_library_books,
                      size: 60,
                      color: Colors.white,
                    ),
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
                    // Kode Buku field
                    SizedBox(
                      width: 300, // Menetapkan lebar form input
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'Kode Buku',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Judul Buku field
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'Judul Buku',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Pengarang Buku field
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'Pengarang Buku',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Penerbit Buku field
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'Penerbit Buku',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Tahun Terbit field
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFA47458),
                          labelText: 'Tahun Terbit',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Elevated Button to submit the form
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data Buku Disimpan')),
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
