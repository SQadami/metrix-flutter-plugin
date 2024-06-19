package ir.metrix.flutter

import android.net.Uri
import android.util.Log
import org.jetbrains.annotations.NotNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import ir.metrix.attribution.OnDeeplinkResponseListener
import ir.metrix.analytics.messaging.RevenueCurrency
import ir.metrix.analytics.messaging.MessageChannel
import ir.metrix.analytics.messaging.UserGender

import java.util.HashMap

/**
 * MetrixSDKFlutterPlugin
 */
class Metrix : FlutterPlugin, MethodChannel.MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var binaryMessengerInstance: BinaryMessenger

    private val sessionIdEvent: EventChannel by lazy { EventChannel(binaryMessengerInstance, "MetrixSessionIdEvent") }
    private val sessionNumEvent: EventChannel by lazy { EventChannel(binaryMessengerInstance, "MetrixSessionNumEvent") }
    private val userIdEvent: EventChannel by lazy { EventChannel(binaryMessengerInstance, "MetrixUserIdEvent") }
    private val attributionInfoEvent: EventChannel by lazy { EventChannel(binaryMessengerInstance, "MetrixAttributionEvent") }

    private val sessionIdReader: SessionIdReader by lazy { SessionIdReader() }
    private val sessionNumReader: SessionNumReader by lazy { SessionNumReader() }
    private val userIdReader: UserIdReader by lazy { UserIdReader() }
    private val attributionInfoStreamHandler: AttributionInfoStreamHandler by lazy { AttributionInfoStreamHandler() }

    override fun onAttachedToEngine(@NotNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessengerInstance = flutterPluginBinding.binaryMessenger
        channel = MethodChannel(binaryMessengerInstance, "Metrix")
        channel.setMethodCallHandler(this)

        initEventChannels()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "newEvent" -> {
                val slug = call.argument<String>("slug") ?: ""
                val attr =
                    call.argument<Map<String, String>>("attributes") ?: mapOf<String, String>()
                ir.metrix.analytics.MetrixAnalytics.newEvent(slug, attr)
            }
            "setUserAttributes" -> {
                val attr =
                    call.argument<Map<String, String>>("attributes") ?: mapOf<String, String>()
                for (entry in attr.entries) {
                    ir.metrix.analytics.MetrixAnalytics.User.setCustomAttribute(
                        entry.key,
                        entry.value
                    )
                }
            }
            "initSessionIdListener" -> {
                sessionIdEvent.setStreamHandler(sessionIdReader)
            }
            "initSessionNumListener" -> {
                sessionNumEvent.setStreamHandler(sessionNumReader)
            }
            "initUserIdListener" -> {
                userIdEvent.setStreamHandler(userIdReader)
            }
            "newRevenue" -> {
                val slug = call.argument<String>("slug") ?: ""
                val amount = call.argument<Double>("amount") ?: 0.0
                val currency = call.argument<Int>("currency")
                var revenueCurrency = RevenueCurrency.IRR
                if (currency != null && currency == 1) revenueCurrency = RevenueCurrency.USD
                if (currency != null && currency == 2) revenueCurrency = RevenueCurrency.EUR
                ir.metrix.analytics.MetrixAnalytics.newRevenue(slug, amount, revenueCurrency)
            }
            "setPushToken" -> {
                val token = call.argument<String>("token")
                if (token != null) {
                    ir.metrix.attribution.MetrixAttribution.setPushToken(token)
                }
            }
            "initAttributionListener" -> {
                attributionInfoEvent.setStreamHandler(attributionInfoStreamHandler)
            }
            "getDeeplinkResponse" -> {
                val shouldLaunchDeeplink = call.argument<Boolean>("shouldLaunchDeeplink") ?: false
                ir.metrix.attribution.MetrixAttribution.setOnDeeplinkResponseListener(
                    object : OnDeeplinkResponseListener {
                        override fun launchReceivedDeeplink(deeplink: Uri): Boolean {
                            result.success(deeplink.toString())
                            return shouldLaunchDeeplink
                        }
                    })
            }
            "setUserCustomId" -> {
                val id = call.argument<String>("id")
                if (id == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setUserCustomId(id)
            }
            "deleteUserCustomId" -> {
                ir.metrix.analytics.MetrixAnalytics.User.deleteUserCustomId()
            }
            "setUserFirstName" -> {
                val firstName = call.argument<String>("firstName")
                if (firstName == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setFirstName(firstName)
            }
            "setUserLastName" -> {
                val lastName = call.argument<String>("lastName")
                if (lastName == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setLastName(lastName)
            }
            "setUserPhoneNumber" -> {
                val phoneNumber = call.argument<String>("phoneNumber")
                if (phoneNumber == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setPhoneNumber(phoneNumber)
            }
            "setUserHashedPhoneNumber" -> {
                val hashedPhoneNumber = call.argument<String>("hashedPhoneNumber")
                if (hashedPhoneNumber == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setHashedPhoneNumber(hashedPhoneNumber)
            }
            "setUserEmail" -> {
                val email = call.argument<String>("email")
                if (email == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setEmail(email)
            }
            "setUserHashedEmail" -> {
                val hashedEmail = call.argument<String>("hashedEmail")
                if (hashedEmail == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setHashedEmail(hashedEmail)
            }
            "setUserCountry" -> {
                val country = call.argument<String>("country")
                if (country == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setCountry(country)
            }
            "setUserCity" -> {
                val city = call.argument<String>("city")
                if (city == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setCity(city)
            }
            "setUserRegion" -> {
                val region = call.argument<String>("region")
                if (region == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setRegion(region)
            }
            "setUserLocality" -> {
                val locality = call.argument<String>("locality")
                if (locality == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setLocality(locality)
            }
            "setUserGender" -> {
                val gender = call.argument<String>("gender")
                if (gender == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setGender(UserGender.valueOf(gender))
            }
            "setUserBirthday" -> {
                val birthday = call.argument<Double>("birthday")
                if (birthday == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setBirthday(birthday.toLong())
            }
            "userChannelEnabled" -> {
                val channel = call.argument<String?>("channel")
                if (channel == null) return
                ir.metrix.analytics.MetrixAnalytics.User.channelEnabled(MessageChannel.valueOf(channel))
            }
            "userChannelDisabled" -> {
                val channel = call.argument<String?>("channel")
                if (channel == null) return
                ir.metrix.analytics.MetrixAnalytics.User.channelDisabled(MessageChannel.valueOf(channel))
            }
            "setPushToken" -> {
                val fcmToken = call.argument<String>("token")
                if (fcmToken == null) return
                ir.metrix.analytics.MetrixAnalytics.User.setFcmToken(fcmToken);
                ir.metrix.attribution.MetrixAttribution.setPushToken(fcmToken);
            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun initEventChannels() {
        sessionIdEvent.setStreamHandler(sessionIdReader)
        sessionNumEvent.setStreamHandler(sessionNumReader)
        userIdEvent.setStreamHandler(userIdReader)
        attributionInfoEvent.setStreamHandler(attributionInfoStreamHandler)
    }

    enum class LogLevel {
        INFO, DEBUG, VERBOSE, WARNING, ERROR
    }

    private fun log(message: String, logLevel: LogLevel) {
        log(message, null, logLevel);
    }

    private fun log(message: String, tr: Throwable?, logLevel: LogLevel) {
        if (!isDebugging) {
            return
        }

        when (logLevel) {
            LogLevel.INFO -> Log.i(TAG, message, tr)
            LogLevel.DEBUG -> Log.d(TAG, message, tr)
            LogLevel.WARNING -> Log.w(TAG, message, tr)
            LogLevel.ERROR -> Log.e(TAG, message, tr)
            LogLevel.VERBOSE -> Log.v(TAG, message, tr)
        }
    }
}

private const val TAG = "MetrixFlutterPlugin"
private const val isDebugging = false