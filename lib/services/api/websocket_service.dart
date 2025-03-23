import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'auth_service.dart';

class WebSocketService {
  final String baseWsUrl = 'wss://your-websocket-server.com'; // Replace with your WebSocket URL
  final AuthService _authService = AuthService();
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _streamController;
  String? _currentGroupId;
  Timer? _heartbeatTimer;
  bool _reconnecting = false;

  // Initialize a WebSocket connection for a specific group
  Future<Stream<Map<String, dynamic>>> connectToGroup(String groupId) async {
    // Close existing connection if any
    await disconnectFromGroup();

    _currentGroupId = groupId;
    final token = await _authService.getToken();
    final userId = await _authService.getUserId();
    final username = await _authService.getUsername();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final url = '$baseWsUrl/chat/$groupId?token=$token&userId=$userId&username=$username';

    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(url));
      _streamController = StreamController<Map<String, dynamic>>.broadcast();

      // Listen to incoming messages
      _channel!.stream.listen(
            (dynamic message) {
          try {
            final decodedMessage = json.decode(message as String) as Map<String, dynamic>;

            // If the message is for the current user, mark it as such
            if (decodedMessage['userId'] == userId) {
              decodedMessage['isCurrentUser'] = true;
            }

            _streamController!.add(decodedMessage);
          } catch (e) {
            print("Error parsing message: $e");
          }
        },
        onDone: () {
          print("WebSocket connection closed");
          _attemptReconnect();
        },
        onError: (error) {
          print("WebSocket error: $error");
          _attemptReconnect();
        },
        cancelOnError: false,
      );

      // Start heartbeat to keep connection alive
      _startHeartbeat();

      // Send a join message
      _sendJoinMessage();

      return _streamController!.stream;
    } catch (e) {
      print("WebSocket connection error: $e");
      _attemptReconnect();
      // Return an empty stream while attempting to reconnect
      return _streamController?.stream ?? Stream.empty();
    }
  }

  void _attemptReconnect() {
    if (!_reconnecting && _currentGroupId != null) {
      _reconnecting = true;
      Future.delayed(Duration(seconds: 3), () async {
        try {
          await connectToGroup(_currentGroupId!);
        } finally {
          _reconnecting = false;
        }
      });
    }
  }

  void _sendJoinMessage() async {
    final userId = await _authService.getUserId();
    final username = await _authService.getUsername();
    final userRole = await _authService.getUserRole();

    if (_channel != null && _channel!.sink != null) {
      final joinData = {
        'type': 'join',
        'userId': userId,
        'username': username,
        'userRole': userRole,
        'groupId': _currentGroupId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel!.sink.add(json.encode(joinData));
    }
  }

  // Send a message through the WebSocket
  Future<void> sendMessage(String message) async {
    if (_channel != null && _channel!.sink != null) {
      final userId = await _authService.getUserId();
      final username = await _authService.getUsername();

      final messageData = {
        'type': 'message',
        'content': message,
        'userId': userId,
        'username': username,
        'groupId': _currentGroupId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel!.sink.add(json.encode(messageData));
    }
  }

  // Send a moderation action (for admins and listeners)
  Future<void> sendModeration(String action, String targetUserId, String? messageId) async {
    final userRole = await _authService.getUserRole();

    // Only allow admins and listeners to moderate
    if (userRole != 'Admin' && userRole != 'Listener') {
      print('Unauthorized moderation attempt');
      return;
    }

    if (_channel != null && _channel!.sink != null) {
      final userId = await _authService.getUserId();
      final username = await _authService.getUsername();

      final moderationData = {
        'type': 'moderation',
        'action': action, // 'delete_message', 'ban_user', etc.
        'targetUserId': targetUserId,
        'messageId': messageId,
        'moderatorId': userId,
        'moderatorName': username,
        'moderatorRole': userRole,
        'groupId': _currentGroupId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel!.sink.add(json.encode(moderationData));
    }
  }

  // Disconnect from the current group
  Future<void> disconnectFromGroup() async {
    _stopHeartbeat();

    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
    }

    if (_streamController != null && !_streamController!.isClosed) {
      await _streamController!.close();
      _streamController = null;
    }

    _currentGroupId = null;
  }

  // Start heartbeat timer
  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_channel != null && _channel!.sink != null) {
        _channel!.sink.add(json.encode({'type': 'heartbeat'}));
      }
    });
  }

  // Stop heartbeat timer
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }
}