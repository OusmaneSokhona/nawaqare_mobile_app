import 'package:get/get.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/locat_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../controllers/patient_controllers/home_controller.dart';

class SocketService extends GetxService {
  IO.Socket? _socket;
  final HomeController homeController = Get.find();
  final RxBool _isConnected = false.obs;

  RxBool get isConnected => _isConnected;
  bool get isConnectedValue => _isConnected.value;

  IO.Socket get socket {
    if (_socket == null) {
      throw Exception('Socket not initialized. Call connect() first.');
    }
    return _socket!;
  }

  Future<void> connect() async {
    final token = await LocalStorageUtils.getToken();
    if (token == null) {
      print('No token found, cannot connect socket');
      return;
    }

    try {
      _socket = IO.io(
        ApiUrls.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({'token': token})
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .build(),
      );

      _setupBasicListeners();
      _socket!.connect();
    } catch (e) {
      print('Error creating socket: $e');
    }
  }

  void _setupBasicListeners() {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      print('Socket connected successfully');
      _isConnected.value = true;
    });

    _socket!.onDisconnect((_) {
      print('Socket disconnected');
      _isConnected.value = false;
    });

    _socket!.onConnectError((error) {
      print('Socket connection error: $error');
      _isConnected.value = false;
    });

    _socket!.onError((error) {
      print('Socket error: $error');
    });
  }

  void joinRoom({required String doctorId, required String patientId}) {
    if (_socket == null || !_socket!.connected) {
      print('Socket not connected, cannot join room');
      return;
    }
    _socket!.emit('joinRoom', {
      'doctorId': doctorId,
      'patientId': patientId,
    });
  }

  void sendMessage({
    required String doctorId,
    required String patientId,
    required String sender,
    required String message,
  }) {
    if (_socket == null || !_socket!.connected) {
      print('Socket not connected, cannot send message');
      return;
    }

    final messageData = {
      'doctorId': doctorId,
      'patientId': patientId,
      'sender': sender,
      'message': message,
    };

    print('Sending message via socket: $messageData');
    _socket!.emit('sendMessage', messageData);
  }

  void onRoomJoined(Function(dynamic) callback) {
    if (_socket == null) return;
    _socket!.on('roomJoined', (data) {
      print('Room joined: $data');
      callback(data);
    });
  }

  void onReceiveMessage(Function(dynamic) callback) {
    if (_socket == null) return;
    _socket!.on('receiveMessage', (data) {
      print('Receive message event: $data');
      callback(data);
    });
  }

  void onChatError(Function(dynamic) callback) {
    if (_socket == null) return;
    _socket!.on('chatError', (data) {
      print('Chat error: $data');
      callback(data);
    });
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
      _isConnected.value = false;
    }
  }
}