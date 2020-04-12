
import 'package:hospital_report/models/report.dart';
import 'package:flutter/material.dart';

class ReportTile extends StatelessWidget {

  final Report report;
  ReportTile({this.report});

  String formatDate(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String formatTime(DateTime dateTime){
    return '${dateTime.hour}:${dateTime.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(report.problem),
          subtitle: Text(report.location),
          trailing: Column(
            children: <Widget>[
              Text(formatDate(report.reportTime)),
              Text(formatTime(report.reportTime))
            ],
            
          ),
        ),
      ),
    );
  }

}

