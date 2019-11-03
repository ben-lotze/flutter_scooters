import 'package:flutter/material.dart';


// TODO: make unfocus work (clicking anywhere else)
// TODO: autocomplete with maps data

class SearchBar extends StatefulWidget {

  final TextEditingController _editController;

  SearchBar()
      : _editController = TextEditingController();

  @override
  _SearchBarState createState() => _SearchBarState();

}

class _SearchBarState extends State<SearchBar> {

  bool hasContent;

  FocusNode focus;

  @override
  void initState() {
    super.initState();
    focus = FocusNode();

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
                      focusNode: focus,
                      controller: widget._editController,
                      textAlign: TextAlign.start,
                      minLines: 1,
                      maxLines: 1,
                      onChanged: onChanged,
                      onTap: onTap,
                      decoration: InputDecoration(
                        hintText: "Enter destination",
                        contentPadding: EdgeInsets.all(8),
                        border: InputBorder.none,

                        suffixIcon: hasContent ? IconButton(
                          tooltip: "Clear text input",
                          icon: Icon(Icons.close),
                          onPressed: () => clearInput()
                        ) : Container(width: 0, height: 0, color: Colors.transparent,),

                      ),


                        validator: (str) {
                          return str;
                        },


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
    focus.unfocus();
    hasContent = false;
//    widget._editController.selection = TextSelection(baseOffset: 0);
    widget._editController.clear();

    setState(() {

    });
  }





}
