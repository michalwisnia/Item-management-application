import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:item_manager/models/item_model.dart';
import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/repos/item_repo.dart';
import 'package:item_manager/repos/location_repo.dart';
import 'package:item_manager/ui/barcode_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class AddItemScreen extends StatefulWidget {
  AddItemScreen({Key? key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  var _images = <Widget>[];
  List<String> imgPaths = [];
  final TextEditingController EACController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();
  final TextEditingController commentController = TextEditingController();



  ItemRepo iRepo = ItemRepo();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add item"),
        ),
        body:
        Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: "Item name", contentPadding: EdgeInsets.all(20)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
                TextFormField(
                  controller: EACController,
                  decoration: InputDecoration(
                      labelText: "EAN / UPC code (optional)", contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  suffix: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      EACController.text = await
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BarcodeScreen()));
                    }
                    ,
                  )),
                ),
                TextFormField(
                  controller: keywordController,
                  decoration: InputDecoration(
                      labelText: "Keywords (separated by commas)", contentPadding: EdgeInsets.all(20)),

                ),
                TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                      labelText: "Comment", contentPadding: EdgeInsets.all(20)),

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
                      iRepo.addItem(
                        Item(
                          id: Random().nextInt(4294967296),
                          name: nameController.text,
                          comment: commentController.text,
                          keywords: keywordController.text.split(','),
                          EAN: EACController.text,
                          photos: imgPaths,
                            box: 0
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
