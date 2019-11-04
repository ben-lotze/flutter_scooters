import 'package:flutter/material.dart';


class SearchBar extends StatefulWidget {

  final TextEditingController _editController;

  SearchBar()
      : _editController = TextEditingController();

  @override
  _SearchBarState createState() => _SearchBarState();

}



class _SearchBarState extends State<SearchBar> {

  bool hasContent;

  @override
  void initState() {
    super.initState();
    hasContent = false;
  }

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
        title: Container(
          height: 56,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(8),  // necessary for shadow/elevation of contained Card
          padding: EdgeInsets.all(0),

          child: Card(
            margin: EdgeInsets.all(0),
            elevation: 8.0,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  // main menu
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.black54,),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),


                  // text input
                  Expanded(
                    child: TextFormField(
                      controller: widget._editController,
                      textAlign: TextAlign.start,
                      minLines: 1,
                      maxLines: 1,
                      onChanged: onChanged,
                      onTap: onTap,
                      decoration: InputDecoration(
                        hintText: "Enter destination",
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        border: InputBorder.none,
                        suffixIcon: hasContent ? IconButton(
                          tooltip: "Clear text input",
                          icon: Icon(Icons.close),
                          onPressed: () => clearInput()
                        ) : Container(width: 0, height: 0, color: Colors.transparent,),

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


                  // mic button
                  IconButton(
                    icon: Icon(Icons.mic,color: Colors.black54),
                    onPressed: () {
                      Scaffold.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Speak to the machine (not implemented)"),));
                    },
                  ),

                ],
              ),
          ),
        ),
      ),
    );
  }


  void test(String content) {
    hasContent = (content!= null && content.length > 0) ? true : false;
    setState(() {});
  }

  void onChanged(String value) {
    test(value);
  }

  void onTap() {
    test(widget._editController.text);
  }

  void clearInput() {
    hasContent = false;
//    widget._editController.selection = TextSelection(baseOffset: 0);
    widget._editController.clear();
    setState(() {});
  }

}
