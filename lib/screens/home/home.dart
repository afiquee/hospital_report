import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/screens/admin/admin_report_list.dart';
import 'package:hospital_report/screens/home/new_report_form.dart';
import 'package:hospital_report/screens/home/user_report_list.dart';
import 'package:hospital_report/screens/second_page.dart';
import 'package:hospital_report/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/shared/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  final notifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  void initState() {
    super.initState();
    _initLocalNotifications();

  }

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



  void _showReportPanel() {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
          child: SingleChildScrollView(child: ReportForm())
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);


    if(user != null) {
      print('role : ${user.role}');
      if(user.role == 'Admin'){
        return AdminReportList();
      }  else
        return UserReportList();
    } else {
      return Loading();
    }

  }
}
