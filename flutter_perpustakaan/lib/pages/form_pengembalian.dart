import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pengembalian_provider.dart';
import '../models/pengembalian.dart';
import '../models/peminjaman.dart';
import 'package:intl/intl.dart';

class FormPengembalian extends StatefulWidget {
  final Pengembalian? pengembalian;
  const FormPengembalian({super.key, this.pengembalian});

  @override
  State<FormPengembalian> createState() => _FormPengembalianState();
}

class _FormPengembalianState extends State<FormPengembalian> {
  late Peminjaman peminjaman;
  final _formKey = GlobalKey<FormState>();
  DateTime _tanggalKembali = DateTime.now();
  int? _terlambat;
  double? _denda;
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Peminjaman) {
        peminjaman = args;
        _hitungKeterlambatan();
        _isInit = true;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      }
    }
  }

  void _hitungKeterlambatan() {
    final pengembalianProvider =
        Provider.of<PengembalianProvider>(context, listen: false);
    final hasil = pengembalianProvider.hitungKeterlambatan(
      peminjaman.tanggalPinjam,
      _tanggalKembali,
    );
    setState(() {
      _terlambat = hasil['terlambat'];
      _denda = hasil['denda'];
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalKembali,
      firstDate: peminjaman.tanggalPinjam,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tanggalKembali = picked;
        _hitungKeterlambatan();
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final pengembalianProvider =
            Provider.of<PengembalianProvider>(context, listen: false);
            
        final newPengembalian = Pengembalian(
          id: '0',
          tanggalDikembalikan: _tanggalKembali,
          terlambat: _terlambat,
          denda: _denda,
          peminjaman: int.parse(peminjaman.id),
        );

        await pengembalianProvider.addPengembalian(newPengembalian);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil menambah pengembalian')),
          );
        }
      } catch (error) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Error'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Pengembalian',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA47458),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text('Tanggal Kembali'),
                      subtitle: Text(
                          DateFormat('yyyy-MM-dd').format(_tanggalKembali)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Keterlambatan: ${_terlambat ?? 0} hari'),
                            const SizedBox(height: 8),
                            Text(
                                'Denda: Rp ${(_denda ?? 0).toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA47458),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _saveForm,
                        child: const Text(
                          'Simpan',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
