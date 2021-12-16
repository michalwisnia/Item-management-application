import 'dart:typed_data';
import 'dart:convert';

class Item {
  final int id;
  final String name;
  final List<String>? photos;
  final String? EAN;
  final List<String> keywords;
  final String comment;
  final int box;

  Item({
    required this.id,
    required this.name,
    this.photos,
    this.EAN,
    required this.keywords,
    required this.comment,
    required this.box
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photos': jsonEncode(photos),
      'EAN': EAN,
      'keywords': jsonEncode(keywords),
      'comment': comment,
      'box': box,
    };
  }
}