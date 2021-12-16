import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:item_manager/models/box_model.dart';
import 'package:item_manager/models/item_model.dart';
import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/repos/item_repo.dart';
import 'package:item_manager/repos/location_repo.dart';
import 'package:item_manager/ui/boxes_screen.dart';
import 'package:item_manager/ui/items_screen.dart';
import 'package:item_manager/ui/locations_screen.dart';
import 'package:item_manager/ui/scan_screen.dart';

class ItemListScreen extends StatefulWidget {
  ItemListScreen({required this.box});
  final Box box;

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Box box = widget.box;
    return Material(child: ListView.builder(
        itemCount: itemRepo.itemCache.where((element) => element.box == box.id).length,
        itemBuilder: (BuildContext context,int index){
          final items = itemRepo.itemCache.where((element) => element.box == box.id).toList();
          return Card(child: Container(
            height: MediaQuery.of(context).size.height / 7,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: items[index].photos!.isNotEmpty
                        ? Image.file(File.fromUri(Uri(path:
                    items[index].photos![0]
                    )))
                        : SizedBox()
                ),
                SizedBox(width: 20,),
                Expanded(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[index].name,style: TextStyle(fontSize: 24),),
                    ],
                  ),
                ),
              ],
            ),
          ));

        }
    ));

  }


}