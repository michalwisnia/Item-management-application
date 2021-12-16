import 'package:flutter/material.dart';
import 'package:item_manager/models/box_model.dart';
import 'package:item_manager/models/item_model.dart';
import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/repos/box_repo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseProvider {
  late Database db;

  Future<bool> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    db = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE locations(id INTEGER PRIMARY KEY, name TEXT)');
        await db.execute('CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, photos TEXT, ean TEXT, keywords TEXT, comment TEXT, box INT)');
        await db.execute('CREATE TABLE boxes(id INTEGER PRIMARY KEY, name TEXT, location INTEGER, comment TEXT,qrCode TEXT, photos TEXT)');
      },
      version: 2,
    );
    return true;
  }

  void addLocation(Map<String, dynamic> location) {
    init().then((e) {
      db.insert('locations', location,
          conflictAlgorithm: ConflictAlgorithm.replace);

      print(location);
    });
  }

  void addItem(Map<String, dynamic> item) {
    init().then((e) {
      db.insert('items', item, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  void addBox(Map<String, dynamic> box) {
    init().then((e) {
      db.insert('boxes', box, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<List<Location>> getLocations() async {
    await init();
    await boxRepo.getBoxes();
      final List<Map<String, dynamic>> maps = await db.query('locations');
      print(maps);
        return List.generate(maps.length, (i) {
          return Location(
            id: maps[i]['id'],
            name: maps[i]['name'],
            boxes: boxRepo.boxCache.where((element) => element.location == maps[i]['id']).toList()
          );
        });
  }

  Future<List<Item>> getItems() async {
    await init();
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        name: maps[i]['name'],
        comment: maps[i]['comment'],
        EAN: maps[i]['EAN'],
        photos: List<String>.from(jsonDecode(maps[i]['photos'])),
        keywords: List<String>.from(jsonDecode(maps[i]['keywords'])),
        box: maps[i]['box']
      );
    });
  }

  Future<List<Box>> getBoxes() async {
    await init();
    final List<Map<String, dynamic>> maps = await db.query('boxes');
    return List.generate(maps.length, (i) {
      return Box(
        id: maps[i]['id'],
        name: maps[i]['name'],
        comment: maps[i]['comment'],
        qrCode: maps[i]['qrCode'],
        location: maps[i]['location'],
        photos: List<String>.from(jsonDecode(maps[i]['photos'])),
      );
    });
  }

  void updateBox(Map<String, dynamic> box) async {
    await init();
    db.update('boxes',
    box,
    where: 'id = ?',
    whereArgs: [box['id']]);
  }

  void updateItem(Item item) async {
    await init();
    db.update('items', item.toMap(),
    where: 'id = ?',
    whereArgs: [item.id]);
  }

  void removeLocation(Map<String, dynamic> location) async {
    await init();
    db.delete('locations',
    where: 'id = ?',
    whereArgs: [location['id']]);
  }
}
