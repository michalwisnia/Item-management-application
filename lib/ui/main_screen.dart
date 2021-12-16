import 'dart:math';
import 'package:flutter/material.dart';
import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/repos/location_repo.dart';
import 'package:item_manager/ui/boxes_screen.dart';
import 'package:item_manager/ui/items_screen.dart';
import 'package:item_manager/ui/locations_screen.dart';
import 'package:item_manager/ui/scan_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  int _selectedIndex = 1;

  static List<Widget> _screens = [
    ScanScreen(),
    LocationsScreen(),
    BoxesScreen(),
    ItemsScreen()
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Scan',
    ),
    Text(
      'Locations',
    ),
    Text("Boxes"),
    Text(
      'Items',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _widgetOptions[_selectedIndex],),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.room),
              label: 'Locations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inbox_rounded),
              label: 'Boxes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wine_bar),
              label: 'Items',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: _screens[_selectedIndex]
    );
  }


}