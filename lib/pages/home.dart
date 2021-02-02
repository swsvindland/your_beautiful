import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../data/api.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    subscription = _fcm.onIosSettingsRegistered.listen((data) {
      _fcm.subscribeToTopic('all');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: FutureBuilder<String>(
            future: Api.getMessage(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Text(
                    '${snapshot.data}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.calligraffitti(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "You're Beautiful!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.calligraffitti(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
