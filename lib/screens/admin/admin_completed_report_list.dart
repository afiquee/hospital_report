import 'dart:io';
import 'package:hospital_report/screens/admin/admin_list_builder.dart';
import 'package:hospital_report/screens/admin/full_report.dart';
import 'package:hospital_report/screens/admin/report_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:flutter/material.dart';
import 'package:hospital_report/models/report.dart';
import 'package:hospital_report/screens/home/report_list.dart';
import 'package:hospital_report/services/report.dart';
import 'package:printing/printing.dart';
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
            child: AdminListBuilder()
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Cetak Laporan'),
          backgroundColor: Colors.red[300],
          icon: Icon(Icons.picture_as_pdf),
          onPressed:  () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FullReport(),
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  _generatePdfAndView(context) async {
    List<Report> data = await ReportService().getReportForPrint();
    print('data from db :'+data.toString());
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Center(
            child: pdfLib.Text(
              'Laporan Tahun'
            )

          ),
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Masalah', 'Lokasi', 'Tarikh'],
            ...data.map(
                    (item) => [item.problem, item.location, formatDate(item.reportTime)])
          ]),
        ],
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/report.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    //await Printing.sharePdf(bytes: pdf.save(), filename: 'report.pdf');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReportViewer(path: path),
      ),
    );
  }

}
