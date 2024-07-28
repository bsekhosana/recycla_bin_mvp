import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/user_scaffold.dart';
import '../providers/rb_collection_provider.dart';
import '../widgets/add_product_modal.dart';
import '../widgets/search_product_modal.dart';

class AddProductsPage extends StatefulWidget {
  const AddProductsPage({super.key});

  @override
  State<AddProductsPage> createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  int selectedIndex = -1;
  List<Product> products = [];

  final User user = User(
    userId: AppStrings.openFoodAPIClientUsername,
    password: AppStrings.openFoodAPIClientPassword,
    comment: 'recycla_bin_app',
  );

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<RBCollectionProvider>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UserScaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * 0.013,
          ),
          if (products.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Utils.hexToColor("#f3ffdc"),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              height: height * 0.25,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final imageUrl = product.imageFrontSmallUrl;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedIndex == index ? Colors.green : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: imageUrl != null
                              ? Image.network(imageUrl)
                              : Icon(Icons.image, size: 50),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          SizedBox(
            height: height * 0.13,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomElevatedButton(
                text: 'Search Product',
                onPressed: () async {
                  _showSearchProductModal();
                },
                primaryButton: false,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * 0.04,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomElevatedButton(
                text: 'Scan Product',
                onPressed: () async {
                  final scanResult = await Navigator.pushNamed(context, 'scanpage');
                  if (scanResult != null) {
                    // Handle the scanned product
                    print('found product');
                    print(scanResult);
                  }
                },
                primaryButton: true,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * 0.04,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomElevatedButton(
                text: 'Add Product',
                onPressed: () {
                  _showAddProductModal();
                },
                primaryButton: false,
              ),
            ],
          )
        ],
      ),
      title: 'Products',
      showMenu: false,
    );
  }

  void _showAddProductModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddProductModal(
          user: user,
          onProductAdded: (product) {
            setState(() {
              products.add(product);
            });
          },
        );
      },
    );
  }

  void _showSearchProductModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SearchProductModal(
          user: user,
          onProductSelected: (product) {
            setState(() {
              products.add(product);
            });
          },
        );
      },
    );
  }
}
