import 'package:flutter/material.dart';
import 'package:hospital_report/models/report.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/screens/home/edit_report_form.dart';
import 'package:hospital_report/services/report.dart';
import 'package:hospital_report/services/user.dart';
import 'package:hospital_report/shared/OtherClipper.dart';
import 'package:hospital_report/shared/loading.dart';

class ReportDetail extends StatefulWidget {

  Report report;

  ReportDetail({this.report});

  @override
  _ReportDetailState createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  String formatDate(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String formatTime(DateTime dateTime){
    if (dateTime.minute < 10){
      return '${dateTime.hour}:0${dateTime.minute}';

    }
    return '${dateTime.hour}:${dateTime.minute}';
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: ReportService(rID: widget.report.rID).report(),
      builder: (context,snapshot) {
        Report report = snapshot.data;
        if(snapshot.hasData) {
          return StreamBuilder<User>(
            stream: UserService(uid: widget.report.reporter).user(widget.report.reporter),
            builder: (context,snapshot){
              if(snapshot.hasData) {
                print(snapshot.data);
                User user = snapshot.data;

                return Scaffold(
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
                                        'Info Laporan',
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
                                    child: Builder(
                                      builder: (context) {
                                        if(report.status == 'Belum Selesai') {
                                          return Column(
                                            children: <Widget>[

                                              ListTile(
                                                title: Text("Masalah"),
                                                subtitle: Text(report.problem),
                                                leading: Icon(Icons.report_problem),
                                              ),
                                              Divider(),
                                              ListTile(
                                                title: Text("Deskripsi"),
                                                subtitle: Text(report.description),
                                                leading: Icon(Icons.description),
                                              ),
                                              Divider(),
                                              ListTile(
                                                title: Text("Lokasi"),
                                                subtitle: Text(report.location),
                                                leading: Icon(Icons.location_on),
                                              ),
                                              Divider(),
                                              ListTile(
                                                title: Text("Waktu dilapor"),
                                                subtitle: Text(' ${formatTime(report.reportTime)} ${formatDate(report.reportTime)} '),
                                                leading: Icon(Icons.access_time),
                                              ),
                                              Divider(),
                                              ListTile(
                                                title: Text("Dilapor oleh"),
                                                subtitle: Text(user.name),
                                                leading: Icon(Icons.location_on),
                                              ),
                                            ],
                                          );
                                        }
                                        return Column(
                                          children: <Widget>[

                                            ListTile(
                                              title: Text("Masalah"),
                                              subtitle: Text(report.problem),
                                              leading: Icon(Icons.report_problem),
                                            ),
                                            Divider(),
                                            ListTile(
                                              title: Text("Deskripsi"),
                                              subtitle: Text(report.description),
                                              leading: Icon(Icons.description),
                                            ),
                                            Divider(),
                                            ListTile(
                                              title: Text("Lokasi"),
                                              subtitle: Text(report.location),
                                              leading: Icon(Icons.location_on),
                                            ),
                                            Divider(),
                                            ListTile(
                                              title: Text("Waktu dilapor"),
                                              subtitle: Text(' ${formatTime(report.reportTime)} ${formatDate(report.reportTime)} '),
                                              leading: Icon(Icons.access_time),
                                            ),
                                            Divider(),
                                            ListTile(
                                              title: Text("Waktu selesai"),
                                              subtitle: Text(' ${formatTime(report.completeTime)} ${formatDate(report.completeTime)} '),
                                              leading: Icon(Icons.access_time),
                                            ),
                                            Divider(),
                                            ListTile(
                                              title: Text("Dilapor oleh"),
                                              subtitle: Text(user.name),
                                              leading: Icon(Icons.location_on),
                                            ),

                                          ],
                                        );

                                      },
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

                    floatingActionButton: Builder(
                      builder: (context) {

                        return widget.report.status == 'Belum Selesai' ?
                        FloatingActionButton.extended(
                          label: Text('Kemaskini'),
                          backgroundColor: Colors.red[400],
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditReportForm(report: widget.report)));
                          },
                        ) : Container();

                      },
                    )

                );


              }
              return Loading();

            },

          );

        }
        return Loading();

      },
    );
  }
}


