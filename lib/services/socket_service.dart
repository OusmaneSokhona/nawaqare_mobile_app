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
      isConnected.value = false;
      _connectionController.add(false);
      _errorController.add({'error': 'Disconnected from server', 'showToUser': false});
      _attemptReconnect();
    });

    _socket!.onConnectError((error) {
      isConnected.value = false;
      _connectionController.add(false);
      _errorController.add({'error': 'Connection error', 'details': error.toString(), 'showToUser': true});
      _attemptReconnect();
    });

    _socket!.onError((error) {
      _errorController.add({'error': 'Socket error', 'details': error.toString(), 'showToUser': true});
    });

    _socket!.on('roomJoined', (data) {
      if (data is Map) {
        _roomJoinedController.add(Map<String, dynamic>.from(data));
      } else {
        _roomJoinedController.add({'data': data});
      }
    });

    _socket!.on('receiveMessage', (data) {
      if (data is Map) {
        _messageController.add(Map<String, dynamic>.from(data));
      } else {
        _messageController.add({'data': data});
      }
    });

    _socket!.on('messageSent', (data) {
      if (data is Map) {
        _messageSentController.add(Map<String, dynamic>.from(data));
      } else {
        _messageSentController.add({'data': data});
      }
    });

    _socket!.on('chatError', (data) {
      if (data is Map) {
        _errorController.add(Map<String, dynamic>.from(data));
      } else {
        _errorController.add({'error': data.toString(), 'showToUser': true});
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

  void joinRoom({
    required String doctorId,
    required String patientId,
  }) {
    if (!isConnected.value) {
      _errorController.add({'error': 'Cannot join room: Not connected', 'showToUser': true});
      return;
    }

    final roomData = {
      'doctorId': doctorId,
      'patientId': patientId,
      'conversationId': '${doctorId}_${patientId}',
    };

    _socket!.emit('joinRoom', roomData);
  }

  void sendMessage({
    required String doctorId,
    required String patientId,
    required String sender,
    required String message,
    String? tempId,
  }) {
    if (!isConnected.value) {
      _errorController.add({'error': 'Cannot send message: Not connected', 'showToUser': true});
      return;
    }

    final messageData = {
      'doctorId': doctorId,
      'patientId': patientId,
      'sender': sender,
      'message': message,
      'tempId': tempId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
      'timestamp': DateTime.now().toIso8601String(),
      'conversationId': '${doctorId}_${patientId}',
    };

    _socket!.emit('sendMessage', messageData);
  }

  void disconnect() {
    _reconnectTimer?.cancel();
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