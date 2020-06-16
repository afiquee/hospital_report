import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hospital_report/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {

  final String uid;
  UserService({this.uid});

  final CollectionReference userCollections = Firestore.instance.collection('user');
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future updateUser(String email, String name, String token) async {
    return await userCollections.document(uid).setData({
      'email':email,
      'name':name,
      'token':token
    });
  }

  Future getUser() async {
    return await userCollections.document(uid)
        .get()
        .then((doc) => User.fromMap(doc.data));
  }


  Stream <User> user (uid){
    return userCollections
        .document(uid)
        .snapshots()
        .map( (snap) => User.fromMap(snap.data));
  }

  Stream<List<User>> get users {
    return userCollections
        .orderBy("email", descending: false)
        .snapshots().map((snapshot) => snapshot
        .documents.map((doc) => User.fromMap(doc.data))
        .toList()
    );
  }

  Future saveDeviceToken() async {

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      return userCollections
          .document(uid)
          .setData(({'token': fcmToken}), merge: true);
    }
  }
  
  Future getAdminToken() async {
    
    List<String> tokens = [];
    
    await userCollections.where('role',isEqualTo: 'Admin').getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((data) => tokens.add(data['token']));
    });

    return tokens;
    
  }


}