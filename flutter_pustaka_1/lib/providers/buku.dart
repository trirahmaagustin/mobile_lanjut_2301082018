import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/buku.dart';

class Bukus with ChangeNotifier {
  List<Buku> _allBuku = [];

  List<Buku> get allBuku => _allBuku;

  int get jumlahBuku => _allBuku.length;

  Buku selectById(String id) {
    return _allBuku.firstWhere((element) => element.id == id);
  }

   Future<void> fetchBuku() async {
    final url = Uri.parse("http://localhost/pustaka_2018/buku.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _allBuku = data.map((item) => Buku.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addBuku(
    String kode,
    String judul,
    String pengarang,
    String penerbit,
    String tahunTerbit,
  ) async {
    Uri url = Uri.parse("http://localhost/pustaka_2018/buku.php");

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "kode": kode,
          "judul": judul,
          "pengarang": pengarang,
          "penerbit": penerbit,
          "tahun_terbit": tahunTerbit,
        }),
      );

      if (response.statusCode == 200) {
        final newBuku = Buku(
          id: json.decode(response.body)["id"],
          kode: kode,
          judul: judul,
          pengarang: pengarang,
          penerbit: penerbit,
          tahun_terbit: tahunTerbit,
        );

        _allBuku.add(newBuku);
        notifyListeners();
      } else {
        throw Exception("Gagal menambahkan data buku!");
      }
    } catch (err) {
      rethrow;
    }
  }

  void editBuku(
    BuildContext context,
    String id,
    String kode,
    String judul,
    String pengarang,
    String penerbit,
    String tahunTerbit,
  ) {
    try {
      Buku selectedBuku = _allBuku.firstWhere((element) => element.id == id);
      selectedBuku.kode = kode;
      selectedBuku.judul = judul;
      selectedBuku.pengarang = pengarang;
      selectedBuku.penerbit = penerbit;
      selectedBuku.tahun_terbit = tahunTerbit;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil diubah"),
          duration: Duration(seconds: 2),
        ),
      );
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mengedit data buku"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void deletePlayer(BuildContext context, String id) {
    try {
      _allBuku.removeWhere((element) => element.id == id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil dihapus"),
          duration: Duration(milliseconds: 500),
        ),
      );
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menghapus data buku"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> initializeData() async {
    Uri url = Uri.parse("http://localhost/flutter/Buku.php/Buku");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var dataResponse = json.decode(response.body) as List<dynamic>;

        final List<Buku> loadedBukus = dataResponse
            .map((item) => Buku(
                  id: item['id'],
                  kode: item['kode'],
                  judul: item['judul'],
                  pengarang: item['pengarang'],
                  penerbit: item['penerbit'],
                  tahun_terbit: item['tahun_terbit'],
                ))
            .toList();

        _allBuku.clear();
        _allBuku.addAll(loadedBukus);

        notifyListeners();
      } else {
        throw Exception("Gagal memuat data buku!");
      }
    } catch (err) {
      rethrow;
    }
  }
}
