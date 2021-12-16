import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:item_manager/models/box_model.dart';
import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/repos/box_repo.dart';
import 'package:item_manager/repos/location_repo.dart';

class LocationsScreen extends StatefulWidget {
  LocationsScreen({Key? key}) : super(key: key);

  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  TextEditingController _textFieldController = TextEditingController();
  LocationRepo lRepo = LocationRepo();
  Future<List<Location>>? _locations;

  @override
  void initState() {
    super.initState();
    _locations = locationRepo.getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                    onPressed: () => _displayAddLocationDialog(context),
                    icon: Icon(Icons.add),
                    label: Text("Add new location"))
            ),
            Expanded(child:
            FutureBuilder<List<Location>>(
              future: _locations,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Location>> snapshot) {
                print(snapshot);
                if (snapshot.hasData) {

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionTile(
                        childrenPadding: EdgeInsets.all(10),
                        title: Text(snapshot.data![index].name),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              snapshot.data![index].boxes!.isEmpty
                              ? ElevatedButton(
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                  onPressed: () {
                                    locationRepo.deleteLocation(snapshot.data![index]);
                                    setState(() {
                                      _locations = locationRepo.getLocations();
                                    });
                                  },
                                  child: Text("Delete location")
                              )
                              : SizedBox(width: 0,),
                              ElevatedButton(
                                  onPressed: () async {
                                   Box? box = await _showBoxDialog(snapshot.data![index].name);
                                   if(box != null){
                                    Box newBox = Box(
                                       id: box.id,
                                       name: box.name,
                                       location: snapshot.data![index].id,
                                       comment: box.comment,
                                       qrCode: box.qrCode,
                                       photos: box.photos,
                                     );
                                    boxRepo.updateBox(newBox);
                                    setState(() {
                                      _locations = locationRepo.getLocations();
                                    });
                                   }
                                  },
                                  child: Text("Add box")
                              ),
                            ],
                          ),
                          Column(
                            children:
                              snapshot.data![index].boxes != null
                                ? List.generate(snapshot.data![index].boxes!.length, (i) {
                                return Card(child: Container(
                                    height: MediaQuery.of(context).size.height / 10,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: snapshot.data![index].boxes![i].photos!.isNotEmpty
                                            ? Image.file(File.fromUri(Uri(path:
                                        snapshot.data![index].boxes![i].photos![0]
                                        )))
                                            : SizedBox()
                                    ),
                                    SizedBox(width: 20,),
                                    Text(snapshot.data![index].boxes![i].name,style: TextStyle(fontSize: 24),)
                                  ],
                                )));
                              })
                            : [SizedBox()],
                          ),
                        ],
                      );
                    },
                  );
                }
                else
                  return Center(child: Text("No locations yet"),);
              },
            )),
          ],
        );
  }

  Future<void> _displayAddLocationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Location'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Location name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                lRepo.addLocation(Location(
                  id: Random().nextInt(4294967296),
                  name: _textFieldController.text,
                ));
                Navigator.pop(context);
                setState(() {
                  _locations = lRepo.getLocations();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<Box?> _showBoxDialog(String destination) async {
    return showDialog<Box?>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Move box to $destination"),
          content: SingleChildScrollView(
            child: ListBody(
              children: List.generate(boxRepo.boxCache.length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, boxRepo.boxCache[index]);
                  },
                    child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(boxRepo.boxCache[index].name,style: TextStyle(fontSize: 20),),
                ));
              })
            ),
          ),
        );
      },
    );
  }
}