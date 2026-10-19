import Flutter
import UIKit

/// Scene callbacks own both cold and warm widget links on modern iOS.
class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    let delegate = UIApplication.shared.delegate as? AppDelegate
    for context in connectionOptions.urlContexts {
      _ = delegate?.handleSavingsURL(context.url)
    }
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    let delegate = UIApplication.shared.delegate as? AppDelegate
    let unhandled = Set(URLContexts.filter { delegate?.handleSavingsURL($0.url) != true })
    if !unhandled.isEmpty {
      super.scene(scene, openURLContexts: unhandled)
    }
  }
}
