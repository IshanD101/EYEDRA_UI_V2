import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:async';

class SocketService {
  // The socket instance
  static io.Socket? _socket;

  // Stream controllers for different socket events
  static final StreamController<Map<String, dynamic>> _userJoinedController =
  StreamController<Map<String, dynamic>>.broadcast();
  static final StreamController<Map<String, dynamic>> _userLeftController =
  StreamController<Map<String, dynamic>>.broadcast();
  static final StreamController<List<dynamic>> _participantListController =
  StreamController<List<dynamic>>.broadcast();
  static final StreamController<Map<String, dynamic>> _newMessageController =
  StreamController<Map<String, dynamic>>.broadcast();

  // Streams that UI can listen to
  static Stream<Map<String, dynamic>> get userJoined => _userJoinedController.stream;
  static Stream<Map<String, dynamic>> get userLeft => _userLeftController.stream;
  static Stream<List<dynamic>> get participantList => _participantListController.stream;
  static Stream<Map<String, dynamic>> get newMessage => _newMessageController.stream;

  // Initialize socket connection
  static void initSocket(String serverUrl) {
    _socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _setupSocketListeners();
  }

  // Set up socket event listeners
  static void _setupSocketListeners() {
    _socket?.on('connect', (_) {
      print('Socket connected: ${_socket?.id}');
    });

    _socket?.on('disconnect', (_) {
      print('Socket disconnected');
    });

    _socket?.on('user-joined', (data) {
      _userJoinedController.add(data);
    });

    _socket?.on('user-left', (data) {
      _userLeftController.add(data);
    });

    _socket?.on('participant-list', (data) {
      _participantListController.add(data);
    });

    _socket?.on('new-message', (data) {
      _newMessageController.add(data);
    });

    _socket?.on('connect_error', (data) {
      print('Socket connect error: $data');
    });
  }

  // Join a session
  static void joinSession(String sessionId, Map<String, dynamic> user) {
    _socket?.emit('join-session', {
      'sessionId': sessionId,
      'user': user,
    });
  }

  // Leave a session
  static void leaveSession() {
    _socket?.emit('leave-session');
  }

  // Send a chat message
  static void sendMessage(String sessionId, String message) {
    _socket?.emit('send-message', {
      'sessionId': sessionId,
      'message': message,
    });
  }

  // Disconnect socket
  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  // Clean up resources
  static void dispose() {
    _userJoinedController.close();
    _userLeftController.close();
    _participantListController.close();
    _newMessageController.close();
    disconnect();
  }
}