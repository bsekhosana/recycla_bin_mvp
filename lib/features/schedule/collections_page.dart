import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
import 'package:recycla_bin/features/profile/provider/user_provider.dart';
import 'package:recycla_bin/features/schedule/presentation/widgets/rb_collections_list_view.dart';
import 'package:recycla_bin/features/schedule/providers/rb_collections_provider.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {

  @override
  void initState() {
    super.initState();
    _fetchCollections();
  }

  void _fetchCollections() {
    final collectionsProvider = Provider.of<RBCollectionsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user != null && userProvider.user!.id != null) {
      collectionsProvider.fetchCollections(userProvider.user!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      bodySidePadding: 20,
      selectedIndex: 1,
      body: Consumer<RBCollectionsProvider>(
        builder: (context, collectionsProvider, child) {
          if (collectionsProvider.isLoading) {
            return Center(child: CircularProgressIndicator(backgroundColor: Colors.green,));
          } else if (collectionsProvider.collections.isEmpty) {
            return Center(child: Text('No collections found'));
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              child: RBCollectionListView(
                collections: collectionsProvider.collections,
              ),
            );
          }
        },
      ),
      title: 'Collections',
    );
  }
}
