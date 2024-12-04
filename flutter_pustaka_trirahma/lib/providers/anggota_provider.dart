import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/anggota.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AnggotaProvider with ChangeNotifier {
  final String _baseUrl = kIsWeb
      ? 'http://localhost/pustaka_2018/anggota.php'
      : 'http://10.0.2.2/pustaka_2018/anggota.php';
  List<Anggota> _anggotaList = [];
  bool _isLoading = false;

  List<Anggota> get anggotaList => _anggotaList;
  bool get isLoading => _isLoading;

  Future<bool> addAnggota(Anggota anggota) async {
    try {
      print('Attempting to connect to: $_baseUrl');
      print('Sending data: ${jsonEncode(anggota.toJson())}');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(anggota.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await fetchAnggota();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error saving anggota: $e');
      return false;
    }
  }

  Future<void> fetchAnggota() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _anggotaList = data.map((json) => Anggota.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching anggota: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateAnggota(Anggota anggota) async {
    try {
      print('Updating anggota with ID: ${anggota.id}');
      print('Sending data: ${jsonEncode(anggota.toJson())}');
      
      final response = await http.put(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id': anggota.id,
          'nim': anggota.nim,
          'nama': anggota.nama,
          'alamat': anggota.alamat,
          'jenis_kelamin': anggota.jenis_kelamin.name,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await fetchAnggota();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error updating anggota: $e');
      return false;
    }
  }

  Future<bool> deleteAnggota(int id) async {
    try {
      print('Deleting anggota with ID: $id');
      
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
          await fetchAnggota();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting anggota: $e');
      return false;
    }
  }
}
