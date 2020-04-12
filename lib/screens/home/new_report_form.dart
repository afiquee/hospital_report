import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hospital_report/models/notification_data.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/services/push_notification.dart';
import 'package:hospital_report/services/report.dart';
import 'package:hospital_report/services/user.dart';
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
    ,'(Pengurusan) Kewangan','(Pengurusan) Sumber Manusia','(Pengurusan) Keselamatan','(Pengurusan) (Pentadbiran) Surat Menyurat','(Pengurusan) (Pentadbiran) Latihan','(Pengurusan) ICT','(Pengurusan) Penyelia Jururawat','(Pengurusan) Penyelia Hospital','Farmasi Pesakit Luar','Farmasi Pesakit Dalam','Farmasi Logistic'];

  String _currentProblem;
  String _currentDescription;
  String _currentLocation;
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Theme(
        data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                color: Colors.red
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red,width: 1.5 )
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey,width: 1.0 ),
                ),
            )
        ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Laporan Baru',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Masalah'
                ),
                validator: (val) => val.isEmpty ? 'Sila isi ruang masalah ' : null,
                onChanged: (val) {
                  setState(() => _currentProblem = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelText: 'Deskripsi'
                ),
                validator: (val) => val.isEmpty ? 'Sila isi ruang deskripsi ' : null,
                onChanged: (val) {
                  setState(() => _currentDescription = val);
                },
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField(
                isExpanded: true,

                decoration: InputDecoration(
                    labelText: 'Lokasi'
                ),
                value: _currentLocation,
                items: location.map((location){
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _currentLocation = val),
              ),
              SizedBox(height: 20.0),
              ButtonTheme(
                height: 50.0,
                minWidth: double.infinity,
                child: RaisedButton(
                  color: Colors.red[400],
                  child: Text(
                    'Lapor',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white
                    ),
                  ),
                  onPressed: () async {
                    print(_formKey.currentState.validate());
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
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
