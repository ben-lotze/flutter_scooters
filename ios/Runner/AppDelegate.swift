import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Maps API key is restricted and only work on iOS
    GMSServices.provideAPIKey("AIzaSyBD4e51pwVFEcY70fi-Xl_BasmnPSJHow8")      // iOS
    //GMSServices.provideAPIKey("AIzaSyBRCGOZ1Cqb7W6kt7jX7GNrs2Or9_hNPlw")           // Android
    //GMSPlacesClient.provideAPIKey("AIzaSyBD4e51pwVFEcY70fi-Xl_BasmnPSJHow8")      // TODO: does not work, update? GMSPlacesApi?
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
