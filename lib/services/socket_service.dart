import 'package:get/get.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import '../utils/locat_storage.dart';

class SocketService extends GetxService {
  IO.Socket? _socket;
  final RxBool isConnected = false.obs;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _messageSentController = StreamController<Map<String, dynamic>>.broadcast();
  final _roomJoinedController = StreamController<Map<String, dynamic>>.broadcast();
  final _errorController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get onMessageReceived => _messageController.stream;
  Stream<Map<String, dynamic>> get onMessageSent => _messageSentController.stream;
  Stream<Map<String, dynamic>> get onRoomJoined => _roomJoinedController.stream;
  Stream<Map<String, dynamic>> get onError => _errorController.stream;
  Stream<bool> get onConnectionChanged => _connectionController.stream;

  bool _reconnecting = false;
  Timer? _reconnectTimer;
  String? _currentUserId;
  static const int _maxReconnectAttempts = 5;
  int _reconnectAttempts = 0;

  // Track pending room join requests
  final Map<String, Completer<String>> _pendingRoomJoins = {};

  @override
  void onClose() {
    _reconnectTimer?.cancel();
    _messageController.close();
    _messageSentController.close();
    _roomJoinedController.close();
    _errorController.close();
    _connectionController.close();
    disconnect();
    super.onClose();
  }

  Future<void> connect({String? userId}) async {
    _currentUserId = userId;

    if (_socket != null && _socket!.connected) {
      isConnected.value = true;
      _connectionController.add(true);
      return;
    }

    final token = await LocalStorageUtils.getToken();
    if (token == null || token.isEmpty) {
      _errorController.add({'error': 'No authentication token', 'showToUser': true});
      return Future.error('No authentication token');
    }

    try {
      String baseUrl = ApiUrls.baseUrl;
      if (baseUrl.endsWith('/api')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 4);
      } else if (baseUrl.contains('/api/')) {
        baseUrl = baseUrl.replaceAll('/api', '');
      }

      _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({
          'Authorization': 'Bearer $token',
        })
            .setAuth({'token': token})
            .build(),
      );

      _setupBasicListeners();
      _socket!.connect();

      Completer<void> connectionCompleter = Completer();
      Timer timeout = Timer(const Duration(seconds: 10), () {
        if (!connectionCompleter.isCompleted) {
          connectionCompleter.completeError('Connection timeout');
          _errorController.add({'error': 'Connection timeout', 'showToUser': true});
        }
      });

      _socket!.onConnect((_) {
        if (!connectionCompleter.isCompleted) {
          _reconnectAttempts = 0;
          connectionCompleter.complete();
          timeout.cancel();
        }
      });

      _socket!.onConnectError((error) {
        if (!connectionCompleter.isCompleted) {
          connectionCompleter.completeError('Connection error: $error');
        }
      });

      return connectionCompleter.future;
    } catch (e) {
      _errorController.add({'error': 'Failed to create socket connection', 'details': e.toString(), 'showToUser': true});
      return Future.error('Failed to create socket connection');
    }
  }

  void _setupBasicListeners() {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      print('✅ Socket connected');
      isConnected.value = true;
      _connectionController.add(true);
      _reconnecting = false;
      _reconnectAttempts = 0;
      _reconnectTimer?.cancel();

      if (_currentUserId != null) {
        _socket!.emit('userConnected', {'userId': _currentUserId});
      }
    });

    _socket!.onDisconnect((_) {
      print('❌ Socket disconnected');
      isConnected.value = false;
      _connectionController.add(false);
      _errorController.add({'error': 'Disconnected from server', 'showToUser': false});
      _attemptReconnect();
    });

    _socket!.onConnectError((error) {
      print('⚠️ Socket connection error: $error');
      isConnected.value = false;
      _connectionController.add(false);
      _errorController.add({'error': 'Connection error', 'details': error.toString(), 'showToUser': true});
      _attemptReconnect();
    });

    _socket!.onError((error) {
      print('⚠️ Socket error: $error');
      _errorController.add({'error': 'Socket error', 'details': error.toString(), 'showToUser': true});
    });

    _socket!.on('roomJoined', (data) {
      print('🚪 Room joined event received: $data');

      if (data is Map) {
        String? conversationId = data['conversationId']?.toString();

        if (conversationId != null) {
          // Try to find which pending room join this corresponds to
          // Since we don't have doctorId/patientId in the response,
          // we need to complete ALL pending joins with this conversationId
          // This is safe because room joins are sequential per conversation

          if (_pendingRoomJoins.isNotEmpty) {
            // Get the first pending completer (FIFO)
            var entry = _pendingRoomJoins.entries.first;
            String compositeId = entry.key;
            Completer<String> completer = entry.value;

            if (!completer.isCompleted) {
              print('✅ Completing room join for $compositeId with conversationId: $conversationId');
              completer.complete(conversationId);
              _pendingRoomJoins.remove(compositeId);
            }
          }
        }

        _roomJoinedController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('receiveMessage', (data) {
      print('📩 Receive message event: $data');
      if (data is Map) {
        _messageController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('messageSent', (data) {
      print('✅ Message sent confirmation: $data');
      if (data is Map) {
        _messageSentController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('chatError', (data) {
      print('⚠️ Chat error: $data');
      if (data is Map) {
        _errorController.add(Map<String, dynamic>.from(data));

        // Check if this error corresponds to a pending room join
        String? errorMsg = data['error']?.toString();
        if (errorMsg != null && errorMsg.contains('room') && _pendingRoomJoins.isNotEmpty) {
          var entry = _pendingRoomJoins.entries.first;
          String compositeId = entry.key;
          Completer<String> completer = entry.value;

          if (!completer.isCompleted) {
            completer.completeError('Failed to join room: $errorMsg');
            _pendingRoomJoins.remove(compositeId);
          }
        }
      }
    });
  }

  void _attemptReconnect() {
    if (_reconnecting || _reconnectAttempts >= _maxReconnectAttempts) {
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        _errorController.add({'error': 'Max reconnection attempts reached', 'showToUser': true});
      }
      return;
    }

    _reconnecting = true;
    _reconnectAttempts++;
    _reconnectTimer?.cancel();

    _reconnectTimer = Timer(Duration(seconds: _reconnectAttempts * 2), () {
      _reconnecting = false;
      connect(userId: _currentUserId);
    });
  }

  /// Join a room and return a Future that completes with the conversation ID
  Future<String> joinRoom({
    required String doctorId,
    required String patientId,
  }) async {
    if (!isConnected.value) {
      _errorController.add({'error': 'Cannot join room: Not connected', 'showToUser': true});
      return Future.error('Not connected');
    }

    final compositeId = '${doctorId}_${patientId}';

    // Check if there's already a pending join for this composite ID
    if (_pendingRoomJoins.containsKey(compositeId)) {
      print('⏳ Room join already pending for: $compositeId');
      return _pendingRoomJoins[compositeId]!.future;
    }

    print('🚪 Attempting to join room: $compositeId');

    // Create completer for this room join attempt
    Completer<String> completer = Completer();
    _pendingRoomJoins[compositeId] = completer;

    // Emit join room event with EXACT format your backend expects
    final roomData = {
      'doctorId': doctorId,
      'patientId': patientId,
    };

    _socket!.emit('joinRoom', roomData);

    // Set timeout for room join
    Timer timeout = Timer(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        print('⚠️ Room join timeout for: $compositeId');

        // Remove from pending
        _pendingRoomJoins.remove(compositeId);

        if (!completer.isCompleted) {
          completer.completeError('Failed to join chat room - timeout');
        }

        _errorController.add({
          'error': 'Failed to join chat room',
          'details': 'Timeout',
          'showToUser': true,
          'roomId': compositeId
        });
      }
    });

    // Clean up timeout when future completes
    completer.future.whenComplete(() {
      timeout.cancel();
    });

    // Return future that completes when room is joined or times out
    return completer.future;
  }

  /// Send message with automatic room joining if needed
  Future<void> sendMessage({
    required String doctorId,
    required String patientId,
    required String sender,
    required String message,
    String? tempId,
  }) async {
    if (!isConnected.value) {
      _errorController.add({'error': 'Cannot send message: Not connected', 'showToUser': true});
      return;
    }

    final compositeId = '${doctorId}_${patientId}';

    // Check if we need to join the room
    bool needToJoin = true;

    // Check if there's a pending or completed join for this room
    if (_pendingRoomJoins.containsKey(compositeId)) {
      try {
        print('⏳ Waiting for pending room join: $compositeId');
        await _pendingRoomJoins[compositeId]!.future;
        needToJoin = false;
      } catch (e) {
        // If pending join failed, we'll try again
        print('⚠️ Previous room join failed: $e');
        _pendingRoomJoins.remove(compositeId);
      }
    }

    // Join room if needed
    if (needToJoin) {
      print('📤 Not in room $compositeId, joining first...');
      try {
        String conversationId = await joinRoom(doctorId: doctorId, patientId: patientId);
        print('✅ Joined room with conversation ID: $conversationId');
      } catch (e) {
        _errorController.add({
          'error': 'Cannot send message: Failed to join room',
          'details': e.toString(),
          'showToUser': true,
          'roomId': compositeId
        });
        return;
      }
    }

    // Small delay to ensure room join is processed
    await Future.delayed(const Duration(milliseconds: 100));

    final messageData = {
      'doctorId': doctorId,
      'patientId': patientId,
      'sender': sender,
      'message': message,
      'tempId': tempId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
    };

    print('📤 Sending message to room $compositeId: $messageData');
    _socket!.emit('sendMessage', messageData);
  }

  void disconnect() {
    _reconnectTimer?.cancel();

    // Complete all pending room joins with error
    for (var entry in _pendingRoomJoins.entries) {
      if (!entry.value.isCompleted) {
        entry.value.completeError('Disconnected');
      }
    }
    _pendingRoomJoins.clear();

    if (_socket != null) {
      _socket!.off('roomJoined');
      _socket!.off('receiveMessage');
      _socket!.off('messageSent');
      _socket!.off('chatError');
      _socket!.off('connect');
      _socket!.off('disconnect');
      _socket!.off('connectError');
      _socket!.off('error');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      isConnected.value = false;
      _connectionController.add(false);
      _reconnecting = false;
      _reconnectAttempts = 0;
    }
  }

  bool get isSocketConnected => isConnected.value;
}