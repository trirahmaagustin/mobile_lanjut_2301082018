import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/peminjaman.dart';

class PeminjamanService {
  static const String baseUrl = 'http://localhost/flutter_perpustakaan_trirahma_2301082018/backend/peminjaman';
  
  Future<List<Peminjaman>> getPeminjaman() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Peminjaman.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load peminjaman');
    }
  }

  Future<void> createPeminjaman(Peminjaman peminjaman) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create.php'),
      body: json.encode(peminjaman.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create peminjaman');
    }
  }

  Future<void> updatePeminjaman(int id, Peminjaman peminjaman) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update.php'),
      body: json.encode({'id': id, ...peminjaman.toJson()}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update peminjaman');
    }
  }

  Future<void> deletePeminjaman(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete.php'),
      body: json.encode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete peminjaman');
    }
  }
} 