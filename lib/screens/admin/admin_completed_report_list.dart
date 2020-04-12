import 'package:flutter/material.dart';
import 'package:hospital_report/models/report.dart';
import 'package:hospital_report/screens/home/report_list.dart';
import 'package:hospital_report/services/report.dart';
import 'package:provider/provider.dart';

class AdminCompletedReportList extends StatefulWidget {
  @override
  _AdminCompletedReportListState createState() => _AdminCompletedReportListState();
}

class _AdminCompletedReportListState extends State<AdminCompletedReportList> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Report>>.value(
      value: ReportService().completedReports,
      child: Scaffold(
        body: Container(
            child: ReportList()
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Tambah Laporan'),
          backgroundColor: Colors.red[300],
          icon: Icon(Icons.add),
          onPressed: () => (){},
        ),
      ),
    );
  }
}
