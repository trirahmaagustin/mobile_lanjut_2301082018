class Buku {
  final String id;
  final String judul;
  final String? pengarang;
  final String? penerbit;
  final String? tahunTerbit;

  Buku({
    required this.id,
    required this.judul,
    this.pengarang,
    this.penerbit,
    this.tahunTerbit,
  });

  // Mengubah JSON menjadi objek Buku
  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'].toString(),
      judul: json['judul'],
      pengarang: json['pengarang'],
      penerbit: json['penerbit'],
      tahunTerbit: json['tahun_terbit'],
    );
  }

  // Mengubah objek Buku menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'pengarang': pengarang,
      'penerbit': penerbit,
      'tahun_terbit': tahunTerbit,
    };
  }

  // Membuat salinan objek dengan beberapa field yang diubah
  Buku copyWith({
    String? id,
    String? judul,
    String? pengarang,
    String? penerbit,
    String? tahunTerbit,
  }) {
    return Buku(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      pengarang: pengarang ?? this.pengarang,
      penerbit: penerbit ?? this.penerbit,
      tahunTerbit: tahunTerbit ?? this.tahunTerbit,
    );
  }

  @override
  String toString() {
    return 'Buku{id: $id, judul: $judul, pengarang: $pengarang, penerbit: $penerbit, tahunTerbit: $tahunTerbit}';
  }

  // Validasi judul (maksimal 200 karakter)
  static bool isValidJudul(String value) {
    return value.length <= 200 && value.isNotEmpty;
  }

  // Validasi pengarang (maksimal 100 karakter)
  static bool isValidPengarang(String? value) {
    if (value == null) return true;
    return value.length <= 100;
  }

  // Validasi penerbit (maksimal 100 karakter)
  static bool isValidPenerbit(String? value) {
    if (value == null) return true;
    return value.length <= 100;
  }

  // Validasi tahun terbit (format: YYYY)
  static bool isValidTahunTerbit(String? value) {
    if (value == null) return true;
    if (value.length != 4) return false;
    
    try {
      int tahun = int.parse(value);
      return tahun >= 1900 && tahun <= DateTime.now().year;
    } catch (e) {
      return false;
    }
  }
}
