import Flutter
import UIKit
import PinchSDK
import PinchSDKLegacy

public class SwiftPinchPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.fluxloop.pinch/sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftPinchPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method: String = call.method

         if (method == "getStarted") {
            getStarted(result)
        } else if (method == "addCustomEvent") {
            addCustomEvent(result, with: call.arguments)
        } else if (method == "setMetadata") {
            setMetadata(result, with: call.arguments)
        } else if (method == "sendDemographicProfile") {
            sendDemographicProfile(result, with: call.arguments)
        } else if (method == "metric") {
            sendMetric(result, with: call.arguments)
        } else if (method == "setLogLevel") {
            result(true)
        } else if (method == "setMessagingId") {
            setMessagingId(result, with: call.arguments)
        } else if (method == "getPrivacyTermsUrl") {
            getPrivacyTermsUrl(result, with: call.arguments)
        } else if (method == "getPrivacyDashboard") {
            getPrivacyDashboard(result, with: call.arguments)
        } else if (method == "grant") {
            grant(result, with: call.arguments)
        } else if (method == "revoke") {
            revokeConsent(result, with: call.arguments)
        } else if (method == "deleteCollectedData") {
            deleteCollectedData(result, with: call.arguments)
        } else if (method == "getGrantedConsents") {
            getGrantedConsents(result, with: call.arguments)
        } else if (method == "getMessages") {
            getMessages(result, with: call.arguments)
        } else if (method == "getApiKey") {
            result(PinchSDKLegacy.Pinch.publisherId ?? "MISSING")
        } else if (method == "setAdid") {
            setAdid(result, with: call.arguments)
        } else if (method == "startBluetoothProvider") {
            PinchSDK.start(providers: [.bluetooth])
            result(true)
        } else if (method == "startMotionProvider") {
            PinchSDK.start(providers: [.motion])
            result(true)
        } else if (method == "startLocationProvider") {
            PinchSDK.start(providers: [.location])
            result(true)
        } else if (method == "stopBluetoothProvider") {
            PinchSDK.stop(providers: [.bluetooth])
            result(true)
        } else if (method == "stopMotionProvider") {
            PinchSDK.stop(providers: [.motion])
            result(true)
        } else if (method == "stopLocationProvider") {
            PinchSDK.stop(providers: [.location])
            result(true)
        } else if (method == "requestBluetoothPermission") {
            PinchSDK.requestBluetoothPermission()
            result(true)
        } else if (method == "requestMotionPermission") {
            PinchSDK.requestMotionPermission()
            result(true)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func getMessages(_ result: @escaping FlutterResult, with arguments: Any?) {
        PinchMessagingCenter.getMessages { (messages) in
            print("messages count: \(messages.count)" )
            print ("key: \(PinchSDK.getPrivaryDashboardUrl(for: .analytics))")
            var lines = [String]()
            for msg in messages {
                let url = msg.url ?? ""
                let expiry = msg.expiry
                let created = msg.created
                let title = msg.title ?? ""
                let body = msg.body ?? ""
                let imgUrl = msg.imgUrl ?? ""
                let deliveryId = msg.deliveryId ?? ""
                let messageId = msg.messageId ?? ""
                let opened = msg.opened

                let line = "{\"url\": \"\(url)\", \"expiry\": \(expiry), \"created\": \(created), \"title\": \"\(title)\", \"body\": \"\(body)\", \"imgUrl\": \"\(imgUrl)\", \"deliveryId\": \"\(deliveryId)\", \"messageId\": \"\(messageId)\", \"opened\": \(opened)}"

                lines.append(line)
            }
            let joined = lines.joined(separator: ", ")
            result("[\(joined)]")
        }
    }

    private func getGrantedConsents(_ result: @escaping FlutterResult, with arguments: Any?) {
        result(
            PinchSDK.grantedConsents.map { (consent) -> Int in
                switch consent {
                    case .analytics: return 1
                    case .surveys: return 2
                    case .campaigns: return 3
                    case .ads: return 4
                    default: return 0
                }
            }
        )
    }

    private func setAdid(_ result: @escaping FlutterResult, with arguments: Any?) {
        guard let args = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
            return
        }
        if let adid = args["adid"] as? String {
            PinchSDKLegacy.Pinch.adid = UUID(uuidString: adid)
        } else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
            return
        }
        result(true)
    }

    private func deleteCollectedData(_ result: @escaping FlutterResult, with arguments: Any?) {
        PinchSDK.deleteCollectedData { (success) in
            result(success)
        }
    }


    private func revokeConsent(_ result: @escaping FlutterResult, with arguments: Any?) {
        guard let args = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
            return
        }
        var success = true

        if let consentId = args["consentId"] as? Int {
            switch consentId {
            case 1: PinchSDK.revoke(consents: [.analytics]) { (scs) in success = scs}
                case 2: PinchSDK.revoke(consents: [.surveys]) { (scs) in success = scs}
                case 3: PinchSDK.revoke(consents: [.campaigns]) { (scs) in success = scs}
                case 4: PinchSDK.revoke(consents: [.ads]) { (scs) in success = scs}
                default: result(FlutterError(code: "INVALID_ARG", message: "Invalid consent supplied", details: nil))
            }
        } else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
        }
        result(success)
    }

    private func grant(_ result: @escaping FlutterResult, with arguments: Any?) {
        guard let args = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
            return
        }

        if let consentId = args["consentId"] as? Int {
            switch consentId {
                case 1: PinchSDK.grant(consents: [.analytics])
                case 2: PinchSDK.grant(consents: [.surveys])
                case 3: PinchSDK.grant(consents: [.campaigns])
                case 4: PinchSDK.grant(consents: [.ads])
                default: result(FlutterError(code: "INVALID_ARG", message: "Invalid consent supplied", details: nil))
            }
        } else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
        }
        result(true)
    }

    private func getPrivacyDashboard(_ result: @escaping FlutterResult) {
        result(PinchSDK.getPrivaryDashboardUrl())
    }

    private func getPrivacyTermsUrl(_ result: @escaping FlutterResult, with arguments: Any?) {
        result(PinchSDK.privacyTermsUrl)
    }

    private func setMessagingId(_ result: @escaping FlutterResult, with arguments: Any?) {
        guard let args = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
            return
        }

        if let messagingId = args["messagingId"] as? String {
            PinchSDK.messagingId = messagingId
            result(true)
        }
        result(false)
    }

    private func sendMetric(_ result: @escaping FlutterResult, with arguments: Any?) {
        guard let args = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
            return
        }

        var failed = false

        if let type = args["type"] as? Int, let action = args["action"] as? Int {
            // 1 == Onboarding
            let version = args["version"] as? String
            let requestType = args["requestType"] as? Int
            let accepted = args["accepted"] as? Bool

            if (type == 1) {
                switch action {
                    case 1:
                        if let _version = version {
                            PinchMetrics.Onboarding.notified(onboardingVersion: _version)
                        } else {
                            PinchMetrics.Onboarding.notified()
                        }
                    case 2:
                        PinchMetrics.Onboarding.notificationDismissed()
                    case 3:
                        if let _version = version {
                            PinchMetrics.Onboarding.started(onboardingVersion: _version)
                        } else {
                            PinchMetrics.Onboarding.started()
                        }
                    case 4:
                        if let _requestType = requestType, let _accepted = accepted {
                            if let _reqTypeEnum = getRequestType(for: _requestType) {
                                PinchMetrics.Onboarding.requestedPermission(requestType: _reqTypeEnum, accepted: _accepted)
                            }
                        }
                    case 5:
                        if let _requestType = requestType, let _accepted = accepted {
                            if let _reqTypeEnum = getRequestType(for: _requestType) {
                                PinchMetrics.Onboarding.requestedRuntimePermission(requestType: _reqTypeEnum, accepted: _accepted)
                            }
                        }
                    case 6:
                        PinchMetrics.Onboarding.cancelled()
                    case 7:
                        PinchMetrics.Onboarding.completed()
                default:
                    failed = true
                    break
                }
            }
        }

        result(!failed)
    }

    private func getRequestType(for int: Int) -> PinchMetrics.Onboarding.RequestType? {
        switch int {
        case 1:
            return PinchMetrics.Onboarding.RequestType.location
        case 2:
            return PinchMetrics.Onboarding.RequestType.wifi
        case 3:
            return PinchMetrics.Onboarding.RequestType.bluetooth
        case 4:
            return PinchMetrics.Onboarding.RequestType.motion
        case 5:
            return PinchMetrics.Onboarding.RequestType.notification
        case 6:
            return PinchMetrics.Onboarding.RequestType.surveys
        case 7:
            return PinchMetrics.Onboarding.RequestType.analytics
        case 8:
            return PinchMetrics.Onboarding.RequestType.campaigns
        case 9:
            return PinchMetrics.Onboarding.RequestType.ads
        case 10:
            return PinchMetrics.Onboarding.RequestType.birthYear
        case 11:
            return PinchMetrics.Onboarding.RequestType.gender
        case 12:
            return PinchMetrics.Onboarding.RequestType.pinch
        default:
            return nil
        }
    }


    private func sendDemographicProfile(_ result: @escaping FlutterResult, with arguments: Any?) {
        guard let args = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
            return
        }

        if let birthYear = args["birthYear"] as? Int, let gender = args["gender"] as? String {
            var dict = Dictionary<String, Any>()
            dict["birthYear"] = birthYear
            dict["gender"] = genderToInt(gender: gender)

            PinchSDK.setMetadata(type: "DemographicProfile", json: dict) { (success) in
                result(success)
            }
        } else {
            result(FlutterError(code: "INVALID_CONTENT", message: "Invalid content supplied", details: nil))
        }
    }


    private func setMetadata(_ result: @escaping FlutterResult, with arguments: Any?) {
        guard let args = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
            return
        }

        if let json = args["json"] as? String, let type = args["type"] as? String {
            if let dict = (convertToDictionary(json: json)) {
                PinchSDK.setMetadata(type: type, json: dict) { (success) in
                    result(success)
                }
            } else {
                result(FlutterError(code: "CAST_ERR", message: "Failed to cast arguments to [String: Any]", details: nil))
            }
        } else {
            result(FlutterError(code: "INVALID_CONTENT", message: "Invalid content supplied", details: nil))
        }
    }


    private func addCustomEvent(_ result: @escaping FlutterResult, with arguments: Any?) {
        guard let args = arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARG", message: "Invalid arguments supplied", details: nil))
            return
        }

        if let json = args["json"] as? String, let type = args["type"] as? String {
            if let dict = (convertToDictionary(json: json)) {
                PinchSDK.addCustomData(type: type, json: dict) { (success) in
                    result(success)
                }
            } else {
                result(FlutterError(code: "CAST_ERR", message: "Failed to cast arguments to [String: Any]", details: nil))
            }
        } else {
            result(FlutterError(code: "INVALID_CONTENT", message: "Invalid content supplied", details: nil))
        }
    }


    private func start(_ result: @escaping FlutterResult) {
        PinchSDK.start()
        result(true)
    }

    private func stop(_ result: @escaping FlutterResult) {
        PinchSDK.stop()
        result(false)
    }

    private func getStarted(_ result: @escaping FlutterResult) {
        PinchSDK.isTracking { (tracking) in
            result(tracking)
        }
    }





    private func convertToDictionary(json: String) -> [String: Any]? {
        if let data = json.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                //
            }
        }
        return nil
    }

    private func genderToInt(gender: String) -> Int {
        switch gender {
        case "male":
            return 1
        case "female":
            return 2
        default:
            return 0
        }
    }
}
