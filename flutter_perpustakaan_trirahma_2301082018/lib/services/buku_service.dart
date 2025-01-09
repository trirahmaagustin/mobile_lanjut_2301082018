import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buku.dart';

class BukuService {
  static const String baseUrl = 'http://localhost/flutter_perpustakaan_trirahma_2301082018/backend/buku';
  
  Future<List<Buku>> getBuku() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Buku.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load buku');
    }
  }

  Future<void> createBuku(Buku buku) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create.php'),
      body: json.encode(buku.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create buku');
    }
  }

  Future<void> updateBuku(int id, Buku buku) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update.php'),
      body: json.encode({'id': id, ...buku.toJson()}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update buku');
    }
  }

  Future<void> deleteBuku(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete.php'),
      body: json.encode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete buku');
    }
  }

  Future<List<Buku>> getBukuForDropdown() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Buku.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load buku');
    }
  }
} 