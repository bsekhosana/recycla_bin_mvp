import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/features/schedule/data/models/rb_product.dart';

import '../../../../core/utilities/utils.dart';
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
    final firstImage = collection.getFirstProductImage();
    // print('current collection: ${collection.products}');
    final List<Color> colors = [
      Colors.blue,
      Colors.pink,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.yellow,
    ];
    final random = Random();
    final backgroundColor = colors[random.nextInt(colors.length)];
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
                  child: Container(
                    width: double.infinity,
                    height: height*0.2,
                    color: Utils.hexToColor(AppStrings.kRBThirdColor),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Utils.formatDateString(collection.date!),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width*0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
