import 'package:flutter/material.dart';
import 'package:hospital_report/models/report.dart';
import 'package:hospital_report/screens/home/report_list.dart';
import 'package:hospital_report/services/report.dart';
import 'package:provider/provider.dart';

class AdminIncompleteReportList extends StatefulWidget {
  @override
  _AdminIncompleteReportListState createState() => _AdminIncompleteReportListState();
}

class _AdminIncompleteReportListState extends State<AdminIncompleteReportList> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Report>>.value(
      value: ReportService().incompleteReports,
      child: Scaffold(
        body: Container(
            child: ReportList()
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Tambah Laporan'),
          icon: Icon(Icons.add),
          onPressed: () => (){},
        ),
      ),
    );
  }
}
