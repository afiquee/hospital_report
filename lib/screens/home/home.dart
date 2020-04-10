import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hospital_report/models/report.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/screens/home/new_report_form.dart';
import 'package:hospital_report/screens/second_page.dart';
import 'package:hospital_report/services/auth.dart';
import 'package:hospital_report/services/push_notification.dart';
import 'package:hospital_report/services/report.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/services/user.dart';
import 'package:hospital_report/shared/loading.dart';
import 'package:provider/provider.dart';
import 'report_list.dart';
import 'package:hospital_report/helpers/local_notification_helper.dart';

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
      if(user.role == 'Admin'){
        return StreamProvider<List<Report>>.value(
          value: ReportService().reports,
          child: Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              iconTheme: IconThemeData(
                  color: Colors.red
              ),
              title: Text('Brew Crew',style: TextStyle(
                  color: Colors.red
              ),),
              backgroundColor: Colors.white,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('logout'),
                  onPressed: () async{
                    await _auth.signOut();

                  },
                ),
                FlatButton.icon(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                  onPressed: () async{

                    var tokens = await UserService().getAdminToken();
                    showOngoingNotification(notifications,
                        title: 'Tite', body: 'Body');
                    //String response = await PushNotificationService().sendNotification();
                    //print(response);
                  },
                )
              ],
            ),
            body: Container(
                child: ReportList()
            ),
            floatingActionButton: FloatingActionButton.extended(
              label: Text('Tambah Laporan'),
              icon: Icon(Icons.add),
              onPressed: () => _showReportPanel(),
            ),
          ),
        );
      }  else
        return StreamProvider<List<Report>>.value(
          value: ReportService().reports,
          child: Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              iconTheme: IconThemeData(
                  color: Colors.red
              ),
              title: Text('Brew Crew',style: TextStyle(
                  color: Colors.red
              ),),
              backgroundColor: Colors.white,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('logout'),
                  onPressed: () async{
                    await _auth.signOut();

                  },
                ),
                FlatButton.icon(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                  onPressed: () async{

                    var tokens = await UserService().getAdminToken();
                    //String response = await PushNotificationService().sendNotification();
                    //print(response);
;
                  },
                )
              ],
            ),
            body: Container(
                child: ReportList()
            ),
            floatingActionButton: FloatingActionButton.extended(
              label: Text('Tambah Laporan'),
              icon: Icon(Icons.add),
              onPressed: () => _showReportPanel(),
            ),
          ),
        );
    } else {
      return Loading();
    }

  }
}
