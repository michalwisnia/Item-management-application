import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:item_manager/models/box_model.dart';
import 'package:item_manager/models/item_model.dart';
import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/repos/box_repo.dart';
import 'package:item_manager/repos/item_repo.dart';
import 'package:item_manager/repos/location_repo.dart';
import 'package:item_manager/ui/barcode_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class AddBoxScreen extends StatefulWidget {
  AddBoxScreen({Key? key}) : super(key: key);

  @override
  _AddBoxScreenState createState() => _AddBoxScreenState();
}

class _AddBoxScreenState extends State<AddBoxScreen> {
  final _boxformKey = GlobalKey<FormState>();
  var _images = <Widget>[];
  List<String> imgPaths = [];
  final TextEditingController QRController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController commentController = TextEditingController();



  BoxRepo bRepo = BoxRepo();
  List<Location> _locations = locationRepo.locationCache.toSet().toList();
  String dropdownValue = 'none';


  void updateImgs(XFile pic) async {
    Directory dir = await getApplicationDocumentsDirectory();
    imgPaths.add(dir.path + "/${pic.name}");

    setState(() {
      _images.add(Image.file(File.fromUri(Uri(path: pic.path))));
    });
  }

  @override
  void initState() {
    super.initState();
    _locations.add(Location(id: 0, name: 'none'));

    print(_locations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add box"),
        ),
        body:
        Form(
          key: _boxformKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Box name", contentPadding: EdgeInsets.all(20)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: QRController,
                  decoration: InputDecoration(
                      labelText: "QR code", contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      suffix: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                          QRController.text = await
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BarcodeScreen()));
                        }
                        ,
                      )),
                ),

                TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                      labelText: "Comment", contentPadding: EdgeInsets.all(20)),

                ),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text("Location: "),
                    DropdownButton<String>(
                      items: _locations.map<DropdownMenuItem<String>>((Location value){
                        return DropdownMenuItem(value: value.name, child: Text(value.name),);
                      }).toList(),
                    value: dropdownValue,
                      icon: Icon(Icons.keyboard_arrow_down_sharp),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 50,),
                Flexible(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: EdgeInsets.all(10),
                      crossAxisCount: 3,
                      children: List.generate(_images.length +1, (index) {
                        if(index +1 > _images.length) {
                          return GestureDetector(
                              onTap: () async {
                                final img = await _takePic();
                                if(img != null){
                                  updateImgs(img);
                                }

                              },
                              child: Container(
                                  color: Colors.grey[300],
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Text("Add photo")
                                    ],
                                  )
                              ));
                        } else return
                          Container(
                            color: Colors.grey,
                            height: MediaQuery
                                .of(context)
                                .size
                                .width / 3,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 3,
                            child: _images[index],
                          );
                      }),
                    )),
                ElevatedButton(
                    onPressed: () {
                      bRepo.addBox(
                          Box(
                            location: _locations.firstWhere((element) => element.name == dropdownValue).id,
                              id: Random().nextInt(4294967296),
                              name: nameController.text,
                              comment: commentController.text,
                              qrCode: QRController.text,
                              photos: imgPaths
                          )
                      );
                      Navigator.pop(context);
                    },
                    child: Text("Save")
                ),
                SizedBox(height: 20,),
              ]),
        ));
  }

  Future<XFile?> _takePic() async {
    print("tapped");
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      print(photo.name);
      Directory dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      photo.saveTo(dir.path + "/${photo.name}");
      return photo;
    }
  }
}
