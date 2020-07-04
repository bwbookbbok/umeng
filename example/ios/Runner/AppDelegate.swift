import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    UmengHelperIos.iosInit(launchOptions, appkey: "5ee8cee4dbc2ec081340b594", channel:"appstore", logEnabled:false, pushEnabled:true);
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
