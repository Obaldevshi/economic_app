import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var savingsChannel: FlutterMethodChannel?
  private var pendingImpulse: Int?
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "not_spent/native",
      binaryMessenger: engineBridge.applicationRegistrar.messenger())
    savingsChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { result(nil); return }
      switch call.method {
      case "clearPersonalData":
        self.pendingImpulse = nil
        let group = Bundle.main.object(forInfoDictionaryKey: "SavingsAppGroup") as? String ?? ""
        if FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group) != nil,
            let defaults = UserDefaults(suiteName: group) {
          defaults.set("[]", forKey: "saving_items")
          if #available(iOS 14.0, *) { WidgetCenter.shared.reloadTimelines(ofKind: "SavingsWidget") }
        }
        result(nil)
      case "consumeTap":
        result(self.pendingImpulse)
        self.pendingImpulse = nil
      case "setWidgetLanguage":
        let group = Bundle.main.object(forInfoDictionaryKey: "SavingsAppGroup") as? String ?? ""
        guard FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group) != nil,
              let defaults = UserDefaults(suiteName: group),
              let labels = call.arguments as? [String: String] else {
          result(FlutterError(code: "widget_group", message: "Shared App Group unavailable", details: nil)); return
        }
        for (key, value) in labels { defaults.set(value, forKey: "saving_" + key) }
        if #available(iOS 14.0, *) { WidgetCenter.shared.reloadTimelines(ofKind: "SavingsWidget") }
        result(nil)
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
        guard let presenter = self.presentingController() else {
          result(FlutterError(code: "receipt_export", message: "No active application window", details: nil)); return
        }
        sheet.popoverPresentationController?.sourceView = presenter.view
        sheet.popoverPresentationController?.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 1, height: 1)
        presenter.present(sheet, animated: true)
        result(nil)
      default: result(FlutterMethodNotImplemented)
      }
    }
  }

  private func presentingController() -> UIViewController? {
    let window = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    guard var presenter = window?.rootViewController else { return nil }
    while let presented = presenter.presentedViewController { presenter = presented }
    return presenter
  }

  private func impulseId(_ url: URL) -> Int? {
    guard url.scheme == "notspent", url.host == "saving",
          let text = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "id" })?.value,
          let id = Int(text), id > 0 else { return nil }
    return id
  }

  func handleSavingsURL(_ url: URL) -> Bool {
    if let id = impulseId(url) {
      pendingImpulse = id
      savingsChannel?.invokeMethod("quickSaving", arguments: id, result: { [weak self] reply in
        if reply == nil && self?.pendingImpulse == id { self?.pendingImpulse = nil }
      })
      return true
    }
    return false
  }

  override func application(_ app: UIApplication, open url: URL,
      options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if handleSavingsURL(url) { return true }
    return super.application(app, open: url, options: options)
  }
}
