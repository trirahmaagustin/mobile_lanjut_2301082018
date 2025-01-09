import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/buku.dart';
import '../models/anggota.dart';

class DataService {
  // Base URL API
  static const String baseUrl =
      'http://localhost/flutter_perpustakaan_trirahma_2301082018/backend';

  // Fungsi untuk mengambil data buku
  static Future<List<Buku>> getBuku() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/buku/read.php'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Buku.fromJson(data)).toList();
      } else {
        throw Exception('Gagal mengambil data buku');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Fungsi untuk mengambil data anggota
  static Future<List<Anggota>> getAnggota() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/anggota/read.php'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Anggota.fromJson(data)).toList();
      } else {
        throw Exception('Gagal mengambil data anggota');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
