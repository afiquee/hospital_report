import 'dart:math';

import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user){
    return user!= null ?  new User(uid: user.uid) : null;
  }


  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
    //.map( (FirebaseUser user) => _userFromFirebase(user));
  }

  Future signIn(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;

    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<FirebaseUser> register(String email, String password, String name) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      var test = await UserService(uid: user.uid).updateUser(email,name , null);
      await UserService(uid:user.uid).saveDeviceToken();
      return user;
    } catch(e){
      print(e.hashCode);
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}