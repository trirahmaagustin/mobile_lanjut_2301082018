import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/buku.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BukuProvider with ChangeNotifier {
  final List<Buku> _allBuku = [];
  final String baseUrl = kIsWeb
      ? 'http://localhost/perpustakaan/buku.php'
      : 'http://localhost/perpustakaan/buku.php';

  List<Buku> get allBuku => _allBuku;

  int get jumlahBuku => _allBuku.length;

  Buku selectById(String id) {
    return _allBuku.firstWhere((element) => element.id == id);
  }

  Future<void> addBuku(String judul, String? pengarang, String? penerbit,
      String? tahunTerbit) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "judul": judul,
          "pengarang": pengarang,
          "penerbit": penerbit,
          "tahun_terbit": tahunTerbit,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          final buku = Buku(
            id: responseData['data']['id'].toString(),
            judul: judul,
            pengarang: pengarang,
            penerbit: penerbit,
            tahunTerbit: tahunTerbit,
          );

          _allBuku.add(buku);
          notifyListeners();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal menambahkan buku');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> editBuku(
    String id,
    String judul,
    String? pengarang,
    String? penerbit,
    String? tahunTerbit,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "judul": judul,
          "pengarang": pengarang,
          "penerbit": penerbit,
          "tahun_terbit": tahunTerbit,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          final bukuIndex = _allBuku.indexWhere((element) => element.id == id);
          if (bukuIndex >= 0) {
            _allBuku[bukuIndex] = Buku(
              id: id,
              judul: judul,
              pengarang: pengarang,
              penerbit: penerbit,
              tahunTerbit: tahunTerbit,
            );
            notifyListeners();
          }
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal mengubah data buku');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> deleteBuku(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          _allBuku.removeWhere((element) => element.id == id);
          notifyListeners();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal menghapus buku');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> initializeData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          final List<Buku> loadedBuku = [];
          final bukuList = responseData['data'] as List<dynamic>;

          for (var bukuData in bukuList) {
            loadedBuku.add(Buku.fromJson(bukuData));
          }

          _allBuku.clear();
          _allBuku.addAll(loadedBuku);
          notifyListeners();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal memuat data buku');
      }
    } catch (err) {
      rethrow;
    }
  }

  // Method untuk mencari buku berdasarkan judul atau pengarang
  List<Buku> searchBuku(String keyword) {
    return _allBuku.where((buku) {
      return buku.judul.toLowerCase().contains(keyword.toLowerCase()) ||
          (buku.pengarang?.toLowerCase().contains(keyword.toLowerCase()) ??
              false);
    }).toList();
  }
}
