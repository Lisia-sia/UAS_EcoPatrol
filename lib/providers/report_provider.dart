import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_ecopatrol/models/report_model.dart';
import 'package:project_ecopatrol/services/firestore_service.dart';

// Gunakan StreamNotifier agar otomatis update real-time
class ReportNotifier extends StreamNotifier<List<ReportModel>> {
  final FirestoreService _service = FirestoreService();

  @override
  Stream<List<ReportModel>> build() {
    return _service.getReportsStream();
  }

  Future<void> addReport(ReportModel report) async {
    await _service.addReport(report);
  }

  Future<void> updateReport(String id, Map<String, dynamic> data) async {
    await _service.updateReport(id, data);
  }

  Future<void> deleteReport(String id) async {
    await _service.deleteReport(id);
  }
}

final reportProvider = StreamNotifierProvider<ReportNotifier, List<ReportModel>>(() {
  return ReportNotifier();
});