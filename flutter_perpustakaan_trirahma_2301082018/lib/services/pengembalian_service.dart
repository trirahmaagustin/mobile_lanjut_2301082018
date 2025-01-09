import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pengembalian.dart';

class PengembalianService {
  static const String baseUrl = 'http://localhost/flutter_perpustakaan_trirahma_2301082018/backend/pengembalian';
  
  Future<List<Pengembalian>> getPengembalian() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Pengembalian.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load pengembalian');
    }
  }

  Future<void> createPengembalian(Pengembalian pengembalian) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create.php'),
      body: json.encode(pengembalian.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create pengembalian');
    }
  }

  Future<void> updatePengembalian(int id, Pengembalian pengembalian) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update.php'),
      body: json.encode({'id': id, ...pengembalian.toJson()}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pengembalian');
    }
  }

  Future<void> deletePengembalian(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete.php'),
      body: json.encode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete pengembalian');
    }
  }

  // Method tambahan untuk mendapatkan peminjaman yang belum dikembalikan
  Future<List<Map<String, dynamic>>> getActivePeminjaman() async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_active_peminjaman.php')
    );
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonResponse);
    } else {
      throw Exception('Failed to load active peminjaman');
    }
  }
} 