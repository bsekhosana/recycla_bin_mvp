import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/utilities/dialogs_utils.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
import 'package:recycla_bin/features/profile/provider/user_provider.dart';
import 'package:recycla_bin/features/schedule/presentation/widgets/rb_collections_list_view.dart';
import 'package:recycla_bin/features/schedule/providers/rb_collection_provider.dart';
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
    final collectionsProvider = Provider.of<RBCollectionsProvider>(context, listen: false);
    // showLoadingDialog(context);
    return UserScaffold(
      selectedIndex: 1,
        body: Consumer<RBCollectionsProvider>(
          builder: (context, collectionsProvider, child) {
            if(collectionsProvider.collections.isEmpty){
              return Center(child: Text('No collections found'));
            }else{
              // hideLoadingDialog(context);
              return Container(
                height: MediaQuery.of(context).size.height*0.7,
                  width: double.infinity,
                  child: RBCollectionListView(
                      collections: collectionsProvider.collections
                  ),
              );
            }
          },
        ),
        title: 'Collections',
    );
  }
}
