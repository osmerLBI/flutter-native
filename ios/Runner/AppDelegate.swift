import UIKit
import Flutter
import SwiftUI
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAuO8mUUuV-Uvm-QsOhfupKqb9mT0sGalY")
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
    // let controller : FlutterViewController = window?.rootViewController as! FlutterViewController 
    // let deviceChannel = FlutterMethodChannel(name: "test.connect.methodchannel/iOS",
    //                                              binaryMessenger: controller.binaryMessenger) 
    // prepareMethodHandler(deviceChannel: deviceChannel)
    weak var registrar = self.registrar(forPlugin: "plugin-name")
    let factory = FLNativeViewFactory(messenger: registrar!.messenger())
        self.registrar(forPlugin: "<plugin-name>")!.register(
            factory,
            withId: "<platform-view-type>")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
        
  //       deviceChannel.setMethodCallHandler({
  //           (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
  //            if call.method == "checkTest" {
  //               result("Sample return")
  //               return
  //           }
  //       })
  //   }
}
