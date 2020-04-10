import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/models/message.dart';
import 'package:http/http.dart';

class PushNotificationService {

  final String deviceToken;
  PushNotificationService({this.deviceToken});

  final String serverKey = 'AAAAu6cGuKo:APA91bEi_zxFoI8NZsm_ObknB9wTAez_SDWeiyCVcnnu1-S9MDPI3JZHUAECG4GexYRXC5CXOFKT6lyYnJzi1lW3CvW4X5tO1XeGenrvQ8A-z7Ro76jlZ3rwSqR4SiRWOwbDb7sIJZzm';
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final String token = 'c-84agC-QVCp27SAEQ-8QT:APA91bGPbmC5rCOTSbuPHaMaiokiaU-nWXJtW66hERIGAdzVwsxLr4Em4WC30xtPG-qE1wcoxobGlnC12KpLfWjcoGkGNLAzaglZ8hy8ETrrSuSkwmCIwOOZTJjp2lUXwMf6gFBBYZyU';


  Future<String> sendNotification() async {
    
    Map data = {
      'click_action':'FLUTTER_NOTIFICATION_CLICK',
      'title':'title',
      'message':'messsage'
    };

    Map message = {
    'data': data
    };

    Map payload = {
      'to': token,
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


  Future sendAdminNotification(Message message) async {

    for(var token in message.tokens) {

      print('token $token');

      Map notification = {
        'title': message.title,
        'body': message.body,
        'data': message.data
      };

      Map payload = {
        'to': token,
        'notification': notification
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