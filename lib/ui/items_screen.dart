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


class ItemsScreen extends StatefulWidget {
  ItemsScreen({Key? key}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  Future<List<Item>>? _items;

  @override
  void initState() {
    super.initState();
    _items = itemRepo.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      TextField(
        onChanged: (e) async {
          setState(() {
            _items = itemRepo.filteredItems(e);
          });
        },
        decoration: InputDecoration(
          labelText: "Seach"
        ),
      ),
      
      Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddItemScreen())).then((value) {
                    setState(() {
                      _items = ItemRepo().getItems();
                    });
              }),
              icon: Icon(Icons.add),
              label: Text("Add new item"))),
      Expanded(
          child: FutureBuilder<List<Item>>(
              future: _items,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                print(snapshot);
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(child: Container(
                          height: MediaQuery.of(context).size.height / 7,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
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
                                  Expanded(
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data![index].name,style: TextStyle(fontSize: 24),),
                                    snapshot.data![index].box == 0
                                        ? Text("Not in any box")
                                        : Text("In box ${boxRepo.boxCache.firstWhere((element) => element.id == snapshot.data![index].box).name}")
                                      ],
                                    ),
                                  ),

                              Align(
                                alignment: Alignment.centerRight,
                                child:  ElevatedButton(
                                    onPressed: () async {
                                      Box? box = await _showBoxDialog(snapshot.data![index].name);
                                      if(box != null){
                                        Item item = Item(
                                          id: snapshot.data![index].id,
                                          name: snapshot.data![index].name,
                                          comment: snapshot.data![index].comment,
                                          EAN: snapshot.data![index].EAN,
                                          photos: snapshot.data![index].photos,
                                          box: box.id,
                                          keywords: snapshot.data![index].keywords,
                                        );
                                        itemRepo.updateItem(item);
                                        setState(() {
                                          _items = itemRepo.getItems();
                                        });
                                      }
                                    },
                                    child: Text("Move to box")),
                              ),
                            ],
                          ),
                        ));
                      });
                } else return CircularProgressIndicator();
              })),
    ]);
  }

  Future<Box?> _showBoxDialog(String item) async {
    return showDialog<Box?>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Move $item to: "),
          content: SingleChildScrollView(
            child: ListBody(
                children: List.generate(boxRepo.boxCache.length +1, (index) {
                  if(index == 0){
                    return ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context,
                          Box(
                            id: 0,
                            name: "none",
                            photos: [],
                            comment: "",
                            location: 0,
                            qrCode: "",
                          ));
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                        child: Text("none"));
                  }
                  return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, boxRepo.boxCache[index-1]);
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text(boxRepo.boxCache[index-1].name,style: TextStyle(fontSize: 20),),
                      ));
                })
            ),
          ),
        );
      },
    );
  }

}
