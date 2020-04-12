import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_report/models/report.dart';
import 'package:hospital_report/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital_report/services/auth.dart';

class ReportService {

  final String rID;
  ReportService({this.rID});

  final CollectionReference reportCollections = Firestore.instance.collection('report');

  Future _getCurrentUser () async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  Future updateReport(String problem, String description, String location, String uid) async {
    return await reportCollections.document(rID).setData({
      'problem':problem,
      'description':description,
      'location':location,
      'reportTime': new DateTime.now(),
      'status': 'Belum Selesai',
      'reporter': uid,
    });
  }

  List<Report> _reportListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map( (doc) {
      return Report(
        rID: doc.data['rID'],
        problem: doc.data['problem'] ?? '',
        location: doc.data['location'] ?? '',
        reportTime: doc.data['reportTime'] != null ? (doc.data['reportTime'] as Timestamp).toDate() : null,
        completeTime: doc.data['completeTime'] != null ? (doc.data['completeTime'] as Timestamp).toDate() : null,
        status: doc.data['status'] ?? '',
        reporter: doc.data['reporter'] ?? '',

      );
    }).toList();
  }


  Stream<List<Report>> get completedReports {
    return reportCollections.where("status",isEqualTo: "Selesai")
        .snapshots().map((snapshot) => snapshot
        .documents.map((doc) => Report.fromMap(doc.data))
        .toList()
    );
  }

  Stream<List<Report>> get incompleteReports {
    return reportCollections.where("status",isEqualTo: "Belum Selesai")
        .snapshots().map((snapshot) => snapshot
        .documents.map((doc) => Report.fromMap(doc.data))
        .toList()
    );
  }


}