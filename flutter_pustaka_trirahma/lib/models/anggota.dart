enum JenisKelamin {
  L,
  P;

  String toJson() => name;

  static JenisKelamin fromJson(String json) {
    return JenisKelamin.values.firstWhere(
      (e) => e.name == json,
      orElse: () => JenisKelamin.L,
    );
  }
}

class Anggota {
  final int? id;
  final String nim;
  final String nama;
  final String alamat;
  final JenisKelamin jenis_kelamin;

  Anggota({
    this.id,
    required this.nim,
    required this.nama,
    required this.alamat,
    required this.jenis_kelamin,
  });

  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'nama': nama,
      'alamat': alamat ?? '',
      'jenis_kelamin': jenis_kelamin.name,
    };
  }

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      nim: json['nim'].toString(),
      nama: json['nama'].toString(),
      alamat: json['alamat']?.toString() ?? '',
      jenis_kelamin: JenisKelamin.fromJson(json['jenis_kelamin'].toString()),
    );
  }
}
