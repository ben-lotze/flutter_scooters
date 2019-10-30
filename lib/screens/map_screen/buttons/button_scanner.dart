import 'package:flutter/material.dart';

class ScannerButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: FloatingActionButton.extended(
        icon: Image.asset("assets/icons/qrcode-scan.png", width: 24, height: 24, color: Colors.black54,),
        label: Text("Scan", style: TextStyle(fontSize: 16, color: Colors.black54),),
        onPressed: onPressed,
      ),
    );
  }

  void onPressed() {
    // TODO: new route for scanner
  }
}
