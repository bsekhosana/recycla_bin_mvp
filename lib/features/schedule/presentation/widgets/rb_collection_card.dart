import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/features/schedule/data/models/rb_product.dart';

import '../../../../core/utilities/utils.dart';
import '../../../../core/widgets/custom_icon_button.dart';
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
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Opacity(
                            opacity: 0.1,
                            child: Image.asset(
                              'assets/images/splash/logo.png', // Replace with your image URL
                              fit: BoxFit.cover,
                              width: width * 0.5,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: height * 0.2,
                        // color: Colors.white.withOpacity(0), // Transparent background
                        decoration: BoxDecoration(
                          border: Border.all(color: Utils.hexToColor(AppStrings.kRBPrimaryColor), width: 0.4),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${Utils.formatDateString(collection.date!)} ${collection.time}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width*0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                  SizedBox(
                    width: width * 0.1,
                    height: height * 0.05,
                    child: CustomIconButton(
                      icon: Icons.receipt_long_outlined,
                      onPressed: (){
                        Navigator.pushNamed(context, 'collectionsummary', arguments: collection);
                      },
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}
