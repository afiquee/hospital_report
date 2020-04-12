import 'package:flutter/material.dart';
import 'package:hospital_report/screens/admin/admin_completed_report_list.dart';
import 'package:hospital_report/screens/admin/admin_incomplete_report_list.dart';

class AdminReportTab extends StatefulWidget {
  @override
  _AdminReportTabState createState() => _AdminReportTabState();
}

final tabs = [
  AdminCompletedReportList(),
  AdminIncompleteReportList()
];

class _AdminReportTabState extends State<AdminReportTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.red[200],
                  Colors.red[400]
                ]
              )
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(child: new Container()),
                  TabBar(
                    indicatorColor: Colors.white,
                    tabs: [Tab(
                      text: 'Selesai',

                      icon: Icon(Icons.done),
                    ),
                      Tab(
                        text: 'Belum Selesai',
                        icon: Icon(Icons.call_received),
                      ),],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: tabs,
        ),
      ),
    );
  }
}
