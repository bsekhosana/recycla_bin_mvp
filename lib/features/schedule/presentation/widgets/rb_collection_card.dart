import 'package:flutter/material.dart';
import 'package:recycla_bin/features/schedule/data/models/rb_product.dart';

import '../../data/models/rb_collection.dart';

class RBCollectionCard extends StatelessWidget {
  final RBCollection collection;

  RBCollectionCard({required this.collection});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final numberOfProducts = collection.getNumberOfProducts();
    final totalQuantity = collection.getTotalQuantity();
    print('current collection: ${collection.products}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.network(
                    'https://via.placeholder.com/400', // Replace with your image URL
                    height: height * 0.2,
                    width: width * 0.75,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  collection.address ?? 'No Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  numberOfProducts == 0
                      ? ''
                      : '$numberOfProducts Products, Quantity($totalQuantity)',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
