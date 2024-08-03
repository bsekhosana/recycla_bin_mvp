import 'package:flutter/material.dart';
import 'package:recycla_bin/features/schedule/presentation/widgets/rb_collection_card.dart';
import '../../data/models/rb_collection.dart';

class RBCollectionListView extends StatelessWidget {
  final List<RBCollection> collections;

  RBCollectionListView({required this.collections});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final collection = collections[index];
        return RBCollectionCard(collection: collection);
      },
    );
  }
}
