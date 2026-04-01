import 'dart:convert';
import 'package:pler_to_pler_app/features/trainer/schedule/data/data_sources/schedule_local_data_source.dart';
import 'package:pler_to_pler_app/features/trainer/schedule/data/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of ScheduleLocalDataSource using SharedPreferences
class ScheduleLocalDataSourceImpl implements ScheduleLocalDataSource {
  final SharedPreferences _prefs;

  ScheduleLocalDataSourceImpl(this._prefs);

  static const String _sessionsKey = 'cached_sessions';
  static const String _lastSyncKey = 'last_sync_time';

  @override
  Future<void> cacheSessions(List<SessionModel> sessions) async {
    final sessionsJson = sessions.map((s) => s.toJson()).toList();
    await _prefs.setString(_sessionsKey, jsonEncode(sessionsJson));
  }

  @override
  Future<List<SessionModel>?> getCachedSessions(DateTime date) async {
    final cached = _prefs.getString(_sessionsKey);
    if (cached == null) return null;

    try {
      final List<dynamic> sessionsJson = jsonDecode(cached);
      return sessionsJson
          .map((json) => SessionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCachedSessions() async {
    await _prefs.remove(_sessionsKey);
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    final timestamp = _prefs.getString(_lastSyncKey);
    if (timestamp == null) return null;
    return DateTime.tryParse(timestamp);
  }

  @override
  Future<void> updateLastSyncTime(DateTime time) async {
    await _prefs.setString(_lastSyncKey, time.toIso8601String());
  }
}
