import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/peminjaman.dart';
import '../models/anggota.dart';
import '../models/buku.dart';
import '../services/peminjaman_service.dart';
import '../services/anggota_service.dart';
import '../services/buku_service.dart';

class PeminjamanScreen extends StatefulWidget {
  const PeminjamanScreen({super.key});

  @override
  _PeminjamanScreenState createState() => _PeminjamanScreenState();
}

class _PeminjamanScreenState extends State<PeminjamanScreen> {
  final PeminjamanService _peminjamanService = PeminjamanService();
  final AnggotaService _anggotaService = AnggotaService();
  final BukuService _bukuService = BukuService();
  late Future<List<Peminjaman>> _peminjamanList;
  List<Anggota> _anggotaList = [];
  List<Buku> _bukuList = [];

  @override
  void initState() {
    super.initState();
    _refreshPeminjamanList();
    _loadAnggotaAndBuku();
  }

  void _refreshPeminjamanList() {
    setState(() {
      _peminjamanList = _peminjamanService.getPeminjaman();
    });
  }

  Future<void> _loadAnggotaAndBuku() async {
    try {
      final anggotaList = await _anggotaService.getAnggotaForDropdown();
      final bukuList = await _bukuService.getBukuForDropdown();
      setState(() {
        _anggotaList = anggotaList;
        _bukuList = bukuList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data anggota dan buku')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Peminjaman'),
      ),
      body: FutureBuilder<List<Peminjaman>>(
        future: _peminjamanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data peminjaman'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var peminjaman = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text('${peminjaman.namaPeminjam} - ${peminjaman.judulBuku}'),
                  subtitle: Text(
                    'Pinjam: ${DateFormat('dd/MM/yyyy').format(peminjaman.tanggalPinjam)}\n'
                    'Kembali: ${DateFormat('dd/MM/yyyy').format(peminjaman.tanggalKembali)}'
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showFormDialog(peminjaman),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(peminjaman),
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
        onPressed: () => _showFormDialog(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFormDialog(Peminjaman? peminjaman) {
    final formKey = GlobalKey<FormState>();
    DateTime selectedTanggalPinjam = peminjaman?.tanggalPinjam ?? DateTime.now();
    DateTime selectedTanggalKembali = peminjaman?.tanggalKembali ?? 
        DateTime.now().add(const Duration(days: 7));
    int? selectedAnggotaId = peminjaman?.anggotaId;
    int? selectedBukuId = peminjaman?.bukuId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(peminjaman == null ? 'Tambah Peminjaman' : 'Edit Peminjaman'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedAnggotaId,
                  decoration: const InputDecoration(labelText: 'Anggota'),
                  items: _anggotaList.map((anggota) {
                    return DropdownMenuItem(
                      value: anggota.id,
                      child: Text('${anggota.nim} - ${anggota.nama}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedAnggotaId = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih anggota';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  value: selectedBukuId,
                  decoration: const InputDecoration(labelText: 'Buku'),
                  items: _bukuList.map((buku) {
                    return DropdownMenuItem(
                      value: buku.id,
                      child: Text(buku.judul),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedBukuId = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih buku';
                    }
                    return null;
                  },
                ),
                ListTile(
                  title: const Text('Tanggal Pinjam'),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy').format(selectedTanggalPinjam)
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedTanggalPinjam,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      selectedTanggalPinjam = picked;
                    }
                  },
                ),
                ListTile(
                  title: const Text('Tanggal Kembali'),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy').format(selectedTanggalKembali)
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedTanggalKembali,
                      firstDate: selectedTanggalPinjam,
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      selectedTanggalKembali = picked;
                    }
                  },
                ),
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
                  selectedAnggotaId != null &&
                  selectedBukuId != null) {
                final newPeminjaman = Peminjaman(
                  tanggalPinjam: selectedTanggalPinjam,
                  tanggalKembali: selectedTanggalKembali,
                  anggotaId: selectedAnggotaId!,
                  bukuId: selectedBukuId!,
                );

                try {
                  if (peminjaman == null) {
                    await _peminjamanService.createPeminjaman(newPeminjaman);
                  } else {
                    await _peminjamanService.updatePeminjaman(
                      peminjaman.id!,
                      newPeminjaman,
                    );
                  }
                  Navigator.pop(context);
                  _refreshPeminjamanList();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        peminjaman == null
                            ? 'Peminjaman berhasil ditambahkan'
                            : 'Peminjaman berhasil diupdate',
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menyimpan data')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Peminjaman peminjaman) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Peminjaman'),
        content: Text(
          'Apakah Anda yakin ingin menghapus peminjaman ${peminjaman.judulBuku} '
          'oleh ${peminjaman.namaPeminjam}?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _peminjamanService.deletePeminjaman(peminjaman.id!);
                Navigator.pop(context);
                _refreshPeminjamanList();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Peminjaman berhasil dihapus')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menghapus peminjaman')),
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