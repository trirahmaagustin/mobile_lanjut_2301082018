import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/anggota.dart';
import '../providers/anggota.dart';
import '../models/buku.dart'; 
import '../providers/buku.dart';
import '../widgets/custom_table.dart';

class AnggotaListScreen extends StatelessWidget {
  static const routeName = '/anggota-list';

  const AnggotaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data anggota dari provider
    final anggotas = Provider.of<Anggotas>(context);
    final List<Anggota> allAnggota = anggotas.allAnggota;

    if (allAnggota.isEmpty) {
      anggotas.initializeData();
    }

    // Mengambil data buku dari provider
    final bukus = Provider.of<Bukus>(context);
    final List<Buku> allBuku = bukus.allBuku;

    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color(0xFFA47458),
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
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Data Anggota",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  allAnggota.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada data anggota.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : CustomTable(
                          data: allAnggota,
                          columns: const ["Nama", "Kode", "NIM", "Jenis Kelamin", "Alamat"],
                          rows: (anggota) => [
                            anggota.nama,
                            anggota.kode,
                            anggota.nim,
                            anggota.jekel,
                            anggota.alamat,
                          ],
                          onEdit: (anggota) {
                            // Logika untuk edit
                            print("Edit anggota: ${anggota.nama}");
                          },
                          onDelete: (anggota) {
                            // Logika untuk hapus
                            print("Hapus anggota: ${anggota.nama}");
                          },
                        ),
                  const SizedBox(height: 40),
                  const Text(
                    "Data Buku",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  allBuku.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada data buku.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : _buildTable(
                          data: allBuku,
                          columns: const [
                            "Kode",
                            "Judul",
                            "Pengarang",
                            "Penerbit",
                            "Tahun Terbit"
                          ],
                          rows: (buku) => [
                            buku.kode,
                            buku.judul,
                            buku.pengarang,
                            buku.penerbit,
                            buku.tahun_terbit,
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable<T>({
    required List<T> data,
    required List<String> columns,
    required List<String> Function(T item) rows,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: DataTable(
          headingRowColor:
              WidgetStateProperty.resolveWith((states) => Colors.brown[200]),
          border: TableBorder.all(
            color: Colors.brown.shade400,
            width: 1,
          ),
          columns: columns
              .map((column) => DataColumn(
                    label: Text(
                      column,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ))
              .toList(),
          rows: data.map((item) {
            final cells = rows(item);
            return DataRow(
              cells: cells
                  .map((cell) => DataCell(Text(
                        cell,
                        style: const TextStyle(fontSize: 14),
                      )))
                  .toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
