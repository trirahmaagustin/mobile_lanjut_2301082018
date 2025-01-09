class Pengembalian {
  final int? id;
  final DateTime tanggalDikembalikan;
  final bool terlambat;
  final double denda;
  final int peminjamanId;
  // Fields tambahan untuk tampilan
  final String? namaPeminjam;
  final String? judulBuku;
  final DateTime? tanggalPinjam;
  final DateTime? tanggalHarusKembali;

  Pengembalian({
    this.id,
    required this.tanggalDikembalikan,
    required this.terlambat,
    required this.denda,
    required this.peminjamanId,
    this.namaPeminjam,
    this.judulBuku,
    this.tanggalPinjam,
    this.tanggalHarusKembali,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: int.parse(json['id'].toString()),
      tanggalDikembalikan: DateTime.parse(json['tanggal_dikembalikan']),
      terlambat: json['terlambat'] == '1' || json['terlambat'] == true,
      denda: double.parse(json['denda'].toString()),
      peminjamanId: int.parse(json['peminjaman_id'].toString()),
      namaPeminjam: json['nama_peminjam'],
      judulBuku: json['judul_buku'],
      tanggalPinjam: json['tanggal_pinjam'] != null 
          ? DateTime.parse(json['tanggal_pinjam'])
          : null,
      tanggalHarusKembali: json['tanggal_kembali'] != null 
          ? DateTime.parse(json['tanggal_kembali'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal_dikembalikan': tanggalDikembalikan.toIso8601String().split('T')[0],
      'terlambat': terlambat ? 1 : 0,
      'denda': denda,
      'peminjaman_id': peminjamanId,
    };
  }
} 