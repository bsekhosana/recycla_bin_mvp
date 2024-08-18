import 'package:recycla_bin/features/schedule/data/models/rb_product.dart';

import '../../../../core/services/firestore_repository_service.dart';

class RBProductRepository{

  final FirestoreRepository _productFirestore = FirestoreRepository(collectionPath: 'products');

  Future<RBProduct?> getProductById(String id) async {
    try{
      return await _productFirestore.readDocument(id, (data) => RBProduct.fromJson(data));
    }catch (e) {
      throw 'Failed to get product with id: $id and error: ${e.toString()}';
    }
  }

  Future<void> saveProduct(RBProduct product) async {
    try {
      print('adding product: ${product.toJson()}');
      await  _productFirestore.createDocument(product.id!, product.toJson());
    } catch (e) {
      print('Failed to save product to Firestore with error: ${e.toString()}');
      throw 'Failed to save product to Firestore with error: ${e.toString()}';
    }
  }
}