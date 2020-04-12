import 'package:flutter/material.dart';
import 'package:hospital_report/screens/navigation/admin/admin_report_tab.dart';


class AdminReportList extends StatefulWidget {
  @override
  _AdminReportListState createState() => _AdminReportListState();
}

class _AdminReportListState extends State<AdminReportList> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: AdminReportTab(),
    );
  }
}
