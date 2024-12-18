class Anggota {
  final String id;
  final String nim;
  final String nama;
  final String? alamat;
  final String jenisKelamin;

  Anggota({
    required this.id,
    required this.nim,
    required this.nama,
    this.alamat,
    required this.jenisKelamin,
  });

  // Mengubah JSON menjadi objek Anggota
  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'].toString(),
      nim: json['nim'],
      nama: json['nama'],
      alamat: json['alamat'],
      jenisKelamin: json['jenis_kelamin'],
    );
  }

  // Mengubah objek Anggota menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nim': nim,
      'nama': nama,
      'alamat': alamat,
      'jenis_kelamin': jenisKelamin,
    };
  }

  // Membuat salinan objek dengan beberapa field yang diubah
  Anggota copyWith({
    String? id,
    String? nim,
    String? nama,
    String? alamat,
    String? jenisKelamin,
  }) {
    return Anggota(
      id: id ?? this.id,
      nim: nim ?? this.nim,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
    );
  }

  @override
  String toString() {
    return 'Anggota{id: $id, nim: $nim, nama: $nama, alamat: $alamat, jenisKelamin: $jenisKelamin}';
  }

  // Validasi jenis kelamin
  static bool isValidJenisKelamin(String value) {
    return value == 'L' || value == 'P';
  }

  // Validasi NIM (contoh: harus 20 karakter)
  static bool isValidNim(String value) {
    return value.length <= 20 && value.isNotEmpty;
  }

  // Validasi nama (contoh: maksimal 100 karakter)
  static bool isValidNama(String value) {
    return value.length <= 100 && value.isNotEmpty;
  }
}
