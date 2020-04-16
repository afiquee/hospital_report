import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hospital_report/helpers/local_notification_helper.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/screens/auth/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/screens/navigation/navigation_bar.dart';
import 'package:hospital_report/screens/second_page.dart';
import 'package:hospital_report/services/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<dynamic> onBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
  }

  // Or do other work.
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  final notifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  Future onSelectNotification(String payload) async => await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
  );

  _initLocalNotifications() {

    final settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  @override
  void initState() {
    super.initState();
    _initLocalNotifications();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
      showOngoingNotification(notifications,
          title: 'Tite', body: 'Body');
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final dynamic data = message['notification'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(data['title'] ?? ''),
              subtitle: Text(data['body'] ?? ''),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onBackgroundMessage: onBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);

    return user == null ? Authenticate() : MultiProvider(
      providers: [
        StreamProvider<List<User>>.value(value: UserService().users),
        StreamProvider<User>.value(value: UserService().user(user.uid)),
      ],
      child: NavigationBar());
  }
}
