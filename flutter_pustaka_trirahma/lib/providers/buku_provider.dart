import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/buku.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BukuProvider with ChangeNotifier {
  final String _baseUrl = kIsWeb
      ? 'http://localhost/pustaka_2018/buku.php'
      : 'http://10.0.2.2/pustaka_2018/buku.php';
  List<Buku> _bukuList = [];
  bool _isLoading = false;

  List<Buku> get bukuList => _bukuList;
  bool get isLoading => _isLoading;

  Future<bool> addBuku(Buku buku) async {
    try {
      print('Attempting to connect to: $_baseUrl');
      print('Sending data: ${jsonEncode(buku.toJson())}');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(buku.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await fetchBuku();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error saving buku: $e');
      return false;
    }
  }

  Future<void> fetchBuku() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _bukuList = data.map((json) => Buku.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching buku: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateBuku(Buku buku) async {
    try {
      _isLoading = true;
      notifyListeners();

      print('Updating buku with ID: ${buku.id}');
      print('Sending data: ${jsonEncode(buku.toJson())}');

      final response = await http.put(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id': buku.id,
          'judul': buku.judul,
          'pengarang': buku.pengarang,
          'penerbit': buku.penerbit,
          'tahun_terbit': buku.tahun_terbit,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await fetchBuku();
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Error updating buku: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBuku(int id) async {
    try {
      print('Deleting buku with ID: $id');

      final response = await http.delete(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'id': id}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await fetchBuku();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting buku: $e');
      return false;
    }
  }
}
