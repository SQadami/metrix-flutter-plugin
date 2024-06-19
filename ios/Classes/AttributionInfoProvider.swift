import Metrix
import Flutter

class AttributionInfoStreamHandler: NSObject, FlutterStreamHandler {
    private var attributionInfoEventSink: FlutterEventSink? = nil

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        attributionInfoEventSink = events
        MetrixClient.setOnAttributionChangedListener { (data: AttributionData) in
            var attributionDataMap: [String: String] = [:]

            if (data.acquisitionAd != nil) {
                attributionDataMap["acquisitionAd"] = data.acquisitionAd
            }
            if (data.acquisitionAdSet != nil) {
                attributionDataMap["acquisitionAdSet"] = data.acquisitionAdSet
            }
            if (data.acquisitionCampaign != nil) {
                attributionDataMap["acquisitionCampaign"] = data.acquisitionCampaign
            }
            if (data.acquisitionSource != nil) {
                attributionDataMap["acquisitionSource"] = data.acquisitionSource
            }
            if (data.acquisitionSubId != nil) {
                attributionDataMap["acquisitionSubId"] = data.acquisitionSubId
            }
            attributionDataMap["attributionStatus"] = data.attributionStatus.rawValue

            self.attributionInfoEventSink?(attributionDataMap)
        }

        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        attributionInfoEventSink = nil
        return nil
    }
}
