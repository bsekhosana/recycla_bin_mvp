import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rb_collection_provider.dart';
import 'package:recycla_bin/features/schedule/data/models/rb_product.dart';

class ProductOptionsSheet extends StatefulWidget {
  final RBProduct product;
  final int quantity;

  ProductOptionsSheet({required this.product, required this.quantity});

  @override
  _ProductOptionsSheetState createState() => _ProductOptionsSheetState();
}

class _ProductOptionsSheetState extends State<ProductOptionsSheet> {
  late RBProduct product;
  late int quantity;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    quantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RBCollectionProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: product.imgUrl != null
                ? Image.network(product.imgUrl!, height: 100)
                : Icon(Icons.image, size: 100),
          ),
          SizedBox(height: 16.0),
          Text(
            product.name ?? 'Unknown Product',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 8.0),
          Text(
            'Quantity: $quantity',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (quantity > 1)
                ElevatedButton(
                  onPressed: () {
                    provider.decrementProductCount(product);
                    setState(() {
                      quantity--;
                    });
                    if (quantity == 0) {
                      provider.removeProduct(product);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Decrement'),
                ),
              ElevatedButton(
                onPressed: () {
                  provider.incrementProductCount(product);
                  setState(() {
                    quantity++;
                  });
                },
                child: Text('Increment'),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.removeProduct(product);
                  Navigator.pop(context);
                },
                child: Text('Remove'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
