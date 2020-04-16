import 'package:flutter/material.dart';
import 'package:hospital_report/screens/navigation/admin/admin_report_tab.dart';
import 'package:hospital_report/screens/navigation/user_report_tab.dart';


class UserReportList extends StatefulWidget {
  @override
  _UserReportListState createState() => _UserReportListState();
}

class _UserReportListState extends State<UserReportList> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: UserReportTab(),
    );
  }
}
