import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:item_manager/models/box_model.dart';
import 'package:item_manager/models/item_model.dart';
import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/repos/box_repo.dart';
import 'package:item_manager/repos/item_repo.dart';
import 'package:item_manager/repos/location_repo.dart';
import 'package:item_manager/ui/add_item_screen.dart';
import 'package:item_manager/ui/item_list_screen.dart';

import 'add_box_screen.dart';


class BoxesScreen extends StatefulWidget {
  BoxesScreen({Key? key}) : super(key: key);

  @override
  _BoxesScreenState createState() => _BoxesScreenState();
}

class _BoxesScreenState extends State<BoxesScreen> {
  Future<List<Box>>? _boxes;

  @override
  void initState() {
    super.initState();
    _boxes = BoxRepo().getBoxes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddBoxScreen())).then((value) {
                  setState(() {
                    _boxes = BoxRepo().getBoxes();
                  });
                }),
                icon: Icon(Icons.add),
                label: Text("Add new box"))),
        Expanded(
            child: FutureBuilder<List<Box>>(
                future: _boxes,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Box>> snapshot) {
                  print(snapshot);
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ItemListScreen(box: snapshot.data![index])));
                              },
                              child: Card(child: Container(
                            height: MediaQuery.of(context).size.height / 7,
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: snapshot.data![index].photos!.isNotEmpty
                                        ? Image.file(File.fromUri(Uri(path:
                                    snapshot.data![index].photos![0]
                                    )))
                                        : SizedBox()
                                ),
                                SizedBox(width: 20,),
                                Text(snapshot.data![index].name,style: TextStyle(fontSize: 24),)
                              ],
                            ),
                          )));
                        });
                  } else return CircularProgressIndicator();
                })),
      ],
    );
  }
}
