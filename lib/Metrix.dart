import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'MetrixAttribution.dart';

import 'dart:io' show Platform;

class Metrix {

  static var shouldLaunchDeeplink = true;

  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isWeb => kIsWeb;

  static const MethodChannel _channel = const MethodChannel('Metrix');
  static EventChannel? _sessionIdEventChannel;
  static EventChannel? _sessionNumEventChannel;
  
  static EventChannel? _userIdEventChannel;

  static EventChannel? _attributionInfoEventChannel;

  static void initialize(String appId) {
    if (isIOS) {
      _channel.invokeMethod('initialize', {
        'appId': appId
      });
    }
  }

  static void newEvent(String slug, [Map<String, String> attributes = const {}]) {
    if (!isWeb) {
      _channel.invokeMethod('newEvent', {
        'slug': slug,
        'attributes': attributes,
      });
    }
  }

  static void setUserAttributes(Map<String, String> attributes) {
    if (!isWeb) {
      _channel.invokeMethod('setUserAttributes', {
        'attributes': attributes
      });
    }
  }

  static void newRevenue(String slug, double amount, {int currency = 0, String? orderId}) {
    if (!isWeb) {
      _channel.invokeMethod('newRevenue', {
        'slug': slug,
        'amount': amount,
        'currency': currency,
        'orderId': orderId
      });
    }
  }

  static void setPushToken(String token) {
    if (isAndroid) {
      _channel.invokeMethod('setPushToken', {
        'token': token
      });
    }
  }

  static void setUserCustomId(String id) {
    if (isAndroid) {
      _channel.invokeMethod('setUserCustomId', {
        'id': id
      });
    }
  }

  static void deleteUserCustomId() {
    if (isAndroid) {
      _channel.invokeMethod('deleteUserCustomId', {});
    }
  }

  static void setUserFirstName(String firstName) {
    if (isAndroid) {
      _channel.invokeMethod('setUserFirstName', {
        'firstName': firstName
      });
    }
  }

  static void setUserLastName(String lastName) {
    if (isAndroid) {
      _channel.invokeMethod('setUserLastName', {
        'lastName': lastName
      });
    }
  }

  static void setUserPhoneNumber(String phoneNumber) {
    if (isAndroid) {
      _channel.invokeMethod('setUserPhoneNumber', {
        'phoneNumber': phoneNumber
      });
    }
  }

  static void setUserHashedPhoneNumber(String hashedPhoneNumber) {
    if (isAndroid) {
      _channel.invokeMethod('setUserHashedPhoneNumber', {
        'hashedPhoneNumber': hashedPhoneNumber
      });
    }
  }

  static void setUserEmail(String email) {
    if (isAndroid) {
      _channel.invokeMethod('setUserEmail', {
        'email': email
      });
    }
  }

  static void setUserHashedEmail(String hashedEmail) {
    if (isAndroid) {
      _channel.invokeMethod('setUserHashedEmail', {
        'hashedEmail': hashedEmail
      });
    }
  }

  static void setUserCountry(String country) {
    if (isAndroid) {
      _channel.invokeMethod('setUserCountry', {
        'country': country
      });
    }
  }

  static void setUserCity(String city) {
    if (isAndroid) {
      _channel.invokeMethod('setUserCity', {
        'city': city
      });
    }
  }

  static void setUserRegion(String region) {
    if (isAndroid) {
      _channel.invokeMethod('setUserRegion', {
        'region': region
      });
    }
  }

  static void setUserLocality(String locality) {
    if (isAndroid) {
      _channel.invokeMethod('setUserLocality', {
        'locality': locality
      });
    }
  }

  static void setUserGender(String gender) {
    if (isAndroid) {
      _channel.invokeMethod('setUserGender', {
        'gender': gender
      });
    }
  }

  static void setUserBirthday(double birthday) {
    if (isAndroid) {
      _channel.invokeMethod('setUserBirthday', {
        'birthday': birthday
      });
    }
  }

  static void userChannelEnabled(String channel) {
    if (isAndroid) {
      _channel.invokeMethod('userChannelEnabled', {
        'channel': channel
      });
    }
  }

  static void userChannelDisabled(String channel) {
    if (isAndroid) {
      _channel.invokeMethod('userChannelDisabled', {
        'channel': channel
      });
    }
  }

  static void setStore(String store) {
    if (isIOS) {
      _channel.invokeMethod('setStore', {
        'store': store
      });
    }
  }

  static void setDefaultTracker(String token) {
    if (isIOS) {
      _channel.invokeMethod('setDefaultTracker', {
        'token': token
      });
    }
  }

  static void setAppSecret(int id, int info1, int info2, int info3, int info4) {
    if (isIOS) {
      _channel.invokeMethod('setAppSecret', {
        'id': id,
        'info1': info1,
        'info2': info2,
        'info3': info3,
        'info4': info4
      });
    }
  }

  static Stream<int> getSessionNumber() async* {
      if (!isWeb) {
        _channel.invokeMethod('initSessionNumListener');
        _sessionNumEventChannel ??= const EventChannel('MetrixSessionNumEvent');
        yield* _sessionNumEventChannel?.receiveBroadcastStream().asyncMap<int>((sessionNum) => sessionNum) ?? Stream.empty();
      } else {
        yield* Stream.empty();
      }
  }

  static Stream<String> getSessionId() async* {
    if (!isWeb) {
      _channel.invokeMethod('initSessionIdListener');
      _sessionIdEventChannel ??= const EventChannel('MetrixSessionIdEvent');
      yield* _sessionIdEventChannel?.receiveBroadcastStream().cast() ?? Stream.empty();
    } else {
      yield* Stream.empty();
    }
  }

  static Stream<String> getUserId() async* {
    if (!isWeb) {
      _channel.invokeMethod('initUserIdListener');
      _userIdEventChannel ??= const EventChannel('MetrixUserIdEvent');
      yield* _userIdEventChannel?.receiveBroadcastStream().cast() ?? Stream.empty();
    } else {
      yield* Stream.empty();
    }
  }

  static Stream<MetrixAttribution> getAttributionData() async* {
    if (!isWeb) {
      _channel.invokeMethod('initAttributionListener');
      _attributionInfoEventChannel ??= const EventChannel('MetrixAttributionEvent');
      yield* _attributionInfoEventChannel?.receiveBroadcastStream().map((attribution) => MetrixAttribution.fromMap(attribution)) ?? Stream.empty();
    } else {
      yield* Stream.empty();
    }
  }

  static void setShouldLaunchDeeplink(bool shouldLaunch) {
    shouldLaunchDeeplink = shouldLaunch;
  }

  static Future<String> getDeeplinkResponse() async {
    if (isAndroid) {
      final String deeplink = await _channel.invokeMethod('getDeeplinkResponse', {
        'shouldLaunchDeeplink': shouldLaunchDeeplink
      });
      return deeplink;
    } else {
      return "";
    }
  }
}
