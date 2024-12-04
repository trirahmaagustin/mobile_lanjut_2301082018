class Buku {
  final int? id;
  final String judul;
  final String? pengarang;
  final String? penerbit;
  final String? tahun_terbit;

  Buku({
    this.id,
    required this.judul,
    this.pengarang,
    this.penerbit,
    this.tahun_terbit,
  });

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'pengarang': pengarang ?? '',
      'penerbit': penerbit ?? '',
      'tahun_terbit': tahun_terbit ?? '',
    };
  }

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      judul: json['judul'].toString(),
      pengarang: json['pengarang']?.toString() ?? '',
      penerbit: json['penerbit']?.toString() ?? '',
      tahun_terbit: json['tahun_terbit']?.toString() ?? '',
    );
  }
} 