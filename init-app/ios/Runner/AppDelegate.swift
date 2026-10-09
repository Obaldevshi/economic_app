import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var savingsChannel: FlutterMethodChannel?
  private var pendingImpulse: Int?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let url = launchOptions?[.url] as? URL { pendingImpulse = impulseId(url) }
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "not_spent/native", binaryMessenger: controller.binaryMessenger)
      savingsChannel = channel
      channel.setMethodCallHandler { [weak self] call, result in
        guard let self = self else { result(nil); return }
        switch call.method {
        case "consumeTap":
          result(self.pendingImpulse)
          self.pendingImpulse = nil
        case "syncWidget":
          let group = Bundle.main.object(forInfoDictionaryKey: "SavingsAppGroup") as? String ?? ""
          guard FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group) != nil,
                let defaults = UserDefaults(suiteName: group) else {
            result(FlutterError(code: "widget_group", message: "Configure the shared App Group in Xcode", details: nil)); return
          }
          defaults.set(call.arguments as? String ?? "[]", forKey: "saving_items")
          if #available(iOS 14.0, *) { WidgetCenter.shared.reloadTimelines(ofKind: "SavingsWidget") }
          result(nil)
        case "shareReceipt":
          guard let bytes = call.arguments as? FlutterStandardTypedData,
                let image = UIImage(data: bytes.data) else {
            result(FlutterError(code: "receipt_export", message: "Invalid PNG", details: nil)); return
          }
          let sheet = UIActivityViewController(activityItems: [image], applicationActivities: nil)
          // Sharing does not request access to the user's photo library.
          sheet.excludedActivityTypes = [.saveToCameraRoll]
          var presenter: UIViewController = controller
          while let presented = presenter.presentedViewController { presenter = presented }
          sheet.popoverPresentationController?.sourceView = presenter.view
          sheet.popoverPresentationController?.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 1, height: 1)
          presenter.present(sheet, animated: true)
          result(nil)
        default: result(FlutterMethodNotImplemented)
        }
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func impulseId(_ url: URL) -> Int? {
    guard url.scheme == "notspent", url.host == "saving",
          let text = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "id" })?.value,
          let id = Int(text), id > 0 else { return nil }
    return id
  }

  override func application(_ app: UIApplication, open url: URL,
      options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if let id = impulseId(url) {
      pendingImpulse = id
      savingsChannel?.invokeMethod("quickSaving", arguments: id, result: { [weak self] reply in
        if reply == nil && self?.pendingImpulse == id { self?.pendingImpulse = nil }
      })
      return true
    }
    return super.application(app, open: url, options: options)
  }
}
