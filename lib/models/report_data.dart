import 'package:cloud_firestore/cloud_firestore.dart';

class ReportData {
  String rID;
  String problem;
  String description;
  String location;
  DateTime reportTime;
  DateTime completeTime;
  String status;
  String reporter;
  String reporterEmail;
  String reporterName;

  ReportData({ this.rID, this.problem, this.description, this.location, this.reportTime,this.completeTime,this.status,this.reporter,this.reporterEmail,this.reporterName});

  void setReporterEmail(String reporterEmail) {
    this.reporterEmail = reporterEmail;
  }
  void setReporterName(String reporterName) {
    this.reporterName = reporterName;
  }

  factory ReportData.fromMap(String docId, Map data) {
    data = data ?? { };
    return ReportData(
      rID: docId,
      problem: data['problem'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      reportTime: data['reportTime'] != null ? (data['reportTime'] as Timestamp).toDate() : null,
      completeTime: data['completeTime'] != null ? (data['completeTime'] as Timestamp).toDate() : null,
      status: data['status'] ?? '',
      reporter: data['reporter'] ?? '',
    );
  }

}
