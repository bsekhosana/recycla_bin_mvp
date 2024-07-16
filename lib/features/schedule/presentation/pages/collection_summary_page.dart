import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_icon_button.dart';

import '../../../../core/widgets/user_scaffold.dart';
import '../../data/models/product.dart';

class CollectionSummaryPage extends StatefulWidget {
  const CollectionSummaryPage({super.key});

  @override
  State<CollectionSummaryPage> createState() => _CollectionSummaryPageState();
}

class _CollectionSummaryPageState extends State<CollectionSummaryPage> {
  List<Product> products = [
    Product(name: "Coke", size: "500ml", quantity: 10),
    Product(name: "Milk", size: "2L", quantity: 2),
    Product(name: "Coke", size: "2L", quantity: 10),
  ];

  int totalQuantity = 22;
  String date = "2021/05/18";
  String time = "13:00 PM - 14:00 PM";
  double cost = 47.45;

  void incrementQuantity(int index) {
    setState(() {
      products[index].quantity++;
      totalQuantity++;
    });
  }

  void decrementQuantity(int index) {
    if (products[index].quantity > 0) {
      setState(() {
        products[index].quantity--;
        totalQuantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UserScaffold(
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Utils.hexToColor(AppStrings.kRBLightPrimaryColor),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: products.map((product) {
                    int index = products.indexOf(product);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: width*0.14,
                                  child: Row(
                                    children: [
                                      Icon(Icons.circle, color: Utils.hexToColor(AppStrings.kRBSecondaryColor), size: 10),
                                      // SizedBox(width: width*0.015),
                                      Spacer(),
                                      Text(product.name, style: TextStyle(fontSize: width*0.04)),
                                    ],
                                  ),
                                ),

                                SizedBox(width: width*0.13),

                                // SizedBox(width: width*0.1),
                                Text(product.size, style: TextStyle(fontSize: width*0.04)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      color: Colors.orange
                                    ),
                                    child: Icon(Icons.remove,
                                        color: Colors.white,
                                    ),
                                ),
                                onPressed: () => decrementQuantity(index),
                              ),
                              Text(product.quantity.toString(),
                                  style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        color: Colors.green
                                    ),
                                    child: Icon(Icons.add,
                                        color: Colors.white,
                                    ),
                                ),
                                onPressed: () => incrementQuantity(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              buildInfoRow(Icons.production_quantity_limits, totalQuantity.toString(), "Quantity"),
              SizedBox(height: 20),
              buildInfoRow(Icons.calendar_today, "$date   $time", "Date + Time"),
              SizedBox(height: 20),
              buildInfoRow(Icons.attach_money, cost.toString(), "Cost"),
            ],
          ),

          SizedBox(
            height: height*0.045,
          ),

          CustomElevatedButton(
              text: 'Confirm Collect',
              onPressed: (){
                Navigator.pushNamed(context, 'collectiondetails');
              },
              primaryButton: true
          ),

          SizedBox(
            height: height*0.045,
          ),
        ],
      ),
      title: 'Summary',
      showMenu: false,
    );
  }

  Widget buildInfoRow(IconData icon, String text, String label) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: width*0.038, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
        SizedBox(height: height*0.015),
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Utils.hexToColor(AppStrings.kRBLightPrimaryColor),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              // Icon(icon, color: Colors.green),
              Container(
                  child: CustomIconButton(icon: icon, onPressed: (){}),
                width: width*0.07,
                height: height*0.035,
              ),
              SizedBox(width: 8),
              Text(text, style: TextStyle(fontSize: width*0.035, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
