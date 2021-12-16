library locationRepo;

import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/providers/database_provider.dart';

final locationRepo = LocationRepo();
class LocationRepo {

  List<Location> locationCache = [];

  DatabaseProvider dbp = DatabaseProvider();

  void addLocation(Location location){
      dbp.addLocation(location.toMap());
  }

  Future<List<Location>> getLocations() async {
      final rr = dbp.getLocations();
      print(rr);
      locationCache.clear();
      locationCache.addAll((await rr));
      return(rr);
    }

    void deleteLocation(Location location) {
      dbp.removeLocation(location.toMap());
    }

}