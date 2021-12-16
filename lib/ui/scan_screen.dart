
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:item_manager/models/box_model.dart';
import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/repos/box_repo.dart';
import 'package:item_manager/repos/item_repo.dart';
import 'package:item_manager/repos/location_repo.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io' show File, Platform;

class ScanScreen extends StatefulWidget {
  ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if(boxRepo.boxCache.where((element) => element.qrCode == result!.code).isNotEmpty){
        controller.pauseCamera();
        Box box = boxRepo.boxCache.singleWhere((element) => element.qrCode == result!.code);
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(box.name,style: TextStyle(fontSize: 20),),
                    Text("Contains: "),
                    Expanded(child:
                    ListView.builder(
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
                    ))
                  ],
                ),
              ),
            );
          },
        ).then((value) => controller.resumeCamera());
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


}