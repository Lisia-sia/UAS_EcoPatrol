import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_ecopatrol/models/report_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference biar rapi & type-safe
  CollectionReference<ReportModel> get _reportsRef {
    return _firestore.collection('reports').withConverter<ReportModel>(
      fromFirestore: (snapshots, _) => ReportModel.fromJson(snapshots.data()!, snapshots.id),
      toFirestore: (report, _) => report.toJson(),
    );
  }

  // Ambil data stream
  Stream<List<ReportModel>> getReportsStream() {
    return _reportsRef
        .orderBy('createdAt', descending: true) // 🔥 PERBAIKAN DISINI (Ganti 'date' jadi 'createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Tambah
  Future<void> addReport(ReportModel report) async {
    await _reportsRef.add(report);
  }

  // Update
  Future<void> updateReport(String id, Map<String, dynamic> data) async {
    await _firestore.collection('reports').doc(id).update(data);
  }

  // Hapus
  Future<void> deleteReport(String id) async {
    await _firestore.collection('reports').doc(id).delete();
  }
}