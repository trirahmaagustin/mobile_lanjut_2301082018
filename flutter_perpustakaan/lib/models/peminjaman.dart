class Peminjaman {
  final String id;
  final DateTime tanggalPinjam;
  final DateTime? tanggalKembali;
  final int anggota;
  final int buku;

  Peminjaman({
    required this.id,
    required this.tanggalPinjam,
    this.tanggalKembali,
    required this.anggota,
    required this.buku,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal_pinjam': tanggalPinjam.toIso8601String(),
      'tanggal_kembali': tanggalKembali?.toIso8601String(),
      'anggota': anggota,
      'buku': buku,
    };
  }

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: json['id'].toString(),
      tanggalPinjam: DateTime.parse(json['tanggal_pinjam']),
      tanggalKembali: json['tanggal_kembali'] != null
          ? DateTime.parse(json['tanggal_kembali'])
          : null,
      anggota: int.parse(json['anggota'].toString()),
      buku: int.parse(json['buku'].toString()),
    );
  }
}
