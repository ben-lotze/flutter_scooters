/*
one page with multiple images for
- How to ride?
- Circ Scooter (scooter info)
- About Circ -> why? goals, ...



alternaitve design ideas:
- top: 3 images as tabs -> content is to be scrolled (indicator circles)
 */



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// no Bloc necessary, is self contained
class TutorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: Text("How to use Circ scooters"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Expanded(
                child: PageView(
                  children: <Widget>[
                    _TutorialPage(
                      title: "Unlocking",
                      assetPath: "assets/tutorial/tutorial_page_1.png",
                      description: "Scan the QR code of the scooter with the Circ app on your phone or enter the code manually.",
                    ),
                    _TutorialPage(
                      title: "Be safe",
                      assetPath: "assets/tutorial/tutorial_page_2.png",
                      description: "Please use a helmet for you own safety. Always check brakes and lights before you start driving.",
                    ),
                    _TutorialPage(
                      title: "Drive relaxed",
                      assetPath: "assets/tutorial/tutorial_page_3.png",
                      description: "To start driving, accelerate three times with your foot. Then use the switch on your handlebar to adjust scooter speed. "
                          "Please use the bicycle lanes and don't dive on the street.",
                    ),
                    _TutorialPage(
                      title: "Parking",
                      assetPath: "assets/tutorial/tutorial_page_4.png",
                      description: "Stop your drive in the app. When parking your scooter please select an appropriate position responsibly.",
                    ),
                  ],
                ),
              ),



              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  alignment: Alignment.center,
                  child: Text("OK. I got this."),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(24)
                  ),
                ),
              )

            ],


          ),
        ),
      ),
    );
  }
}



class _TutorialPage extends StatelessWidget {

  final String title;
  final String assetPath;
  final String description;


  _TutorialPage({
      this.title,
      this.assetPath,
      this.description
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          SizedBox(height: 16,),

          Image.asset(assetPath,
            width: 200,
            fit: BoxFit.scaleDown,
          ),

          SizedBox(height: 16,),
          Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
        ],
      ),
    );
  }
}

