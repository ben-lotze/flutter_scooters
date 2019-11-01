import 'package:flutter/material.dart';


// TODO: make unfocus work (clicking anywhere else)
// TODO: autocomplete with maps data

class SearchBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: AppBar(        // Add AppBar here only
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Container(),
        title: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Container(
              height: 48,
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
