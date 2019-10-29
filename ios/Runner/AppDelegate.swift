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
    GMSServices.provideAPIKey("AIzaSyBD4e51pwVFEcY70fi-Xl_BasmnPSJHow8")
    GMSPlacesClient.provideAPIKey("AIzaSyBD4e51pwVFEcY70fi-Xl_BasmnPSJHow8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
