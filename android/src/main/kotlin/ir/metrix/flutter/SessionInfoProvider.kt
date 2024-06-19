package ir.metrix.flutter

import io.flutter.plugin.common.EventChannel
import ir.metrix.analytics.SessionIdListener
import ir.metrix.analytics.SessionNumberListener

class SessionIdReader: EventChannel.StreamHandler {
    private var sessionIdEventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sessionIdEventSink = events
        ir.metrix.analytics.MetrixAnalytics.setSessionIdListener(object : SessionIdListener {
            override fun onSessionIdChanged(sessionId: String) {
                sessionIdEventSink?.success(sessionId)
            }
        })
    }

    override fun onCancel(arguments: Any?) {
        sessionIdEventSink = null
    }
}

class SessionNumReader: EventChannel.StreamHandler {
    private var sessionNumEventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sessionNumEventSink = events
        ir.metrix.analytics.MetrixAnalytics.setSessionNumberListener(
            object : SessionNumberListener {
                override fun onSessionNumberChanged(sessionNumber: Int) {
                    sessionNumEventSink?.success(sessionNumber)
                }
            })
    }

    override fun onCancel(arguments: Any?) {
        sessionNumEventSink = null
    }
}