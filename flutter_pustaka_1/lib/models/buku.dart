
class Buku {
  String id;
  String kode;
  String judul;
  String pengarang;
  String penerbit;
  String tahun_terbit;

  Buku({
    required this.id,
    required this.kode,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    required this.tahun_terbit,
  });

  addBuku(String text, String text2, String text3, String text4, String text5) {}

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'],
      kode: json['kode'],
      judul: json['judul'],
      pengarang: json['pengarang'],
      penerbit: json['penerbit'],
      tahun_terbit: json['tahun_terbit'],
    );
  }
}
