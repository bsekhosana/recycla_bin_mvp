import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';

class AddProductModal extends StatefulWidget {
  final User user;
  final Function(Product) onProductAdded;

  AddProductModal({required this.user, required this.onProductAdded});

  @override
  _AddProductModalState createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final GlobalKey<FormState> _formModalKey = GlobalKey<FormState>();
  final _barcodeController = TextEditingController();
  final _productNameController = TextEditingController();
  final _brandController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formModalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _barcodeController,
                  decoration: InputDecoration(labelText: 'Barcode'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a barcode';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(labelText: 'Brand'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a brand';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomElevatedButton(
                  text: 'Add Product',
                  onPressed: _addProduct,
                  primaryButton: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addProduct() async {
    if (_formModalKey.currentState?.validate() ?? false) {
      try {
        Product product = Product(
          barcode: _barcodeController.text,
          productName: _productNameController.text,
          brands: _brandController.text,
          quantity: _quantityController.text,
        );

        Status status = await OpenFoodAPIClient.saveProduct(widget.user, product);

        if (status.status == 1) {
          widget.onProductAdded(product);
          Navigator.pop(context);
          showCustomSnackbar(context, 'Product added successfully', backgroundColor: Colors.green);
        } else {
          showCustomSnackbar(context, 'Failed to add product', backgroundColor: Colors.red);
        }
      } catch (error) {
        showCustomSnackbar(context, 'An error occurred while adding the product', backgroundColor: Colors.red);
      }
    }
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _productNameController.dispose();
    _brandController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
