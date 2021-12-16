library itemRepo;

import 'package:item_manager/models/item_model.dart';
import 'package:item_manager/providers/database_provider.dart';

final ItemRepo itemRepo = ItemRepo();
class ItemRepo {

  DatabaseProvider dbp = DatabaseProvider();
  List<Item> itemCache = [];

  void addItem(Item item) {
    dbp.addItem(item.toMap());
  }

  Future<List<Item>> getItems() async {
    final r = dbp.getItems();
    itemCache.clear();
    itemCache.addAll((await r));
    return r;
  }

  Future<List<Item>> filteredItems(String string) async {
    return itemCache.where((element) => element.name.contains(string)).toList();
  }

  void updateItem(Item item) {
    dbp.updateItem(item);
  }
}