
import Flutter
import UIKit
import Metrix

public class SwiftMetrixPlugin: NSObject, FlutterPlugin {

    private static var messenger: FlutterBinaryMessenger? = nil
    private var userIdEventChannel: FlutterEventChannel? = nil
    private var sessionIdEventChannel: FlutterEventChannel? = nil
    private var sessionNumberEventChannel: FlutterEventChannel? = nil

    private var attributionEventChannel: FlutterEventChannel? = nil

    public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "Metrix", binaryMessenger: registrar.messenger())
    let instance = SwiftMetrixPlugin()
    messenger = registrar.messenger()
    registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "initialize":
                guard let args = call.arguments as? [String: Any] else { return }
                guard let appId = args["appId"] as? String else { return }
                MetrixClient.initialize(metrixAppId: appId)
                    
            case "newEvent":
                guard let args = call.arguments as? [String: Any] else { return }
                let slug = args["slug"] as? String ?? ""
                let attributes = args["attributes"] as? [String: String] ?? [:]
                MetrixClient.newEvent(slug: slug, attributes: attributes)

            case "addUserAttributes":
                guard let args = call.arguments as? [String: Any] else { return }
                let attributes = args["attributes"] as? [String: String] ?? [:]
                MetrixClient.addUserAttributes(userAttrs: attributes)

            case "newRevenue":
                guard let args = call.arguments as? [String: Any] else { return }
                let slug = args["slug"] as? String ?? ""
                let amount = args["amount"] as? Double ?? 0.0
                let currency = args["currency"] as? Int ?? 0
                let orderId = args["orderId"] as? String
                var revenueCurrency: RevenueCurrency = .IRR
                if (currency == 1) { revenueCurrency = .USD }
                if (currency == 2) { revenueCurrency = .EUR }
                MetrixClient.newRevenue(slug: slug, revenue: amount, currency: revenueCurrency, orderId: orderId)

            case "initAttributionListener":
                guard let binaryMessenger = SwiftMetrixPlugin.messenger else { return }
                attributionEventChannel = FlutterEventChannel(name: "MetrixAttributionEvent", binaryMessenger: binaryMessenger)
                attributionEventChannel?.setStreamHandler(AttributionInfoStreamHandler())
            
            case "initUserIdListener":
                guard let binaryMessenger = SwiftMetrixPlugin.messenger else { return }
                userIdEventChannel = FlutterEventChannel(name: "MetrixUserIdEvent", binaryMessenger: binaryMessenger)
                userIdEventChannel?.setStreamHandler(UserIdStreamHandler())

            case "initSessionIdListener":
                guard let binaryMessenger = SwiftMetrixPlugin.messenger else { return }
                sessionIdEventChannel = FlutterEventChannel(name: "MetrixSessionIdEvent", binaryMessenger: binaryMessenger)
                sessionIdEventChannel?.setStreamHandler(SessionIdStreamHandler())

            case "initSessionNumListener":
                guard let binaryMessenger = SwiftMetrixPlugin.messenger else { return }
                sessionNumberEventChannel = FlutterEventChannel(name: "MetrixSessionNumEvent", binaryMessenger: binaryMessenger)
                sessionNumberEventChannel?.setStreamHandler(SessionNumberStreamHandler())

            case "setStore":
                guard let args = call.arguments as? [String: Any] else { return }
                guard let store = args["store"] as? String else { return }
                MetrixClient.setStore(storeName: store)
            
            case "setDefaultTracker":
                guard let args = call.arguments as? [String: Any] else { return }
                guard let token = args["token"] as? String else { return }
                MetrixClient.setDefaultTracker(trackerToken: token)

            case "setAppSecret":
                guard let args = call.arguments as? [String: Any] else { return }
                guard let id = args["id"] as? Int else { return }
                guard let info1 = args["info1"] as? Int else { return }
                guard let info2 = args["info2"] as? Int else { return }
                guard let info3 = args["info3"] as? Int else { return }
                guard let info4 = args["info4"] as? Int else { return }
                MetrixClient.setAppSecret(secretId: id, info1: info1, info2: info2, info3: info3, info4: info4)

            default: result(FlutterMethodNotImplemented)
        }
    }
}
