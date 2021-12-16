library boxRepo;

import 'package:item_manager/models/box_model.dart';
import 'package:item_manager/providers/database_provider.dart';

final BoxRepo boxRepo = BoxRepo();

class BoxRepo {

  List<Box> boxCache = [];
  DatabaseProvider dbp = DatabaseProvider();
  Future<List<Box>> getBoxes() async {
    final r = dbp.getBoxes();
    boxCache.clear();
    boxCache.addAll((await r));
    return r;
  }

  void addBox(Box box) {
    dbp.addBox(box.toMap());
  }

  void updateBox(Box box) {
    dbp.updateBox(box.toMap());
  }

}