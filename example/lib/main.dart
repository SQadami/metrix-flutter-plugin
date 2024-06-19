import 'package:flutter/material.dart';
import 'package:metrix_analytics/Metrix.dart';
import 'package:metrix_analytics/MetrixAttribution.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String sessionNumber = "";
  String sessionId = "";
  String userId = "";
  String deeplink = "";
  MetrixAttribution? attribution;

  @override
  void initState() {
    super.initState();

    setState(() {
      sessionNumber = "";
      sessionId = "";
      userId = "";
      deeplink = "";
      attribution = null;
    });

    // iOS only
    Metrix.initialize('lcqmfsnvhzznvhe');

    Metrix.setUserAttributes({"name": "hisName"});

    Metrix.setUserCustomId("flutter"); // call when user tries to login in your system and set userId value that user already knows in your system
    // Metrix.deleteUserCustomId(); // call when your user goes to logout in your system
    Metrix.setUserFirstName("userFirstName");
    Metrix.setUserLastName("userLastName");
    Metrix.setUserPhoneNumber("phoneNumber");
    Metrix.setUserHashedPhoneNumber("hashedPhoneNumber");
    Metrix.setUserEmail("email");
    Metrix.setUserHashedEmail("hashedEmail");
    Metrix.setUserCountry("country");
    Metrix.setUserCity("city");
    Metrix.setUserRegion("region");
    Metrix.setUserLocality("locality");
    Metrix.setUserGender("MALE"); // gender value could be "MALE" , "FEMALE" or "OTHER"
    Metrix.setUserBirthday(12312412); // birthday value type should be 'Long' timestamp
    Metrix.userChannelEnabled("SMS"); // channel value could be "SMS", "PUSH" or "EMAIL"
    Metrix.userChannelDisabled("EMAIL"); // channel value could be "SMS", "PUSH" or "EMAIL"
    // Metrix.setPushToken("fcmToken");

    Metrix.getAttributionData().listen((value) => {
      setState(() {
        attribution = value;
      })
    });

    Metrix.getUserId().listen((value) => {
      setState(() {
        userId = value;
      })
    });

    Metrix.getSessionNumber().listen((sessionNum) => {
      setState(() {
        sessionNumber = sessionNum.toString();
      })
    });

    Metrix.getSessionId().listen((id) => {
      setState(() {
        sessionId = id;
      })
    });

    // iOS only
    Metrix.setStore("AppStore");

    // iOS only
    Metrix.setAppSecret(1, 429751687, 1057026454, 796046595, 610423971);

    // iOS only
    Metrix.setDefaultTracker("uevt4h");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Metrix plugin example app'),
          ),
          body: Center(child: Column(children: <Widget>[
            Container(
                margin: const EdgeInsets.all(20),
                child: Text('Session number is: $sessionNumber')
            ),
            Container(
                margin: const EdgeInsets.all(20),
                child: Text('Session id is: $sessionId')
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.blueGrey,
                ),
                onPressed: () {
                  Metrix.newEvent('lbuoa', {"first": "second"});
                  Metrix.newEvent('lbuoa');
                },
                child: const Text(
                  'SendEvent',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.blueGrey,
                ),
                onPressed: () {
                  Metrix.newRevenue('ykwyp', 2500.5);
                  Metrix.newRevenue('ykwyp', 2500.5, currency: 0);
                },
                child: const Text(
                  'SendRevenue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(20), child: Text('UserId is: $userId')),
            Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                    'User attribution status: ${attribution?.attributionStatus ?? ""}')),
          ]))
      ),
    );
  }
}