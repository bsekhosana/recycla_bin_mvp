import '../../data/data_provider/shared_pref_provider.dart';
import '../../data/models/rb_collection.dart';

class RBCollectionRepository {
  final SharedPrefProvider sharedPrefProvider;

  RBCollectionRepository({required this.sharedPrefProvider});

  Future<void> saveCollection(RBCollection collection) {
    return sharedPrefProvider.saveRBCollection(collection);
  }

  Future<RBCollection?> getCollection() {
    return sharedPrefProvider.getRBCollection();
  }

  Future<void> removeCollection() {
    return sharedPrefProvider.removeRBCollection();
  }
}
