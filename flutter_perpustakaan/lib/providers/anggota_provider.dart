import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/anggota.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AnggotaProvider with ChangeNotifier {
  final List<Anggota> _allAnggota = [];
  final String baseUrl = kIsWeb
      ? 'http://localhost/perpustakaan/anggota.php'
      : 'http://localhost/perpustakaan/anggota.php';

  List<Anggota> get allAnggota => _allAnggota;

  int get jumlahAnggota => _allAnggota.length;

  Anggota selectById(String id) {
    return _allAnggota.firstWhere((element) => element.id == id);
  }

  Future<void> addAnggota(
      String nim, String nama, String? alamat, String jenisKelamin) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "nim": nim,
          "nama": nama,
          "alamat": alamat,
          "jenis_kelamin": jenisKelamin,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          final anggota = Anggota(
            id: responseData['data']['id'].toString(),
            nim: nim,
            nama: nama,
            alamat: alamat,
            jenisKelamin: jenisKelamin,
          );

          _allAnggota.add(anggota);
          notifyListeners();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal menambahkan anggota');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> editAnggota(
    String id,
    String nim,
    String nama,
    String? alamat,
    String jenisKelamin,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "nim": nim,
          "nama": nama,
          "alamat": alamat,
          "jenis_kelamin": jenisKelamin,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          final anggotaIndex =
              _allAnggota.indexWhere((element) => element.id == id);
          if (anggotaIndex >= 0) {
            _allAnggota[anggotaIndex] = Anggota(
              id: id,
              nim: nim,
              nama: nama,
              alamat: alamat,
              jenisKelamin: jenisKelamin,
            );
            notifyListeners();
          }
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal mengubah data anggota');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> deleteAnggota(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          _allAnggota.removeWhere((element) => element.id == id);
          notifyListeners();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal menghapus anggota');
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
          final List<Anggota> loadedAnggota = [];
          final anggotaList = responseData['data'] as List<dynamic>;

          for (var anggotaData in anggotaList) {
            loadedAnggota.add(Anggota.fromJson(anggotaData));
          }

          _allAnggota.clear();
          _allAnggota.addAll(loadedAnggota);
          notifyListeners();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal memuat data anggota');
      }
    } catch (err) {
      rethrow;
    }
  }

  // Method untuk mencari anggota berdasarkan nama atau NIM
  List<Anggota> searchAnggota(String keyword) {
    return _allAnggota.where((anggota) {
      return anggota.nama.toLowerCase().contains(keyword.toLowerCase()) ||
          anggota.nim.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }
}
