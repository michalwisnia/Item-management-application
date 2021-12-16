import 'dart:typed_data';
import 'dart:convert';
import 'package:item_manager/models/location_model.dart';

class Box {
  final int id;
  final String name;
  final int location;
  final String comment;
  final String qrCode;
  final List<String>? photos;

  Box({
    required this.id,
    required this.name,
    required this.location,
    required this.comment,
    required this.qrCode,
    this.photos
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'comment': comment,
      'qrCode': qrCode,
      'photos': jsonEncode(photos),
    };
  }
}