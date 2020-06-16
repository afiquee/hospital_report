
import 'package:hospital_report/models/report.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/screens/admin/admin_report_detail.dart';
import 'package:hospital_report/screens/report_detail.dart';
import 'package:provider/provider.dart';

class ReportTile extends StatelessWidget {

  final Report report;
  final bool isAdmin;
  ReportTile({this.report,this.isAdmin});

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
      ),
    );
  }

}


