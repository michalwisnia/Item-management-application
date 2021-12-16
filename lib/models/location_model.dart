import 'package:item_manager/models/item_model.dart';
import 'box_model.dart';

class Location {
  final int id;
  final String name;
  final List<Box>? boxes;

  Location({
    required this.id,
    required this.name,
    this.boxes
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) => other is Location && other.id == id;

  @override
  int get hashCode => id.hashCode;

}