import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pengembalian.dart';
import 'package:intl/intl.dart';

class PengembalianProvider with ChangeNotifier {
  final List<Pengembalian> _allPengembalian = [];
  final String baseUrl = kIsWeb
      ? 'http://localhost/perpustakaan/pengembalian.php'
      : 'http://localhost/perpustakaan/pengembalian.php';

  List<Pengembalian> get allPengembalian => _allPengembalian;

  Future<void> addPengembalian(Pengembalian pengembalian) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tanggal_dikembalikan':
              DateFormat('yyyy-MM-dd').format(pengembalian.tanggalDikembalikan),
          'terlambat': pengembalian.terlambat?.toString(),
          'denda': pengembalian.denda?.toString(),
          'peminjaman': pengembalian.peminjaman.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          final newPengembalian = Pengembalian(
            id: responseData['data']['id'].toString(),
            tanggalDikembalikan: pengembalian.tanggalDikembalikan,
            terlambat: pengembalian.terlambat,
            denda: pengembalian.denda,
            peminjaman: pengembalian.peminjaman,
          );
          _allPengembalian.add(newPengembalian);
          notifyListeners();
        } else {
          throw Exception(responseData['message'] ?? 'Gagal menambahkan pengembalian');
        }
      } else {
        throw Exception('Gagal menambahkan pengembalian: ${response.body}');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> initializeData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          final List<Pengembalian> loadedPengembalian = [];
          final pengembalianList = responseData['data'] as List<dynamic>;

          for (var pengembalianData in pengembalianList) {
            loadedPengembalian.add(Pengembalian.fromJson(pengembalianData));
          }

          _allPengembalian.clear();
          _allPengembalian.addAll(loadedPengembalian);
          notifyListeners();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal memuat data pengembalian');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editPengembalian(
    String id,
    DateTime tanggalDikembalikan,
    int terlambat,
    double denda,
    String peminjaman,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tanggal_dikembalikan':
              DateFormat('yyyy-MM-dd').format(tanggalDikembalikan),
          'terlambat': terlambat,
          'denda': denda,
          'peminjaman': peminjaman,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          final pengembalianIndex =
              _allPengembalian.indexWhere((element) => element.id == id);
          _allPengembalian[pengembalianIndex] = Pengembalian(
            id: id,
            tanggalDikembalikan: tanggalDikembalikan,
            terlambat: terlambat,
            denda: denda,
            peminjaman: int.parse(peminjaman),
          );
          notifyListeners();
                } else {
          throw Exception(responseData['peminjaman tidak boleh null']);
        }
      } else {
        throw Exception('Gagal mengubah data pengembalian');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deletePengembalian(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          _allPengembalian.removeWhere((element) => element.id == id);
          notifyListeners();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Gagal menghapus pengembalian');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Hitung keterlambatan dan denda
  Map<String, dynamic> hitungKeterlambatan(
      DateTime tanggalPinjam, DateTime tanggalKembali) {
    final selisihHari = tanggalKembali.difference(tanggalPinjam).inDays;
    final terlambat = selisihHari > 7 ? selisihHari - 7 : 0;
    final denda = terlambat * 1000.0; // Denda Rp 1.000 per hari

    return {
      'terlambat': terlambat,
      'denda': denda,
    };
  }
}
