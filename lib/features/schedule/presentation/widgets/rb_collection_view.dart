import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/features/schedule/presentation/widgets/rb_collections_list_view.dart';
import 'package:recycla_bin/features/schedule/providers/rb_collections_provider.dart';

import '../../providers/rb_collection_provider.dart';

class RBCollectionView extends StatelessWidget {
  final String userId;

  RBCollectionView({required this.userId});

  @override
  Widget build(BuildContext context) {
    final collectionProvider = Provider.of<RBCollectionsProvider>(context);

    return FutureBuilder(
      future: collectionProvider.fetchCollections(userId),
      builder: (context, snapshot) {
          return RBCollectionListView(collections: collectionProvider.collections);
        }
    );
  }
}