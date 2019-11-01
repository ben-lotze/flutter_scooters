import 'package:flutter/material.dart';


class ScannerButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: FloatingActionButton.extended(
        heroTag: "maps_scanner_button",
        icon: Image.asset("assets/icons/qrcode-scan.png", width: 24, height: 24, color: Colors.black54,),
        label: Text("Scan", style: TextStyle(fontSize: 16, color: Colors.black54),),
        onPressed: () => onPressed(context),
      ),
    );
  }

  void onPressed(BuildContext context) async {
//    scan();
  }


  /// logic for scanning taken from example on Medium:
  /// https://medium.com/flutter-community/building-flutter-qr-code-generator-scanner-and-sharing-app-703e73b228d3
//  Future<String> scan() async {
//    try {
//      return await BarcodeScanner.scan();
//    }
//    on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.CameraAccessDenied) {
//          return "You did not grant the camera permission. You shall not scan.";
//      }
//      else {
//        return "Unknown error: $e";
//      }
//    }
//    on FormatException{
//      return 'null (User returned using the "back"-button before scanning anything. Result)';
//    }
//    catch (e) {
//      return 'Unknown error: $e';
//    }
//  }
}
