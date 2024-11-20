
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/anggota.dart';

class Anggotas with ChangeNotifier {
  List<Anggota> _allAnggota = [];

  List<Anggota> get allAnggota => _allAnggota;

  // Pastikan properti atau getter ini ada
  List<Anggota> getAllAnggota() {
    return _allAnggota;
  }

  int get jumlahAnggota => _allAnggota.length;

  Anggota selectById(String id) {
    return _allAnggota.firstWhere((element) => element.id == id);
  }

 Future<void> fetchAnggota() async {
    final url = Uri.parse("http://localhost/pustaka_2018/anggota.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _allAnggota = data.map((item) => Anggota.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addAnggota(String nama, String kode, String nim, String jekel, String alamat) async {
    Uri url = Uri.parse("http://localhost/pustaka_2018/anggota.php");

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "nama": nama,
          "kode": kode,
          "nim": nim,
          "jekel": jekel,
          "alamat": alamat,
        }),
      );

      print("THEN FUNCTION");
      print(json.decode(response.body));

    if (response.statusCode == 200){
      final newAnggota = Anggota(
        id: json.decode(response.body)["id"],
        nama: nama,
        kode: kode,
        nim: nim,
        jekel: jekel,
        alamat: alamat,
      );

      _allAnggota.add(newAnggota);
      notifyListeners();
    }else {
      throw Exception("Gagal menambahkan data anggota!");
    } 
    } catch (err) {
      rethrow;
    }
  }

  void editAnggota(
    BuildContext context,
    String id,
    String nama,
    String kode,
    String nim,
    String jekel,
    String alamat,
  ) {
    Anggota selectPlayer =
        _allAnggota.firstWhere((element) => element.id == id);
    selectPlayer.nama = nama;
    selectPlayer.kode = kode;
    selectPlayer.nim = nim;
    selectPlayer.jekel = jekel;
    selectPlayer.alamat = alamat;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Berhasil diubah"),
        duration: Duration(seconds: 2),
      ),
    );
    notifyListeners();
  }

  void deletePlayer(String id, BuildContext context) {
    _allAnggota.removeWhere((element) => element.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Berhasil dihapus"),
        duration: Duration(milliseconds: 500),
      ),
    );
    notifyListeners();
  }

  Future<void> initializeData() async {
    Uri url = Uri.parse("http://localhost/flutter/Anggota.php/Anggota");
    try {
      var hasilGetData = await http.get(url);
      var dataResponse = json.decode(hasilGetData.body) as Map<String, dynamic>;

      // Create Anggota objects from the response data
      final List<Anggota> loadedAnggotas = [];
      dataResponse.forEach((key, value) {
        loadedAnggotas.add(
          Anggota(
            id: value['id'],
            nama: value['nama'],
            kode: value['kode'],
            nim: value['nim'],
            jekel: value['jekel'],
            alamat: value['alamat'],
          ),
        );
      });

      _allAnggota.clear();
      _allAnggota.addAll(loadedAnggotas);

      print("BERHASIL MEMUAT DATA LIST");
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
}
