
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:item_manager/models/location_model.dart';
import 'package:item_manager/repos/location_repo.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io' show Platform;

class BarcodeScreen extends StatefulWidget {
  BarcodeScreen({Key? key}) : super(key: key);

  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {

  final GlobalKey barcodeKey = GlobalKey(debugLabel: 'barcode');
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
    return Material(child:
      Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: barcodeKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Row(
                      children: [
                      Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green)
                          ),
                            onPressed: () {
                              Navigator.pop(context, result!.code);
                            },
                            child: Icon(Icons.check))
                      ],
                     )
                  : Text('Scan a code'),
            ),
          )
        ],
      ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


}