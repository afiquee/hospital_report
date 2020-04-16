import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_report/services/auth.dart';
import 'package:hospital_report/services/user.dart';
import 'package:hospital_report/shared/BgClipper.dart';
import 'package:hospital_report/shared/constants.dart';
import 'package:hospital_report/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String confirm = '';
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
                        'Daftar Akaun',
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
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                ),
                                child: TextFormField(
                                  validator: (val) => val.isEmpty ? 'Sila isi nama' : null,
                                  onChanged: (val) {
                                    setState(() => name = val);

                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Nama',
                                      labelStyle: TextStyle(color: Colors.grey[400]),
                                      hintText: "Nama",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                ),
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (val) => val.length <6 ? 'Kata laluan mesti 6 angka ke atas' : null,
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
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (val) => val.length <6 ? 'Kata laluan mesti 6 angka ke atas' : null,
                                  onChanged: (val) {
                                    setState(() => confirm = val);

                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Sahkan Kata Laluan",
                                      labelText: 'Sahkan Kata Laluan',
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
                                if(password != confirm) {
                                  setState(() {
                                    error = 'Kata laluan tidak sama';
                                    loading = false;
                                  });
                                  return;
                                }
                                setState(() => loading = true );
                                dynamic result = await _auth.register(email, password, name);
                                print('result : '+result.toString());
                                if(result == null) {
                                  setState(() {
                                    error = 'Emel tidak sah';
                                    loading = false;
                                  });
                                }
                              }
                            },
                            color: Colors.red[400],
                            child: Text(
                              'Daftar',
                              style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(height: 70,),
                        FlatButton(
                          child: Text('Log Masuk', style: TextStyle(
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
