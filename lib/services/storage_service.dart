import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _pendingKey = 'pending_tasks';
  static const _sessionKey = 'logged_in';

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, value);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionKey) ?? false;
  }

  Future<void> savePendingTask(Map<String, dynamic> task) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_pendingKey) ?? <String>[];
    existing.removeWhere((item) => (jsonDecode(item)['id'] ?? '') == task['id']);
    existing.add(jsonEncode(task));
    await prefs.setStringList(_pendingKey, existing);
  }

  Future<List<Map<String, dynamic>>> getPendingTasks() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_pendingKey) ?? <String>[])
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  Future<void> removePendingTask(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_pendingKey) ?? <String>[];
    existing.removeWhere((item) => (jsonDecode(item)['id'] ?? '') == id);
    await prefs.setStringList(_pendingKey, existing);
  }
}
