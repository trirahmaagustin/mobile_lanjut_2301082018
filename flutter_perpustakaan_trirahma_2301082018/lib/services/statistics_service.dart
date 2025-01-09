import 'package:http/http.dart' as http;
import 'dart:convert';

class StatisticsService {
  static Future<Map<String, int>> getStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/flutter_perpustakaan_trirahma_2301082018/backend/statistics.php'),
      );

      if (response.statusCode == 200) {
        return Map<String, int>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load statistics');
      }
    } catch (e) {
      return {
        'anggota': 0,
        'buku': 0,
        'peminjaman': 0,
        'pengembalian': 0,
      };
    }
  }
}
