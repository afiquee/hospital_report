import 'package:hospital_report/models/report.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/screens/navigation/admin/admin_report_tab.dart';
import 'package:hospital_report/screens/navigation/user_report_tab.dart';
import 'package:provider/provider.dart';

import 'report_tile.dart';

class ReportList extends StatefulWidget {
  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  @override
  Widget build(BuildContext context) {
    final reports = Provider.of<List<Report>>(context) ?? [];

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context,index) {
        return ReportTile(report: reports[index]);

      },
    );
  }
}
