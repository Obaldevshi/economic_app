import XCTest
@testable import Runner

final class RunnerTests: XCTestCase {
  func testProductionIdentityAndAppGroup() {
    let bundle = Bundle(for: AppDelegate.self)
    XCTAssertEqual(bundle.bundleIdentifier, "app.obaldevshi.notspent")
    XCTAssertEqual(bundle.object(forInfoDictionaryKey: "SavingsAppGroup") as? String,
                   "group.app.obaldevshi.notspent.savings")
  }

  func testPrivacyManifestIsBundledAndDoesNotDeclareTracking() throws {
    let bundle = Bundle(for: AppDelegate.self)
    let url = try XCTUnwrap(bundle.url(forResource: "PrivacyInfo", withExtension: "xcprivacy"))
    let data = try Data(contentsOf: url)
    let manifest = try XCTUnwrap(try PropertyListSerialization.propertyList(
      from: data, options: [], format: nil) as? [String: Any])
    XCTAssertEqual(manifest["NSPrivacyTracking"] as? Bool, false)
    let apis = try XCTUnwrap(manifest["NSPrivacyAccessedAPITypes"] as? [[String: Any]])
    XCTAssertTrue(apis.contains { $0["NSPrivacyAccessedAPIType"] as? String ==
      "NSPrivacyAccessedAPICategoryUserDefaults" })
  }

  func testSceneLifecycleConfigurationResolvesToBundledDelegate() throws {
    let bundle = Bundle(for: AppDelegate.self)
    let manifest = try XCTUnwrap(bundle.object(
      forInfoDictionaryKey: "UIApplicationSceneManifest") as? [String: Any])
    XCTAssertEqual(manifest["UIApplicationSupportsMultipleScenes"] as? Bool, false)
    let configurations = try XCTUnwrap(manifest["UISceneConfigurations"] as? [String: Any])
    let scenes = try XCTUnwrap(configurations["UIWindowSceneSessionRoleApplication"] as? [[String: Any]])
    let scene = try XCTUnwrap(scenes.first)
    let delegate = try XCTUnwrap(scene["UISceneDelegateClassName"] as? String)
    XCTAssertTrue(delegate.hasSuffix(".SceneDelegate"))
    XCTAssertNotNil(NSClassFromString(delegate))
    XCTAssertEqual(scene["UISceneStoryboardFile"] as? String, "Main")
  }

  func testWidgetLinksOnlyAcceptPositiveSavingsIdentifiers() {
    let delegate = AppDelegate()
    XCTAssertTrue(delegate.handleSavingsURL(URL(string: "notspent://saving?id=42")!))
    for value in ["notspent://saving?id=0", "notspent://saving?id=-1",
                  "notspent://saving?id=invalid", "notspent://saving",
                  "https://saving?id=42", "notspent://other?id=42"] {
      XCTAssertFalse(delegate.handleSavingsURL(URL(string: value)!))
    }
  }
}
