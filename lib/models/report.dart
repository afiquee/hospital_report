import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String rID;
  final String problem;
  final String description;
  final String location;
  final DateTime reportTime;
  final DateTime completeTime;
  final String status;
  final String reporter;

  Report({ this.rID, this.problem, this.description, this.location, this.reportTime,this.completeTime,this.status,this.reporter});

  factory Report.fromMap(String docId, Map data) {
    data = data ?? { };
    return Report(
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
