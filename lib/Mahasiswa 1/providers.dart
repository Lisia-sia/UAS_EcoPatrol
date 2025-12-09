import 'package:flutter_riverpod/flutter_riverpod.dart'; // WAJIB ADA
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart'; // WAJIB ADA
import 'db_helper.dart'; // Pastikan file db_helper.dart ada di folder yang sama

// --- AUTH PROVIDER ---
class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Simpan status
    await prefs.setString('username', username); // Simpan nama pengguna
    state = true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    state = false;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

// --- REPORT PROVIDER ---
class ReportNotifier extends StateNotifier<List<ReportModel>> {
  ReportNotifier() : super([]) {
    loadReports();
  }

  Future<void> loadReports() async {
    final data = await DatabaseHelper.instance.readAllReports();
    state = data;
  }

  Future<void> addReport(ReportModel report) async {
    await DatabaseHelper.instance.create(report);
    loadReports();
  }

  Future<void> updateReport(ReportModel report) async {
    await DatabaseHelper.instance.update(report);
    loadReports();
  }

  Future<void> deleteReport(int id) async {
    await DatabaseHelper.instance.delete(id);
    loadReports();
  }
}

final reportProvider = StateNotifierProvider<ReportNotifier, List<ReportModel>>((ref) {
  return ReportNotifier();
});