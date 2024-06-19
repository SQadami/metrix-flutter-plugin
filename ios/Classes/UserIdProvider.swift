import Metrix
import Flutter

class UserIdStreamHandler: NSObject, FlutterStreamHandler {
    private var userIdEventSink: FlutterEventSink? = nil

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        userIdEventSink = events
        MetrixClient.setUserIdListener { (userId: String) in
            self.userIdEventSink?(userId)
        }
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        userIdEventSink = nil
        return nil
    }
}