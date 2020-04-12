import 'package:flutter/material.dart';
import 'package:hospital_report/services/auth.dart';
import 'package:hospital_report/shared/GradientAppBar.dart';
import 'package:hospital_report/shared/OtherClipper.dart';
import 'package:hospital_report/shared/loading.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String name = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                ClipPath(
                  clipper: OtherClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: <Color>[
                              Colors.red[200],
                              Colors.red[400]
                            ]
                        )
                    ),
                    child: Center(
                      child: Text(
                        'Maklumat Diri',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 5.0,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  child: ListTile(
                    title: Text('test'),
                    subtitle: Text('test2'),
                  ),
                ),
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Log Keluar'),
        backgroundColor: Colors.red[400],
        icon: Icon(Icons.power_settings_new),
        onPressed: () => (){},
      ),

    );
  }
}
