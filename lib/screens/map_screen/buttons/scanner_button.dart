import 'package:barcode_scan/barcode_scan.dart';
import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/data/qr_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ScannerButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      child: FloatingActionButton.extended(
        elevation: 16,
        heroTag: "scanner_button",
        tooltip: "Opens the scanner to scan a vehicle's QR code",
        icon: Image.asset("assets/icons/qrcode-scan.png", width: 24, height: 24, color: Colors.black54,),
        label: Text("Scan", style: TextStyle(fontSize: 16, color: Colors.black54),),
        onPressed: () => onPressed(context),
      ),
    );
  }

  void onPressed(BuildContext context) async {
    String qrCodeString = await scan();
    VehicleQrCode qrCode = VehicleQrCode.fromJsonString(qrCodeString);
//    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanResultScreen(qrCode: qrCode)));
    Provider.of<MapsBloc>(context).showVehiclePopup(vehicleId: qrCode.id);
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
