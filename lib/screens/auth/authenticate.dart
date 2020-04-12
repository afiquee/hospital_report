import 'package:hospital_report/screens/auth/register.dart';
import 'package:hospital_report/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/screens/auth/login.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView() {
    print('masuk main');
    setState(() => showSignIn = !showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    return showSignIn ? Login(toggleView: toggleView) : Register(toggleView: toggleView);
  }
}


