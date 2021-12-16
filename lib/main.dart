import 'package:flutter/material.dart';
import 'package:item_manager/repos/box_repo.dart';
import 'package:item_manager/repos/item_repo.dart';
import 'package:item_manager/repos/location_repo.dart';
import 'package:item_manager/ui/main_screen.dart';

void main() {
  itemRepo.getItems();
  boxRepo.getBoxes();
  locationRepo.getLocations();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikacja do ewidencji przechowywanych przedmiotow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

