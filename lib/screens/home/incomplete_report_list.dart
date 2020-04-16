import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital_report/models/report.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/screens/home/report_list.dart';
import 'package:hospital_report/services/report.dart';
import 'package:provider/provider.dart';

import 'new_report_form.dart';

class IncompleteReportList extends StatefulWidget {
  @override
  _IncompleteReportListState createState() => _IncompleteReportListState();
}

class _IncompleteReportListState extends State<IncompleteReportList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return StreamProvider<List<Report>>.value(
      value: ReportService().getUserIncompleteReports(user.uid),
      child: Scaffold(
        body: Container(
            child: ReportList()
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Tambah Laporan'),
          backgroundColor: Colors.red[300],
          icon: Icon(Icons.add),
          onPressed:  () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReportForm(),
            ),
          ),
        ),
      ),
    );
  }
}
