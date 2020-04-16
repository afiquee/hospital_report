import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/services/auth.dart';
import 'package:hospital_report/services/user.dart';
import 'package:hospital_report/shared/BgClipper.dart';
import 'package:hospital_report/shared/loading.dart';

class Login extends StatefulWidget {

  final Function toggleView;
  Login({ this.toggleView});


  @override
  _LoginState createState() => _LoginState();
}



class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String name = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                ClipPath(
                  clipper: BgClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 400,
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
                        'Log Masuk',
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
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10)
                                )
                              ]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                ),
                                child: TextFormField(
                                  validator: (val) => val.isEmpty ? 'Sila isi emel' : null,
                                  onChanged: (val) {
                                    setState(() => email = val);

                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Emel',
                                      labelStyle: TextStyle(color: Colors.grey[400]),
                                      hintText: "Emel",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (val) => val.isEmpty ? 'Sila isi kata laluan' : null,
                                  onChanged: (val) {
                                    setState(() => password = val);

                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Kata Laluan",
                                      labelText: 'Kata Laluan',
                                      labelStyle: TextStyle(color: Colors.grey[400]),
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        SizedBox(height: 30.0),
                        ButtonTheme(
                          height: 50.0,
                          minWidth: double.infinity,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0)
                            ),
                            onPressed: () async {
                              if(_formKey.currentState.validate()) {
                                setState(() => loading = true );
                                print('loading: ${loading}');
                                FirebaseUser user = await _auth.signIn(email, password);
                                print('user : ${user}');
                                if(user == null) {
                                  setState(() {
                                    error = 'Invalid email or password';
                                    loading = false;
                                  });
                                }
                                else {
                                  dynamic token = await UserService(uid:user.uid).saveDeviceToken();
                                  if(token == null) {
                                    setState(() {
                                      error = 'Invalid email or password';
                                      loading = false;
                                    });
                                  }
                                }
                              }
                            },
                            color: Colors.red[400],
                            child: Text(
                              'Log Masuk',
                              style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(height: 70,),
                        FlatButton(
                          child: Text('Daftar Akaun', style: TextStyle(
                              color: Colors.red[400]
                          ),),
                          onPressed: () {
                            widget.toggleView();
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}

