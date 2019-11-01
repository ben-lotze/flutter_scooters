import 'package:flutter/material.dart';


// TODO: make unfocus work (clicking anywhere else)
// TODO: autocomplete with maps data

class SearchBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8.0,
      left: 8.0,
      right: 8.0,
      // appbar is used to profit from automatic positioning under status bar (while using transparent status bar)
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 16.0,
        leading: null, // Container(width: 0, height: 0, margin: EdgeInsets.all(0), padding: EdgeInsets.all(0), color: Colors.blue,),  // suppress back button
        automaticallyImplyLeading: false,
        title: Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Container(
//              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.blue)),
              height: 48,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.menu),),

                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      minLines: 1,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Enter destination",
                        contentPadding: EdgeInsets.all(8),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  IconButton(icon: Icon(Icons.mic),),
                ],
              )
          ),
        ),
      ),
    );
  }
}
