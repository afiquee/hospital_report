import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital_report/models/report_data.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/services/user.dart';

class ReportDataService {

  ReportDataService();

  final CollectionReference reportCollections = Firestore.instance.collection('report');
  final CollectionReference userCollections = Firestore.instance.collection('user');


  Future<List<ReportData>> getReportForPrint() async {
    //get list of reports
    var list = await reportCollections
        .where("status",isEqualTo: "Selesai")
        .orderBy('reportTime',descending: true)
        .getDocuments().then((data) => data.documents.map((doc) => ReportData.fromMap(doc.documentID, doc.data)).toList());
    return list;
  }

//  Future<List<ReportData>> getReportForPrintss() async {
//
//    User user = new User();
//    List<ReportData> reports;
//    //get list of reports
//    QuerySnapshot querySnapshot = await reportCollections.where("status",isEqualTo: "Selesai")
//        .getDocuments();
//    reports =  querySnapshot.documents.map((doc) async {
//
//      User user = await UserService(uid: doc.data['reporter']).getUser();
//
//      return ReportData(
//        rID: doc.data['rID'],
//        problem: doc.data['problem'] ?? '',
//        location: doc.data['location'] ?? '',
//        reportTime: doc.data['reportTime'] != null ? (doc.data['reportTime'] as Timestamp).toDate() : null,
//        completeTime: doc.data['completeTime'] != null ? (doc.data['completeTime'] as Timestamp).toDate() : null,
//        status: doc.data['status'] ?? '',
//        reporter: doc.data['reporter'] ?? '',
//        reporterEmail: user.email ?? '',
//        reporterName: user.name ?? '',
//      );
//    }).toList();
//
//  }

//  Future<List<ReportData>> getReportForPrints() async {
//
//    User user = new User();
//    //get list of reports
//    var list = await reportCollections.where("status",isEqualTo: "Selesai")
//        .getDocuments().then((data) => data.documents.map((doc) async {
//          //get the reporter (user) for each reports
//          await UserService(uid: doc.data['reporter']).getUser().then((userData) {
//            user = User.fromMap(userData);
//          });
//          print(user.name);
//          return ReportData(
//            rID: doc.data['rID'],
//            problem: doc.data['problem'] ?? '',
//            location: doc.data['location'] ?? '',
//            reportTime: doc.data['reportTime'] != null ? (doc.data['reportTime'] as Timestamp).toDate() : null,
//            completeTime: doc.data['completeTime'] != null ? (doc.data['completeTime'] as Timestamp).toDate() : null,
//            status: doc.data['status'] ?? '',
//            reporter: doc.data['reporter'] ?? '',
//            reporterEmail: user.email ?? '',
//            reporterName: user.name ?? '',
//          );
//          print('doc data: '+doc.data.toString());
//    }).toList());
//    return list;
//  }

  Future<List<String>> getYears() async {
    var list = await reportCollections.where("status",isEqualTo: "Selesai")
        .getDocuments().then((data) => data.documents.map((doc) => (doc.data['reportTime'] as Timestamp).toDate().year.toString()).toList());

    return list;
  }
}
