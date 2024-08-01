import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/features/schedule/data/models/rb_product.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/user_scaffold.dart';
import '../providers/rb_collection_provider.dart';
import '../widgets/add_product_modal.dart';
import '../widgets/product_options_sheet.dart';
import '../widgets/search_product_modal.dart';

class AddProductsPage extends StatefulWidget {
  const AddProductsPage({super.key});

  @override
  State<AddProductsPage> createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  int selectedIndex = -1;
  final User user = User(
    userId: AppStrings.openFoodAPIClientUsername,
    password: AppStrings.openFoodAPIClientPassword,
    comment: 'recycla_bin_app',
  );

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RBCollectionProvider>(context, listen: false);
    provider.loadCollection(); // Load initial data if available
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RBCollectionProvider>(context);
    final products = provider.collection?.products ?? [];

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
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                color: Utils.hexToColor("#f3ffdc"),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: products.map((product) {
                  final imageUrl = product.imgUrl;
                  return GestureDetector(
                    onTap: () {
                      _showProductOptions(context, product);
                    },
                    child: Container(
                      width: (width) / 4, // Adjust the width based on spacing and padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.transparent,
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
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: imageUrl != null
                                ? Image.network(imageUrl)
                                : Icon(Icons.image, size: 50),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Text(
                                '${product.quantity}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
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

  void _showProductOptions(BuildContext context, RBProduct product) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ProductOptionsSheet(product: product);
      },
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
              Provider.of<RBCollectionProvider>(context, listen: false).addProduct(RBProduct(
                id: product.barcode,
                name: product.productName,
                quantity: 1,
                imgUrl: product.imageFrontSmallUrl,
                size: product.servingSize,
              ));
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
          onProductSelected: (product) async {
            setState(() {
              Provider.of<RBCollectionProvider>(context, listen: false).addProduct(RBProduct(
                id: product.barcode,
                name: product.productName,
                quantity: 1,
                imgUrl: product.imageFrontSmallUrl,
                size: product.servingSize,
              ));
            });
          },
        );
      },
    );
  }
}
