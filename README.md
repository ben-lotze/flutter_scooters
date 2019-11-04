# Circ Flutter Challenge

Challenge app to be hired at Circ.

## To get this up and running

* Google maps API keys are not provided inside this repository. They have to be inserted into Gradle.
* Integration tests: Due to limitations in Flutter framework the permissions need to be granted on test startup.
* Integration tests can be started with **`flutter drive --target=test_driver/app.dart`** from the project directory.


## Technical details
* UI and business logic are decoupled by using the BLoC pattern.
* Developed and tested with Flutter dev channel (1.10.14)
* Targeting Android API level >= 16A



## Additionally implemented features

#### Platform specific launcher icons
<img src="readme_resources/launcher_ios.png" width="100"/>   <img src="readme_resources/launcher_android.png" width="100"/>

<i>iOS left, Android right</i>

#### QR code scanner

Scanning a QR code opens the info popup to unlock the vehicle:

<img src="readme_resources/scanner_button.gif" width="360" />   <img src="readme_resources/scanner_opens_info_popup.gif" width="360"/> 


Scan any of these QR codes to simulate scanning a scooter (vehicles 1-6):

<img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-1.png" width="250" style="border:10;">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-2.png" width="250">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-3.png" width="250">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-4.png" width="250">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-5.png" width="250">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-6.png" width="250">   

<i>Camera is not working in iOS <b>simulator</b> as the simulator has no camera support.</i>


#### Custom swipe to confirm button
* At first I made on myself based on Draggable and DragDestination. This did not bring the desired result since the horizontal movement could not be constrained and teh draggable could be dragged outside of the slider borders.
* Then I tried two libraries and was not satisfied with them. So I made my own.
* I will publish this custom drag-to-confirm widget soon as package (after some adjustments and cleanups). 

<img src="readme_resources/swipe_to_confirm.gif" width="360"/>


#### Map types / details
<img src="readme_resources/maps_details_1.png" width="360"/>   <img src="readme_resources/maps_details_2.png" width="360"/>


#### User manual
<img src="readme_resources/tutorial_1.png" width="360"/>   <img src="readme_resources/tutorial_2.png" width="360"/>   <img src="readme_resources/tutorial_3.png" width="360"/>   <img src="readme_resources/tutorial_4.png" width="360"/>


#### Some more screenshots
<img src="readme_resources/selecting_markers_360.gif" width="360"/>




## Open problems:
* animations for overlay buttons when vehicle info popup opens (are currently hidden)
* A click on a marker does not center the map (this was intentional, since this could be confusing). But the map should be centered if the marker would be hidden by the info popup.
* unfocus search bar when map is tapped
* more integration tests (especially for MapsBloc)


## What would be nice (with more time):
* swipe indicator for tutorial
* startup/loading screen
* persistance: i.e. last position, no need to have a random start position for camera movement like LatLng(0,0)
* Navigation / PlacesAPI
* There are some things about the Maps plugin that are difficult to handle. Traffic layer for example does not repaint if it has not been set on creation time, even when in StreamBuilder.
