
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_report/models/report.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/screens/admin/admin_report_detail.dart';
import 'package:hospital_report/screens/report_detail.dart';
import 'package:hospital_report/services/report.dart';
import 'package:provider/provider.dart';

class AdminReportTile extends StatelessWidget {

  final Report report;
  AdminReportTile({this.report});

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
    final user = Provider.of<User>(context);

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Builder(
          builder: (context){

            return report.status == 'Selesai' ?
            Dismissible(
              key: ValueKey(report.rID),
              direction: DismissDirection.horizontal,
              confirmDismiss: (direction) {
                return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Anda pasti untuk padam laporan ini?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          ReportService(rID: report.rID).deleteReport();
                          Fluttertoast.showToast(
                              msg: "Laporan berjaya dipadam!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          Navigator.pop(context);
                        },
                        child: Text('Padam',style: TextStyle(color: Colors.red),),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Batal',style: TextStyle(color: Colors.blue),),
                      )
                    ],
                  ),
                );

              },
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.only(left: 16),
                child: Align(child: Icon(Icons.delete, color: Colors.white), alignment: Alignment.centerLeft),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: ListTile(
                  leading: RichText(
                    text: TextSpan(
                        text: report.problem, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black , height: 1.5),
                        children: [
                          TextSpan(
                            text: '\n${report.location}', style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
                          ),
                          TextSpan(
                            text: '\n${formatDate(report.reportTime)} at ${formatTime(report.reportTime)}', style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
                          ),


                        ]

                    ),
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    user.role == 'Admin' ?
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminReportDetail(report: report))) :
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDetail(report: report)));
                  },
                ),
              ),
            ) :
            Container(
              padding: EdgeInsets.all(20),
              child: ListTile(
                leading: RichText(
                  text: TextSpan(
                      text: report.problem, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black , height: 1.5),
                      children: [
                        TextSpan(
                          text: '\n${report.location}', style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
                        ),
                        TextSpan(
                          text: '\n${formatDate(report.reportTime)} at ${formatTime(report.reportTime)}', style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
                        ),


                      ]

                  ),
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  user.role == 'Admin' ?
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminReportDetail(report: report))) :
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDetail(report: report)));
                },
              ),
            );

          },
        ),
      ),
    );
  }

}


