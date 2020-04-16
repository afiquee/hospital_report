import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/models/notification_data.dart';
import 'package:http/http.dart';

class PushNotificationService {

  final String deviceToken;
  PushNotificationService({this.deviceToken});

  final String serverKey = 'AAAAu6cGuKo:APA91bEi_zxFoI8NZsm_ObknB9wTAez_SDWeiyCVcnnu1-S9MDPI3JZHUAECG4GexYRXC5CXOFKT6lyYnJzi1lW3CvW4X5tO1XeGenrvQ8A-z7Ro76jlZ3rwSqR4SiRWOwbDb7sIJZzm';
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  //final String token = 'dGYJIsWGSLCbNSY00nZSmn:APA91bEwg1EO4Ni4Q9C8pfYeP3UZv1JjeQJhKdS_-Ru-mqD1bsLAPuw7ErH_DOm6JnCOUYFqW9QVj1TXHpapQjmgJUnsK7eu9VvJR_q9kZ4wPKj97amH6QAtn94Nt3a2duILoKYKVdXp';


  Future<String> sendNotification(NotificationData notificationData) async {

    Map data = {
      'click_action':'FLUTTER_NOTIFICATION_CLICK',
      'title': notificationData.title,
      'body':notificationData.body
    };

    Map message = {
      'data': data,
      'title':notificationData.title,
      'body':notificationData.body
    };

    Map payload = {
      'to': 'TOKEN',
      'priority':'high',
      'notification': message
    };

    print(json.encode(payload));

    await Future.delayed(Duration(seconds: 5), () async {

      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(fcmUrl));
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Authorization','key='+serverKey);
      request.add(utf8.encode(json.encode(payload)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      return reply;

    });





  }


  Future sendAdminNotification(NotificationData notificationData) async {


    for(var token in notificationData.tokens) {

      print('token $token');

      Map data = {
        'click_action':'FLUTTER_NOTIFICATION_CLICK',
        'title': notificationData.title,
        'body':notificationData.body
      };

      Map message = {
        'data': data,
        'title':notificationData.title,
        'body':notificationData.body
      };

      Map payload = {
        'to': token,
        'priority':'high',
        'notification': message
      };

      print(json.encode(payload));

      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(fcmUrl));
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Authorization','key='+serverKey);
      request.add(utf8.encode(json.encode(payload)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      print(reply);


    }


  }

}