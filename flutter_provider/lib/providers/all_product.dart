import 'package:flutter/material.dart';
import 'dart:math';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _allproducts = List.generate(
    26,
    (index) {
      return Product(
        id: "id_${index + 1}",
        title: "Product ${index + 1}",
        description: 'Ini adalah deskripsi produk ${index + 1}',
        price: 100000 + Random().nextInt(100000).toDouble(),
        imageUrl: 'https://picsum.photos/id/$index/200/300',
      );
    },
  );

  List<Product> get allProducts {
    return [..._allproducts];
  }
}