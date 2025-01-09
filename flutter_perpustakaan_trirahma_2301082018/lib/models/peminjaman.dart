class Peminjaman {
  final int? id;
  final DateTime tanggalPinjam;
  final DateTime tanggalKembali;
  final int anggotaId;
  final int bukuId;
  final String? namaPeminjam;  // untuk tampilan
  final String? judulBuku;     // untuk tampilan

  Peminjaman({
    this.id,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.anggotaId,
    required this.bukuId,
    this.namaPeminjam,
    this.judulBuku,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: int.parse(json['id'].toString()),
      tanggalPinjam: DateTime.parse(json['tanggal_pinjam']),
      tanggalKembali: DateTime.parse(json['tanggal_kembali']),
      anggotaId: int.parse(json['anggota_id'].toString()),
      bukuId: int.parse(json['buku_id'].toString()),
      namaPeminjam: json['nama_peminjam'],
      judulBuku: json['judul_buku'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal_pinjam': tanggalPinjam.toIso8601String().split('T')[0],
      'tanggal_kembali': tanggalKembali.toIso8601String().split('T')[0],
      'anggota_id': anggotaId,
      'buku_id': bukuId,
    };
  }
} 