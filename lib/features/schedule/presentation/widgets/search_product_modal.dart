import 'dart:async';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';
import 'dart:convert';

import '../../providers/rb_collection_provider.dart';

class SearchProductModal extends StatefulWidget {
  final User user;
  final Function(Product) onProductSelected;

  SearchProductModal({required this.user, required this.onProductSelected});

  @override
  _SearchProductModalState createState() => _SearchProductModalState();
}

class _SearchProductModalState extends State<SearchProductModal> {
  final _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isLoading = false;
  Timer? _searchDelayTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchDelayTimer?.cancel();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (_searchDelayTimer?.isActive ?? false) _searchDelayTimer?.cancel();
    if(_searchController.text.length > 3) _searchDelayTimer = Timer(Duration(seconds: 2), _searchProduct);
  }

  void _searchProduct() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<RBCollectionProvider>(context, listen: false);
      final existingProductIds = provider.collection?.products?.map((p) => p.id).toSet() ?? {};

      ProductSearchQueryConfiguration configuration = ProductSearchQueryConfiguration(
        parametersList: [SearchTerms(terms: _searchController.text.split(' '))],
        fields: [ProductField.ALL],
        version: ProductQueryVersion.v3,
      );

      SearchResult result = await OpenFoodAPIClient.searchProducts(widget.user, configuration);

      // Log the result
      print('search results: ${jsonEncode(result)}');

      setState(() {
        _isLoading = false;
        // Filter out products that have a null servingSize and those that already exist in the collection
        _searchResults = result.products
            ?.where((product) => product.servingSize != null && !existingProductIds.contains(product.barcode))
            .toList() ?? [];
      });

      print('search product ended...');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('search product failed with error: ${error.toString()}');
      showCustomSnackbar(context, 'An error occurred while searching for the product', backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Product',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchProduct,
                  ),
                ),
                onSubmitted: (value) => _searchProduct(),
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final product = _searchResults[index];
                  final imageUrl = product.imageFrontSmallUrl;
                  final productName = product.productName ?? 'Unknown';
                  final productBarCode = product.barcode ?? 'Unknown BarCode';
                  final productBrand = product.brands ?? 'Unknown Brand';
                  final productSize = product.servingSize ?? 'Unknown Size';
                  return ListTile(
                    leading: imageUrl != null
                        ? Image.network(imageUrl)
                        : Icon(Icons.image),
                    title: Text(
                      "$productName - $productBarCode",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("$productBrand ($productSize)"),
                    onTap: () {
                      print('list tile on tapped product:$imageUrl');
                      widget.onProductSelected(product);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
