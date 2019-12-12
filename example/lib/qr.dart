import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrExample extends StatefulWidget {
  @override
  _QrExampleState createState() => _QrExampleState();
}

class _QrExampleState extends State<QrExample> {

  String text = "";
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Example"),
      ),

      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Generate QR code"),
                    onPressed: () {
                      setState(() {
                        text = (text == "") ? "Hello world!" : "";
                      });
                    },
                  ),
                  SizedBox(width: 20,),
                  RaisedButton(
                    child: Text("Scan QR code"),
                    onPressed: () {
                      scan();
                    },
                  )
                ],
              ),
              SizedBox(height: 40,),
              QrImage(
                data: text,
                version: QrVersions.auto,
                size: 270,
                gapless: true,
              ),
              SizedBox(height: 40,),
              Text(scannedText)
            ],
          )
        ],
      ),
    );
  }

  Future<void> scan() async {
    try {
      String scanRes = await BarcodeScanner.scan();
      setState(() {
        this.scannedText = scanRes;
        this.text = scanRes;
      });
    } 
    on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) 
        setState(() {
          this.scannedText = 'The user did not grant the camera permission!';
        });

      else 
        setState(() {
          this.scannedText = 'Unknown error: $e';
        });
    } 
    on FormatException{
      setState(() {
        this.scannedText = 'back button was pressed before scan was completed';
      });
    } 
    catch (e) {
      setState(() {
        this.scannedText = 'Unknown error: $e';
      });
    }
  }
}