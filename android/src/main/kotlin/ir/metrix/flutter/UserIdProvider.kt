package ir.metrix.flutter

import io.flutter.plugin.common.EventChannel
import ir.metrix.attribution.UserIdListener

class UserIdReader: EventChannel.StreamHandler {
    private var userIdEventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        userIdEventSink = events
        ir.metrix.attribution.MetrixAttribution.setUserIdListener(
            object : UserIdListener {
                override fun onUserIdReceived(userId: String) {
                    userIdEventSink?.success(userId)
                }
            })
    }

    override fun onCancel(arguments: Any?) {
        userIdEventSink = null
    }
}