import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anggota.dart';

class AnggotaService {
  static const String baseUrl = 'http://localhost/flutter_perpustakaan_trirahma_2301082018/backend/anggota';
  // Gunakan IP yang sesuai dengan komputer Anda
  
  Future<List<Anggota>> getAnggota() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Anggota.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load anggota');
    }
  }

  Future<void> createAnggota(Anggota anggota) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create.php'),
      body: json.encode(anggota.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create anggota');
    }
  }

  Future<void> updateAnggota(int id, Anggota anggota) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update.php'),
      body: json.encode({'id': id, ...anggota.toJson()}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update anggota');
    }
  }

  Future<void> deleteAnggota(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete.php'),
      body: json.encode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete anggota');
    }
  }

  Future<List<Anggota>> getAnggotaForDropdown() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Anggota.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load anggota');
    }
  }
} 