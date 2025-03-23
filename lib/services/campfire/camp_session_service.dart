import 'camp_session_model.dart';
import 'campfire_api_service.dart';

class CampSessionService {
  // Fetch active sessions from the backend
  static Future<List<CampSession>> fetchSessions() async {
    try {
      final sessionsData = await ApiService.getActiveSessions();
      return sessionsData.map((data) => CampSession.fromJson(data)).toList();
    } catch (e) {
      print('Error in fetchSessions: $e');
      return [];
    }
  }

  // Create a new session
  static Future<Map<String, dynamic>> createSession(String title, String category) async {
    return await ApiService.createSession(title, category);
  }

  // Join an existing session
  static Future<Map<String, dynamic>> joinSession(String sessionId) async {
    return await ApiService.joinSession(sessionId);
  }

  // End a session (host only)
  static Future<bool> endSession(String sessionId) async {
    return await ApiService.endSession(sessionId);
  }
}