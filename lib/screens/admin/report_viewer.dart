import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:printing/printing.dart';

class ReportViewer extends StatelessWidget {

  final String path;
  const ReportViewer({Key key, this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PDFViewerScaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.share,color: Colors.white,),
                label: Text('Simpan',style: TextStyle(color: Colors.white),),
                onPressed: () async{
                  File file = File(path);
                  await Printing.sharePdf(bytes: file.readAsBytesSync(), filename: 'report.pdf');
                },
              ),

            ],
          ),
          path: path,

        ),
      ),

    );
  }
}
