# Circ Flutter Challenge

Challenge app to be hired at Circ.

## To get this up and running

* Google maps API keys are not provided inside this repository. They have to be inserted into Gradle.
* Integration tests: Due to limitations in Flutter framework the permissions need to be granted on test startup.
* Integration tests can be started with **`flutter drive --target=test_driver/app.dart`** from the project directory.


## Technical details
* UI and business logic are decoupled by using the BLoC pattern.
* Targeting Android API level >= 16



## Additionally implemented features

#### Platform specific launcher icons
<img src="readme_resources/launcher_ios.png" width="100"/>   <img src="readme_resources/launcher_android.png" width="100"/>

<i>iOS left, Android right</i>

#### QR code scanner

Scanning a QR code opens the info popup to unlock the vehicle:
<img src="readme_resources/scanner_button.gif" width="360"/>   <img src="readme_resources/scanner_opens_info_popup.gif" width="360"/> 

Scan any of these QR codes to simulate scanning a scooter (vehicles 1-6):

<img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-1.png" width="250" style="border:10;">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-2.png" width="250">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-3.png" width="250">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-4.png" width="250">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-5.png" width="250">   <img src="readme_resources/vehicle_qr_codes/qrcode-vehicle-id-6.png" width="250">   

<i>Camera is not working in iOS <b>simulator</b> as the simulator has no camera support.</i>


#### Custom swipe to confirm button
* At first I made on myself based on Draggable and DragDestination. This did not bring the desired result since the horizontal movement could not be constrained and teh draggable could be dragged outside of the slider borders.
* Then I tried two libraries and was not satisfied with them. So I made my own.
* I will publish this custom drag-to-confirm widget soon as package (after some adjustments and cleanups). 



#### Map types



#### User manual



#### Some more screenshots
<img src="readme_resources/selecting_markers_360.gif" width="360"/>





## Getting Started

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
