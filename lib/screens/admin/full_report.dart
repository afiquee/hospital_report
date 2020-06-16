import 'dart:io';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/screens/admin/report_viewer.dart';
import 'package:hospital_report/services/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:flutter/material.dart';
import 'package:hospital_report/models/report_data.dart';
import 'package:hospital_report/services/report_data.dart';
import 'package:hospital_report/shared/OtherClipper.dart';
import 'package:hospital_report/shared/loading.dart';
import 'package:printing/printing.dart';

class FullReport extends StatefulWidget {
  @override
  _FullReportState createState() => _FullReportState();
}

class _FullReportState extends State<FullReport> {


  String _error = '';
  String _year;
  String _startMonth = '';
  String _endMonth = '';

  List<String> years = [];
  List<ReportData> reports = [];
  int totalReports;
  List<ReportData> filteredReports = [];
  bool _isLoading = false;

  final List<String> location = ['Wad1','Wad2','Wad3','Wad4','Wad5','Wad6','Wad7','JPL','A&E','CSSU','Klinik Pakar','Rekod','Patologi',
    'Pengimejan & Diagnostik','Sajian','Fisioterapi','Cara Kerja','Kawalan Infeksi','Pusat Sumber','Kualiti','Hemodialisis','Kejuruteraan'
    ,'Pengurusan -> Kewangan','Pengurusan -> Sumber Manusia','Pengurusan -> Keselamatan','Pengurusan -> Pentadbiran -> Surat Menyurat',
    'Pengurusan -> Pentadbiran -> Latihan','Pengurusan -> ICT','Pengurusan -> Penyelia Jururawat','Pengurusan -> Penyelia Hospital',
    'Farmasi Pesakit Luar','Farmasi Pesakit Dalam','Farmasi Logistic'];

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    ReportDataService().getReportForPrint().then((data){
      print('data : '+data.toString());
      reports = data;
      fetchReporters();
    });
  }

  void fetchReporters() async {

    for(int x=0; x<reports.length;x++) {
      print('x length : ${reports.length}');
      print('x : ${x}');
      await UserService(uid: reports[x].reporter).getUser().then((userData){
        print('xx : ${x}');
        User user = userData;
        print('user email : ${user.email}');
        reports[x].setReporterEmail(user.email);
        reports[x].setReporterName(user.name);
        print('1 reporter email : '+ reports[x].reporterEmail);
      });

    }

    filteredReports = reports;

    for(var report in filteredReports) {
      print('length : '+filteredReports.length.toString());
      print('reporter email : '+report.reporterEmail);
    }
    _isLoading = false;
  }




  void filterReport() async {
    filteredReports = reports.where((report) => report.reportTime.year.toString() == _year).toList();
    totalReports = filteredReports.length;
    print(filteredReports);
    _generatePdfAndView(context);

  }

  Future<List<String>> _fetchYears() async {
    var list =  await ReportDataService().getYears();
    return list.toSet().toList();
  }

  String formatDate(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  _generatePdfAndView(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Center(
              child: pdfLib.Column(
                children: <pdfLib.Widget> [
                  pdfLib.Text(
                      'Laporan Tahun ${_year}'
                  ),
                  pdfLib.Text(
                      'Jumlah laporan : ${totalReports}'
                  ),
                  pdfLib.Text(
                      'Tarikh laporan : ${formatDate(DateTime.now())}'
                  ),

                ]
              )

          ),
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Masalah', 'Lokasi', 'Pelapor', 'Tarikh'],
            ...filteredReports.map(
                    (item) => [ item.problem, item.location, item.reporterName ?? '', formatDate(item.reportTime)])
          ]),
        ],
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/report.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    //await Printing.sharePdf(bytes: file.readAsBytesSync(), filename: 'report.pdf');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReportViewer(path: path),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  ClipPath(
                    clipper: OtherClipper(),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: <Color>[
                                Colors.red[200],
                                Colors.red[400]
                              ]
                          )
                      ),
                      child: Center(
                        child: Text(
                          'Laporan Tahunan',
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 5.0,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                  Form(
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10)
                                  )
                                ]
                            ),
                            child: FutureBuilder(
                              future: _fetchYears(),
                              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                                if(snapshot.hasData) {
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: DropdownButtonFormField(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            labelText: 'Tahun',
                                            border: InputBorder.none,


                                          ),
                                          value: _year,
                                          items: snapshot.data.map((year){
                                            return DropdownMenuItem(
                                              value: year,
                                              child: Text(year),
                                            );
                                          }).toList(),
                                          onChanged: (val) => setState(() => _year = val),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Loading();
                                }
                              }
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            _error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                          SizedBox(height: 30,),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: double.infinity,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0)
                              ),
                              onPressed: () async {
                                if(_year == null){
                                  setState(() {
                                    _error = 'Sila pilih tahun!';
                                  });
                                  return;
                                }
                                filterReport();
                              },
                              color: Colors.red[400],
                              child: Text(
                                'Cetak',
                                style: TextStyle(color: Colors.white),
                              ),

                            ),
                          ),
                          SizedBox(height: 70,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SafeArea(
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      textColor: Colors.black,
                      minWidth: 0,
                      height: 40,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),

    );
  }
}
