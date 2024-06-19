import Metrix
import Flutter

class SessionIdStreamHandler: NSObject, FlutterStreamHandler {
    private var sessionIdEventSink: FlutterEventSink? = nil

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sessionIdEventSink = events
        MetrixClient.setSessionIdListener { (sessionId: String) in
            self.sessionIdEventSink?(sessionId)
        }
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sessionIdEventSink = nil
        return nil
    }
}

class SessionNumberStreamHandler: NSObject, FlutterStreamHandler {
    private var sessionNumberEventSink: FlutterEventSink? = nil
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sessionNumberEventSink = events
        MetrixClient.setSessionNumberListener { (sessionNum: Int) in
            self.sessionNumberEventSink?(sessionNum)
        }
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sessionNumberEventSink = nil
        return nil
    }
}
