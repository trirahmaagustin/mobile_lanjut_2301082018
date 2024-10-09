import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String kodePelanggan;
  final String namaPelanggan;
  final String tanggalMasuk;
  final int jamMasuk;
  final int jamKeluar;
  final String jenisPelanggan;

  const ResultScreen({
    Key? key,
    required this.kodePelanggan,
    required this.namaPelanggan,
    required this.tanggalMasuk,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.jenisPelanggan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int tarifPerJam = 10000;
    final int lama = jamKeluar - jamMasuk;

    double diskon = 0.0;
    if (jenisPelanggan == 'VIP' && lama > 2) {
      diskon = 0.02;
    } else if (jenisPelanggan == 'GOLD' && lama > 2) {
      diskon = 0.05;
    }

    final double totalTarif = lama * tarifPerJam.toDouble();
    final double totalDiskon = totalTarif * diskon;
    final double totalBayar = totalTarif - totalDiskon;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Perhitungan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Kode Pelanggan', kodePelanggan),
            _buildInfoRow('Nama Pelanggan', namaPelanggan),
            _buildInfoRow('Tanggal Masuk', tanggalMasuk),
            _buildInfoRow('Jenis Pelanggan', jenisPelanggan),
            _buildInfoRow('Lama Pemakaian', '$lama jam'),
            _buildInfoRow('Total Tarif', 'Rp ${totalTarif.toStringAsFixed(0)}'),
            _buildInfoRow('Diskon', 'Rp ${totalDiskon.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            _buildInfoRow('Total Bayar', 'Rp ${totalBayar.toStringAsFixed(0)}', isBold: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Kembali',
                style: TextStyle(color: Colors.white)
                ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
