import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pengembalian.dart';
import '../services/pengembalian_service.dart';

class PengembalianScreen extends StatefulWidget {
  const PengembalianScreen({super.key});

  @override
  _PengembalianScreenState createState() => _PengembalianScreenState();
}

class _PengembalianScreenState extends State<PengembalianScreen> {
  final PengembalianService _pengembalianService = PengembalianService();
  late Future<List<Pengembalian>> _pengembalianList;

  @override
  void initState() {
    super.initState();
    _refreshPengembalianList();
  }

  void _refreshPengembalianList() {
    setState(() {
      _pengembalianList = _pengembalianService.getPengembalian();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengembalian'),
      ),
      body: FutureBuilder<List<Pengembalian>>(
        future: _pengembalianList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data pengembalian'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var pengembalian = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(
                      '${pengembalian.namaPeminjam} - ${pengembalian.judulBuku}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Dikembalikan: ${DateFormat('dd/MM/yyyy').format(pengembalian.tanggalDikembalikan)}'),
                      Text(
                          'Status: ${pengembalian.terlambat ? "Terlambat" : "Tepat Waktu"}'),
                      if (pengembalian.terlambat)
                        Text(
                            'Denda: Rp ${pengembalian.denda.toStringAsFixed(0)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(pengembalian),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFormDialog() async {
    try {
      final activePeminjaman = await _pengembalianService.getActivePeminjaman();
      if (!mounted) return;

      if (activePeminjaman.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada peminjaman yang aktif')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => _buildPengembalianForm(activePeminjaman),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data peminjaman')),
      );
    }
  }

  Widget _buildPengembalianForm(List<Map<String, dynamic>> activePeminjaman) {
    final formKey = GlobalKey<FormState>();
    Map<String, dynamic>? selectedPeminjaman;
    DateTime selectedTanggalDikembalikan = DateTime.now();

    return StatefulBuilder(
      builder: (context, setState) {
        // Hitung keterlambatan dan denda
        bool isTerlambat = false;
        double denda = 0;
        if (selectedPeminjaman != null) {
          final tanggalKembali =
              DateTime.parse(selectedPeminjaman!['tanggal_kembali']);
          isTerlambat = selectedTanggalDikembalikan.isAfter(tanggalKembali);
          if (isTerlambat) {
            final selisihHari =
                selectedTanggalDikembalikan.difference(tanggalKembali).inDays;
            denda = selisihHari * 1000.0; // Denda Rp 1.000 per hari
          }
        }

        return AlertDialog(
          title: const Text('Tambah Pengembalian'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: selectedPeminjaman,
                    decoration:
                        const InputDecoration(labelText: 'Pilih Peminjaman'),
                    items: activePeminjaman.map((peminjaman) {
                      return DropdownMenuItem(
                        value: peminjaman,
                        child: Text(
                            '${peminjaman['nama_peminjam']} - ${peminjaman['judul_buku']}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPeminjaman = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) return 'Pilih peminjaman';
                      return null;
                    },
                  ),
                  ListTile(
                    title: const Text('Tanggal Pengembalian'),
                    subtitle: Text(DateFormat('dd/MM/yyyy')
                        .format(selectedTanggalDikembalikan)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedTanggalDikembalikan,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedTanggalDikembalikan = picked;
                        });
                      }
                    },
                  ),
                  if (selectedPeminjaman != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Status: ${isTerlambat ? "Terlambat" : "Tepat Waktu"}',
                      style: TextStyle(
                        color: isTerlambat ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isTerlambat)
                      Text('Denda: Rp ${denda.toStringAsFixed(0)}'),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate() &&
                    selectedPeminjaman != null) {
                  final newPengembalian = Pengembalian(
                    tanggalDikembalikan: selectedTanggalDikembalikan,
                    terlambat: isTerlambat,
                    denda: denda,
                    peminjamanId:
                        int.parse(selectedPeminjaman!['id'].toString()),
                  );

                  try {
                    await _pengembalianService
                        .createPengembalian(newPengembalian);
                    Navigator.pop(context);
                    _refreshPengembalianList();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Pengembalian berhasil disimpan')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Gagal menyimpan pengembalian')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(Pengembalian pengembalian) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengembalian'),
        content: const Text(
            'Apakah Anda yakin ingin menghapus data pengembalian ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _pengembalianService.deletePengembalian(pengembalian.id!);
                Navigator.pop(context);
                _refreshPengembalianList();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Pengembalian berhasil dihapus')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menghapus pengembalian')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
