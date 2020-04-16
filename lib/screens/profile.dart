import 'package:flutter/material.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/services/auth.dart';
import 'package:hospital_report/shared/GradientAppBar.dart';
import 'package:hospital_report/shared/OtherClipper.dart';
import 'package:hospital_report/shared/loading.dart';
import 'package:provider/provider.dart';

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
    final user = Provider.of<User>(context);
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
                    height: 250,
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
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10)
                        )
                      ],
                    ),
                    child: Column(
                      children: <Widget>[

                        ListTile(
                          title: Text("Emel"),
                          subtitle: Text(user.email),
                          leading: Icon(Icons.email),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Nama"),
                          subtitle: Text(user.name),
                          leading: Icon(Icons.person),
                        ),
                        Divider(),
                        ButtonTheme(
                          height: 50.0,
                          minWidth: double.infinity,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0)
                            ),
                            onPressed: () async {

                            },
                            color: Colors.red[400],
                            child: Text(
                              'Kemaskini',
                              style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Log Keluar'),
        backgroundColor: Colors.red[400],
        icon: Icon(Icons.power_settings_new),
        onPressed: (){
          _auth.signOut();
        },
      ),

    );
  }


}

const TitleStyle = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black, height: 1.5
);

const SubtitleStyle = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54, height: 1.5
);
