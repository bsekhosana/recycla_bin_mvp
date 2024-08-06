import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_icon_button.dart';
import '../../../../core/widgets/user_scaffold.dart';
import '../../data/models/rb_collection.dart';
import '../../data/models/rb_product.dart';

class CollectionSummaryPage extends StatefulWidget {
  const CollectionSummaryPage({super.key});

  @override
  State<CollectionSummaryPage> createState() => _CollectionSummaryPageState();
}

class _CollectionSummaryPageState extends State<CollectionSummaryPage> {
  List<RBProduct> products = [];
  int totalQuantity = 0;
  String date = "2021/05/18";
  String time = "13:00 PM - 14:00 PM";
  double cost = 47.45;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RBCollection? collection = ModalRoute.of(context)!.settings.arguments as RBCollection?;
      if (collection != null) {
        setState(() {
          products = List.from(collection.products ?? []);
          totalQuantity = collection.getTotalQuantity();
        });
      }
    });
  }

  void incrementQuantity(int index) {
    setState(() {
      products[index].quantity = (products[index].quantity ?? 0) + 1;
      totalQuantity += 1;
    });
  }

  void decrementQuantity(int index) {
    if (products[index].quantity != null && products[index].quantity! > 0) {
      setState(() {
        products[index].quantity = (products[index].quantity ?? 0) - 1;
        totalQuantity -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final RBCollection? collection = ModalRoute.of(context)!.settings.arguments as RBCollection?;

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
                              children: [
                                Icon(Icons.circle, color: Utils.hexToColor(AppStrings.kRBSecondaryColor), size: 10),
                                SizedBox(width: width * 0.03),
                                Expanded(
                                  child: Text(product.name!, style: TextStyle(fontSize: width * 0.04)),
                                ),
                                SizedBox(width: width * 0.03),
                                Text(product.size ?? 'N/A', style: TextStyle(fontSize: width * 0.04)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    color: Colors.orange,
                                  ),
                                  child: Icon(Icons.remove, color: Colors.white),
                                ),
                                onPressed: () => decrementQuantity(index),
                              ),
                              Text(product.quantity.toString(), style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    color: Colors.green,
                                  ),
                                  child: Icon(Icons.add, color: Colors.white),
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
              buildInfoRow(Icons.location_on_outlined, collection!.address!, "Location"),
              SizedBox(height: 20),
              buildInfoRow(Icons.production_quantity_limits, totalQuantity.toString(), "Quantity"),
              SizedBox(height: 20),
              buildInfoRow(Icons.calendar_today, "${Utils.formatDateString(collection!.date!, dateOnly: true)}   ${collection.time}", "Date + Time"),
              SizedBox(height: 20),
              buildInfoRow(Icons.attach_money, cost.toString(), "Cost"),
            ],
          ),
          SizedBox(height: height * 0.045),
          CustomElevatedButton(
            text: 'Confirm Collect',
            onPressed: () {
              Navigator.pushNamed(context, 'collectiondetails', arguments: collection);
            },
            primaryButton: true,
          ),
          SizedBox(height: height * 0.045),
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
        Text(label, style: TextStyle(fontSize: width * 0.038, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
        SizedBox(height: height * 0.015),
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Utils.hexToColor(AppStrings.kRBLightPrimaryColor),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              Container(
                child: CustomIconButton(icon: icon, onPressed: () {}),
                width: width * 0.07,
                height: height * 0.035,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(text, style: TextStyle(fontSize: width * 0.035, color: Colors.grey)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
