import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/generic_widgets/vertical_image_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapDetailsImageButton extends StatelessWidget {

  final String imgAsset;
  final String text;
  final String tooltip;
  final Function onTap;
  final MapDetails mapDetails;
  final BuildContext context;

  static const TOOLTIP_PUBLIC_TRANSPORT = "Switch public transport on or off";
  static const TOOLTIP_TRAFFIC = "Switch traffic on or off";
  static const TOOLTIP_BIKE_LANES = "Switch bike lanes on or off";

  /// A button with two rows: an image on top and text underneath.
  /// <br>[imgAsset] asset image to be shown
  /// <br>[text] map type name
  /// <br>[tooltip] A tooltip that will appear on long tapping
  /// <br>[onTap] callback
  /// <br>[context] parent context, necessary to find bloc(s)
  const MapDetailsImageButton({Key key, this.imgAsset, this.text, this.tooltip, this.onTap, this.context, this.mapDetails}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    MapsBloc mapsBloc = Provider.of<MapsBloc>(this.context);
    return StreamBuilder<MapState>(

        stream: mapsBloc.mapStateStream,
        // TODO: initial data?
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(child: Center(child: Text("Error")));
          }
          else if(snapshot.hasData) {
            Set<MapDetails> allActivatedMapDetails = snapshot.data.mapDetails;
            bool mapDetailsAreActivated = allActivatedMapDetails.contains(this.mapDetails);
            return VerticalImageTextButton(
              imgAsset: imgAsset,
              text: text,
              tooltip: tooltip,
              drawBorder: mapDetailsAreActivated,
              onTap: () {
                Scaffold.of(this.context).removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
                Scaffold.of(this.context).showSnackBar(SnackBar(content: Text(tooltip),));
                // activate/deactivate map details
                if (mapDetailsAreActivated) {
                  mapsBloc.removeMapDetails(mapDetails);
                }
                else {
                  mapsBloc.addMapDetails(mapDetails);
                }

                // additional actions as specified by widget params
                if (this.onTap != null) {
                  this.onTap();
                }
              },
            );
          }
          else {
            return Container(child: Center(child: Text("Loading")));
          }

        }
    );
  }
}


