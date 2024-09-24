import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:flutter_models/models/product.dart';

class HomePage extends StatelessWidget {
  Faker faker = new Faker();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> data = List.generate(
      100,
      (index) {
        return Product (
        'https://picsum.photos/id/$index/200/300',
        faker.food.restaurant(),
        10000 + Random().nextInt(10000),
        faker.lorem.sentence());
  });
    return Scaffold(
      appBar: AppBar(
        title: Text("Market Place"),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10 ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: GridTile(
              child: img.Image.network(data[index].imageUrl),
              footer: Container(
                color: Colors.blueAccent,
                child: Column(
                  children: [
                    Text(
                      data[index].namaBarang,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text("Rp. ${data[index].harga.toString()}"),
                    Text(
                      data[index].deskripsi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


