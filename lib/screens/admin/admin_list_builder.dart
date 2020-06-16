import 'package:hospital_report/models/report.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/screens/admin/admin_report_tile.dart';
import 'package:hospital_report/screens/navigation/admin/admin_report_tab.dart';
import 'package:hospital_report/screens/navigation/user_report_tab.dart';
import 'package:provider/provider.dart';


class AdminListBuilder extends StatefulWidget {
  @override
  _AdminListBuilderState createState() => _AdminListBuilderState();
}

class _AdminListBuilderState extends State<AdminListBuilder> {
  @override
  Widget build(BuildContext context) {
    final reports = Provider.of<List<Report>>(context) ?? [];

    if(reports.length == 0) {
      return Center(
        child: Text('Tiada rekod',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
      );
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context,index) {
        return AdminReportTile(report: reports[index]);

      },
    );
  }
}
