class Anggota {
  String id;
  String nama;
  String kode;
  String nim;
  String jekel;
  String alamat;

  Anggota({
    required this.id,
    required this.nama,
    required this.kode,
    required this.nim,
    required this.jekel,
    required this.alamat,
  });

  //static fromJson(item) {}
  addAnggota(String text, String text2, String text3, String text4, String text5) {}

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'],
      nama: json['nama'],
      kode: json['kode'],
      nim: json['nim'],
      jekel: json['jekel'],
      alamat: json['alamat'], 
    );
  }
}
