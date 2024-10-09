import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'hasil.dart'; // Import hasil.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hitung Biaya Warnet',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.orange, // Set your accent color here
        ),
        fontFamily: 'Arial',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0),
          labelLarge: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      home: const FormEntryScreen(),
    );
  }
}

class FormEntryScreen extends StatefulWidget {
  const FormEntryScreen({Key? key}) : super(key: key);

  @override
  _FormEntryScreenState createState() => _FormEntryScreenState();
}

class _FormEntryScreenState extends State<FormEntryScreen> {
  final TextEditingController _kodePelangganController = TextEditingController();
  final TextEditingController _namaPelangganController = TextEditingController();
  final TextEditingController _tanggalMasukController = TextEditingController();
  String? _jamMasuk; // Changed to String to hold formatted time
  String? _jamKeluar; // Changed to String to hold formatted time
  String? _jenisPelanggan;
  DateTime? selectedDate;

  @override
  void dispose() {
    _kodePelangganController.dispose();
    _namaPelangganController.dispose();
    _tanggalMasukController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _tanggalMasukController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isJamMasuk) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final formattedTime = '${picked.hour}:${picked.minute.toString().padLeft(2, '0')}';
        if (isJamMasuk) {
          _jamMasuk = formattedTime;
        } else {
          _jamKeluar = formattedTime;
        }
      });
    }
  }

  void _submitForm() {
    // Check all input validations and show error if necessary
    final jamMasukParts = _jamMasuk?.split(':');
    final jamKeluarParts = _jamKeluar?.split(':');
    final int? jamMasuk = jamMasukParts != null ? int.tryParse(jamMasukParts[0]) : null;
    final int? jamKeluar = jamKeluarParts != null ? int.tryParse(jamKeluarParts[0]) : null;

    if (jamMasuk == null || jamKeluar == null || _jenisPelanggan == null || 
        _kodePelangganController.text.isEmpty || _namaPelangganController.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan semua data yang diperlukan')),
      );
      return;
    }

    if (jamKeluar <= jamMasuk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jam keluar harus lebih besar dari jam masuk')),
      );
      return;
    }

    // Navigate to ResultScreen with the gathered data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          kodePelanggan: _kodePelangganController.text,
          namaPelanggan: _namaPelangganController.text,
          tanggalMasuk: _tanggalMasukController.text,
          jamMasuk: jamMasuk,
          jamKeluar: jamKeluar,
          jenisPelanggan: _jenisPelanggan!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Container(
          alignment: Alignment.center,
          child: const Text('Form Entry Biaya Warnet',
          textAlign: TextAlign.center,
          ),
        ),
        toolbarHeight: 60.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _kodePelangganController,
              decoration: const InputDecoration(labelText: 'Kode Pelanggan'),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _namaPelangganController,
              decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _tanggalMasukController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Tanggal Masuk',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => _selectTime(context, true),
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Jam Masuk'),
                child: Text(_jamMasuk ?? 'Pilih Jam Masuk', style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => _selectTime(context, false),
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Jam Keluar'),
                child: Text(_jamKeluar ?? 'Pilih Jam Keluar', style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Jenis Pelanggan'),
              value: _jenisPelanggan,
              onChanged: (newValue) {
                setState(() {
                  _jenisPelanggan = newValue;
                });
              },
              items: const [
                DropdownMenuItem(value: 'VIP', child: Text('VIP')),
                DropdownMenuItem(value: 'GOLD', child: Text('GOLD')),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text(
                'Hitung Tarif',
                style: TextStyle(color: Colors.white)
                ), // Updated text here
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: Colors.teal
              ),
            ),
          ],
        ),
      ),
    );
  }
}
