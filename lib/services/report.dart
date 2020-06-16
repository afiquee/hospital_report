import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_report/models/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {

  final String rID;
  ReportService({this.rID});

  final CollectionReference reportCollections = Firestore.instance.collection('report');


  Stream <Report> report (){
    return reportCollections
        .document(rID)
        .snapshots()
        .map( (snap) => Report.fromMap(snap.documentID,snap.data));
  }

  Future updateReport(String problem, String description, String location, String uid) async {
    return await reportCollections.document(rID).setData({
      'problem':problem,
      'description':description,
      'location':location,
      'reportTime': Timestamp.now(),
      'status': 'Belum Selesai',
      'reporter': uid,
    });
  }

  Future<List<Report>> getReportForPrint() async {
    var list = await reportCollections.where("status",isEqualTo: "Selesai")
        .getDocuments().then((data) => data.documents.map((doc) {
          return Report.fromMap(doc.documentID, doc.data);
    }).toList());

    return list;

  }

  Future completeReport() async {
    return await reportCollections.document(rID).updateData({
      'completeTime': Timestamp.now(),
      'status': 'Selesai',
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

  Stream<List<Report>> get incompleteReports {
    return reportCollections
        .where("status",isEqualTo: "Belum Selesai")
        .orderBy('reportTime',descending: true)
        .snapshots().map((snapshot) => snapshot
        .documents.map((doc) => Report.fromMap(doc.documentID,doc.data))
        .toList()
    );
  }


  Stream<List<Report>> get completedReports {
    return reportCollections
        .where("status",isEqualTo: "Selesai")
        .orderBy('reportTime',descending: true)
        .snapshots().map((snapshot) => snapshot
        .documents.map((doc) => Report.fromMap(doc.documentID,doc.data))
        .toList()
    );
  }

  Stream<List<Report>> getUserCompleteReports(String uid) {
    return reportCollections
        .where('status',isEqualTo: 'Selesai')
        .where('reporter',isEqualTo: uid)
        .snapshots().map((snapshot) => snapshot
        .documents.map((doc) => Report.fromMap(doc.documentID,doc.data))
        .toList()
    );
  }

  Stream<List<Report>> getUserIncompleteReports(String uid) {
    return reportCollections
        .where('status',isEqualTo: 'Belum Selesai')
        .where('reporter',isEqualTo: uid)
        .snapshots().map((snapshot) => snapshot
        .documents.map((doc) => Report.fromMap(doc.documentID,doc.data))
        .toList()
    );
  }

  void deleteReport() {
    reportCollections.document(rID).delete();
  }


}