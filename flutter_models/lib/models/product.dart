import 'package:flutter/material.dart';

class Product {
  @required
  late String namaBarang;
  @required
  late String imageUrl;
  @required
  late String deskripsi;
  @required
  late int harga;

  Product(this.imageUrl, this.namaBarang, this.harga, this.deskripsi);
}