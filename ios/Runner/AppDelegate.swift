import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // ✅ Initialize Firebase
    FirebaseApp.configure()
    
    // ✅ Set UNUserNotificationCenter delegate (to handle notifications in foreground)
    UNUserNotificationCenter.current().delegate = self
    
    // ✅ Register for remote notifications
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
