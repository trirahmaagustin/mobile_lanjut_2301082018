class Pengembalian {
  final String id;
  final DateTime tanggalDikembalikan;
  final int? terlambat;
  final double? denda;
  final int peminjaman;

  Pengembalian({
    required this.id,
    required this.tanggalDikembalikan,
    this.terlambat,
    this.denda,
    required this.peminjaman,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal_dikembalikan': tanggalDikembalikan.toIso8601String(),
      'terlambat': terlambat,
      'denda': denda,
      'peminjaman': peminjaman,
    };
  }

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: json['id'].toString(),
      tanggalDikembalikan: DateTime.parse(json['tanggal_dikembalikan']),
      terlambat: json['terlambat'] != null ? int.parse(json['terlambat'].toString()) : null,
      denda: json['denda'] != null ? double.parse(json['denda'].toString()) : null,
      peminjaman: int.parse(json['peminjaman'].toString()),
    );
  }
} 