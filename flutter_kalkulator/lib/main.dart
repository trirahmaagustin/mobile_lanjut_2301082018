import 'package:flutter/material.dart';

void main() {
  runApp(const MyCalculatorApp());
}

class MyCalculatorApp extends StatelessWidget {
  const MyCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  double _result = 0;
  String _selectedOperation = '';

  void _calculateResult() {
    final double num1 = double.tryParse(_controller1.text) ?? 0;
    final double num2 = double.tryParse(_controller2.text) ?? 0;

    setState(() {
      switch (_selectedOperation) {
        case 'Tambah':
          _result = num1 + num2;
          break;
        case 'Kurang':
          _result = num1 - num2;
          break;
        case 'Kali':
          _result = num1 * num2;
          break;
        case 'Bagi':
          _result = num1 / num2;
          break;
        default:
          _result = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Sederhana'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Angka Pertama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Angka Kedua',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 40,
                crossAxisSpacing: 40,
                childAspectRatio: 2, // Set rasio aspek lingkaran
                children: [
                  _buildOperationButton('Tambah', Colors.green),
                  _buildOperationButton('Kurang', Colors.red),
                  _buildOperationButton('Kali', Colors.blue),
                  _buildOperationButton('Bagi', Colors.orange),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _calculateResult,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              ),
              child: const Text('Hasil', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            Text(
              'Hasil: $_result',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationButton(String operation, Color color) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 1.5, // Mengatur ukuran lingkaran
      child: IconButton(
        onPressed: () {
          setState(() {
            _selectedOperation = operation;
          });
        },
        icon: Text(
          operation,
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
