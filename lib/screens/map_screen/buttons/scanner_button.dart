import 'package:barcode_scan/barcode_scan.dart';
import 'package:circ_flutter_challenge/data/qr_code.dart';
import 'package:circ_flutter_challenge/screens/scan_result/scan_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScannerButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      child: FloatingActionButton.extended(
        elevation: 16,
        heroTag: "maps_scanner_button",
        icon: Image.asset("assets/icons/qrcode-scan.png", width: 24, height: 24, color: Colors.black54,),
        label: Text("Scan", style: TextStyle(fontSize: 16, color: Colors.black54),),
        onPressed: () => onPressed(context),
      ),
    );
  }

  void onPressed(BuildContext context) async {
    String qrCodeString = await scan();
//    print(qrCodeString);
    VehicleQrCode qrCode = VehicleQrCode.fromJsonString(qrCodeString);
    print(qrCode);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanResultScreen(qrCode: qrCode)));


    //    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraApp()));   // quick qr scanner -> build problems
  }


  /// logic for scanning taken from example on Medium:
  /// https://medium.com/flutter-community/building-flutter-qr-code-generator-scanner-and-sharing-app-703e73b228d3
  Future<String> scan() async {
    try {
      return await BarcodeScanner.scan();
    }
    on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
          return "You did not grant the camera permission. You shall not scan.";
      }
      else {
        return "Unknown error: $e";
      }
    }
    on FormatException{
      return 'User returned using the "back"-button before scanning anything.)';
    }
    catch (e) {
      return 'Unknown error: $e';
    }
  }
}
