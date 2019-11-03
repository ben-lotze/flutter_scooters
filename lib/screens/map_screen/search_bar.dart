import 'package:flutter/material.dart';


// TODO: make unfocus work (clicking anywhere else)
// TODO: autocomplete with maps data

class SearchBar extends StatelessWidget {

  final TextEditingController _editController;

  SearchBar()
      : _editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8.0,
      left: 8.0,
      right: 8.0,
      // appbar is used to have automatic positioning under transparent status bar
      child: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        primary: true,  // must be true, otherwise behind statusBar/topNotch
        bottomOpacity: 0,
        leading: null, // suppress back button
        automaticallyImplyLeading: false, // suppress back button
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        title: Container(
          height: 48,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(8),  // necessary for shadow/elevation of contained Card
          padding: EdgeInsets.all(0),

          child: Card(
            margin: EdgeInsets.all(0),
            elevation: 8.0,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.menu),),

                  Expanded(
                    child: TextFormField(
                      controller: _editController,
                      textAlign: TextAlign.start,
                      minLines: 1,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Enter destination",
                        contentPadding: EdgeInsets.all(8),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          tooltip: "Clear text input",
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _editController.clear();
                          }
                        ),
                      ),

                      onFieldSubmitted: (content) {
                        // real behavior not implemented yet
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("This would start a search for '$content'.", maxLines: 3,),
                          behavior: SnackBarBehavior.floating,)
                        );
                      },
                    ),
                  ),

                  IconButton(icon: Icon(Icons.mic),),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
