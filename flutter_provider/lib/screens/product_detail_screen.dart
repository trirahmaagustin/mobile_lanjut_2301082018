import 'package:flutter/material.dart';
import 'package:flutter_provider/providers/all_product.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil productId dari argument route
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    // Cari produk dengan productId tersebut
    final product = Provider.of<Products>(context).allProducts.firstWhere((prod) => prod.id == productId);

    // Deskripsi acak (sebagai contoh)
    final randomDescriptions = [
      'This product is made from the finest materials.',
      'A limited edition item you don\'t want to miss!',
      'An amazing addition to your collection!',
      'Highly recommended by experts in the industry.',
      'Best seller with outstanding reviews!',
      'Produk yang sangat bagus, produksi lokal dengan harga terjangkau',
      'Produk import kualitas bagus dengan harga terjangkau dan berbagai variasi, cocok digunakan untuk sehari-hari',
      'cocok digunakan oleh dewasa atau anak-anak, ramah lingkungan'

    ];

    // Pilih deskripsi acak
    final randomDescription = (randomDescriptions..shuffle()).first;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title), // Tampilkan judul produk di AppBar
      ),
      body: Column(
        children: [
          // Tampilkan gambar produk
          Container(
            width: double.infinity,
            height: 250,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 30,),
          // Tampilkan judul produk
          Text(
            product.title,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20,),
          // Tampilkan deskripsi acak
          Text(
            randomDescription,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20,),
          // Tampilkan harga produk
          Text(
            '\$${product.price.toString()}', // Format harga dengan simbol dolar
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}
