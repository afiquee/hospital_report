import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_report/models/notification_data.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/services/push_notification.dart';
import 'package:hospital_report/services/report.dart';
import 'package:hospital_report/services/user.dart';
import 'package:hospital_report/shared/OtherClipper.dart';
import 'package:hospital_report/shared/constants.dart';
import 'package:hospital_report/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportForm extends StatefulWidget {
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> location = ['Wad1','Wad2','Wad3','Wad4','Wad5','Wad6','Wad7','JPL','A&E','CSSU','Klinik Pakar','Rekod','Patologi',
    'Pengimejan & Diagnostik','Sajian','Fisioterapi','Cara Kerja','Kawalan Infeksi','Pusat Sumber','Kualiti','Hemodialisis','Kejuruteraan'
    ,'(Pengurusan) Kewangan','(Pengurusan) Sumber Manusia','(Pengurusan) Keselamatan','(Pengurusan) (Pentadbiran) Surat Menyurat',
    '(Pengurusan) (Pentadbiran) Latihan','(Pengurusan) ICT','(Pengurusan) Penyelia Jururawat','(Pengurusan) Penyelia Hospital',
    'Farmasi Pesakit Luar','Farmasi Pesakit Dalam','Farmasi Logistic'];

  String _currentProblem;
  String _currentDescription;
  String _currentLocation;
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Column(
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
                          'Tambah Laporan',
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
                                    validator: (val) => val.isEmpty ? 'Sila isi masalah' : null,
                                    onChanged: (val) {
                                      setState(() => _currentProblem = val);

                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Masalah',
                                        labelStyle: TextStyle(color: Colors.grey[400]),
                                        hintText: "Masalah",
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
                                    validator: (val) => val.isEmpty ? 'Sila isi deskripsi' : null,
                                    onChanged: (val) {
                                      setState(() => _currentDescription = val);

                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Deskripsi',
                                        labelStyle: TextStyle(color: Colors.grey[400]),
                                        hintText: "Deskripsi",
                                        hintStyle: TextStyle(color: Colors.grey[400])
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: 'Lokasi',
                                      border: InputBorder.none,


                                    ),
                                    value: _currentLocation,
                                    validator: (val) => val == null ? 'Sila pilih lokasi' : null,
                                    items: location.map((location){
                                      return DropdownMenuItem(
                                        value: location,
                                        child: Text(location),
                                      );
                                    }).toList(),
                                    onChanged: (val) => setState(() => _currentLocation = val),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: double.infinity,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0)
                              ),
                              onPressed: () async {
                                if(_formKey.currentState.validate()) {
                                  setState(()  {
                                    loading = true;
                                  });
                                  await  ReportService().updateReport(
                                      _currentProblem,
                                      _currentDescription,
                                      _currentLocation,
                                      user.uid
                                  );
                                  var tokens = await UserService().getAdminToken();
                                  print(tokens.toString());
                                  NotificationData notificationData = new NotificationData(title: 'Laporan baharu',body: '$_currentProblem di lokasi $_currentLocation',tokens: tokens);
                                  await PushNotificationService().sendAdminNotification(notificationData);
                                  setState(()  {
                                    loading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Laporan berjaya dihantar!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  Navigator.pop(context);

                                }
                              },
                              color: Colors.red[400],
                              child: Text(
                                'Hantar',
                                style: TextStyle(color: Colors.white),
                              ),

                            ),
                          ),
                          SizedBox(height: 70,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SafeArea(
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      textColor: Colors.black,
                      minWidth: 0,
                      height: 40,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),

    );
  }
}
