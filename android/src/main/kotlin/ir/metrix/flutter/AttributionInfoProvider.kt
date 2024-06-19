package ir.metrix.flutter

import io.flutter.plugin.common.EventChannel
import ir.metrix.attribution.OnAttributionChangeListener
import ir.metrix.attribution.AttributionData

class AttributionInfoStreamHandler : EventChannel.StreamHandler {
    private var attributionInfoEventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        attributionInfoEventSink = events
        ir.metrix.attribution.MetrixAttribution.setOnAttributionChangedListener(
            object : OnAttributionChangeListener {
                override fun onAttributionChanged(attributionData: AttributionData) {
                    val attributionDataMap: Map<String, String> = mapOf(
                        "acquisitionAd" to (attributionData.acquisitionAd ?: ""),
                        "acquisitionAdSet" to (attributionData.acquisitionAdSet ?: ""),
                        "acquisitionCampaign" to (attributionData.acquisitionCampaign ?: ""),
                        "acquisitionSource" to (attributionData.acquisitionSource ?: ""),
                        "acquisitionSubId" to (attributionData.acquisitionSubId ?: ""),
                        "attributionStatus" to (attributionData.attributionStatus?.name ?: "")
                    )
                    
                    attributionInfoEventSink?.success(attributionDataMap)
                }
            })
    }

    override fun onCancel(arguments: Any?) {
        attributionInfoEventSink = null
    }
}