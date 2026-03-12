import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/chat_model.dart';
import 'package:patient_app/models/user_model.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/services/socket_service.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/utils/api_urls.dart';

class ChatController extends GetxController {
  ScrollController scrollController = ScrollController();
  ApiService apiService = ApiService();
  SocketService socketService = SocketService();
  HomeController homeController = Get.find();

  RxDouble scrollValue = 0.0.obs;
  final RxList<Conversation> _conversations = <Conversation>[].obs;
  final RxList<ChatMessage> _messages = <ChatMessage>[].obs;
  final RxString _searchQuery = ''.obs;
  final TextEditingController messageInputController = TextEditingController();

  Rx<Conversation?> selectedConversation = Rx<Conversation?>(null);
  RxBool isLoading = false.obs;
  RxBool isLoadingMessages = false.obs;
  bool _listenersSetup = false;
  String? _currentRoomId;

  List<Conversation> get filteredConversations => _conversations.where((conv) {
    final doctor = conv.getDoctor();
    return doctor?.fullName.toLowerCase().contains(_searchQuery.value.toLowerCase()) ?? false;
  }).toList();

  List<ChatMessage> get messages => _messages;
  Participant? get selectedDoctor => selectedConversation.value?.getDoctor();

  void sendMessage() {
    final text = messageInputController.text.trim();
    if (text.isEmpty) {
      return;
    }

    if (selectedConversation.value == null) {
      Get.snackbar('Error', 'No conversation selected');
      return;
    }

    if (!socketService.isConnectedValue) {
      Get.snackbar(
        'Connecting',
        'Reconnecting to chat server...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );

      socketService.connect();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (socketService.isConnectedValue) {
            _joinRoomAndSendMessage(text);
          }
        });
      });
    } else {
      _joinRoomAndSendMessage(text);
    }
  }

  void _joinRoomAndSendMessage(String text) {
    try {
      final conversation = selectedConversation.value;
      if (conversation == null) {
        Get.snackbar('Error', 'Conversation not found');
        return;
      }

      final currentUser = homeController.currentUser.value;
      if (currentUser == null) {
        Get.snackbar('Error', 'User not found');
        return;
      }

      final doctor = conversation.getDoctor();
      final patient = conversation.getPatient();

      if (doctor == null || patient == null) {
        Get.snackbar('Error', 'Doctor or patient information missing');
        return;
      }

      // Join the room first
      socketService.joinRoom(
        doctorId: doctor.id,
        patientId: patient.id,
      );

      // Store room ID for reference
      _currentRoomId = '${doctor.id}_${patient.id}';

      // Create temp message
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();

      String profileImage = '';
      if (currentUser.patientData != null && currentUser.patientData!.profileImage != null) {
        profileImage = currentUser.patientData!.profileImage!;
      }

      final tempMessage = ChatMessage(
        id: tempId,
        conversationId: conversation.id,
        sender: currentUser.id!,
        receiver: currentUser.id == doctor.id ? patient.id : doctor.id,
        message: text,
        status: 'sending',
        messageType: 'text',
        createdAt: DateTime.now(),
        senderDetails: Participant(
          id: currentUser.id!,
          fullName: currentUser.fullName ?? '',
          profileImage: profileImage,
          role: currentUser.role.value ?? 'patient',
        ),
        receiverDetails: null,
      );

      _messages.insert(0, tempMessage);
      _messages.refresh();

      messageInputController.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      // Send message with correct format
      socketService.sendMessage(
        doctorId: doctor.id,
        patientId: patient.id,
        sender: currentUser.id!,
        message: text,
      );

      // Handle message timeout
      _handleMessageTimeout(tempId, text);

    } catch (e) {
      print('Error in _joinRoomAndSendMessage: $e');
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _handleMessageTimeout(String tempId, String originalText) {
    Future.delayed(const Duration(seconds: 5), () {
      try {
        if (_messages.isNotEmpty) {
          final messageIndex = _messages.indexWhere((m) => m.id == tempId);
          if (messageIndex != -1 && _messages[messageIndex].status == 'sending') {
            final failedMessage = ChatMessage(
              id: _messages[messageIndex].id,
              conversationId: _messages[messageIndex].conversationId,
              sender: _messages[messageIndex].sender,
              receiver: _messages[messageIndex].receiver,
              message: _messages[messageIndex].message,
              status: 'failed',
              messageType: _messages[messageIndex].messageType,
              createdAt: _messages[messageIndex].createdAt,
              senderDetails: _messages[messageIndex].senderDetails,
              receiverDetails: _messages[messageIndex].receiverDetails,
            );
            _messages[messageIndex] = failedMessage;
            _messages.refresh();

            Get.snackbar(
              'Message Failed',
              'Tap to retry',
              snackPosition: SnackPosition.BOTTOM,
              mainButton: TextButton(
                onPressed: () {
                  messageInputController.text = originalText;
                  sendMessage();
                },
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
            );
          }
        }
      } catch (e) {
        print('Error in message timeout: $e');
      }
    });
  }

  void setupSocketListeners() {
    // Listen for room joined confirmation
    socketService.onRoomJoined((data) {
      print('Room joined successfully: $data');
    });

    // Listen for incoming messages
    socketService.onReceiveMessage((data) {
      try {
        print('New message received: $data');

        // Check if this message is for current conversation
        final currentConv = selectedConversation.value;
        if (currentConv != null) {
          final doctor = currentConv.getDoctor();
          final patient = currentConv.getPatient();

          if (doctor != null && patient != null) {
            final messageDoctorId = data['doctorId']?.toString();
            final messagePatientId = data['patientId']?.toString();

            if (messageDoctorId == doctor.id && messagePatientId == patient.id) {
              final newMessage = ChatMessage(
                id: data['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
                conversationId: currentConv.id,
                sender: data['sender'] ?? '',
                receiver: data['sender'] == doctor.id ? patient.id : doctor.id,
                message: data['message'] ?? '',
                status: 'delivered',
                messageType: 'text',
                createdAt: DateTime.now(),
                senderDetails: null,
                receiverDetails: null,
              );

              _messages.insert(0, newMessage);
              _messages.refresh();
            }
          }
        }
      } catch (e) {
        print('Error processing received message: $e');
      }
    });

    // Listen for chat errors
    socketService.onChatError((error) {
      print('Chat error received: $error');

      // Mark all sending messages as failed
      final sendingMessages = _messages.where((m) => m.status == 'sending').toList();
      for (var message in sendingMessages) {
        final index = _messages.indexOf(message);
        if (index != -1) {
          final failedMessage = ChatMessage(
            id: message.id,
            conversationId: message.conversationId,
            sender: message.sender,
            receiver: message.receiver,
            message: message.message,
            status: 'failed',
            messageType: message.messageType,
            createdAt: message.createdAt,
            senderDetails: message.senderDetails,
            receiverDetails: message.receiverDetails,
          );
          _messages[index] = failedMessage;
        }
      }
      _messages.refresh();

      Get.snackbar(
        'Error',
        'Failed to send message. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    });
  }

  @override
  void onInit() {
    super.onInit();
    scrollChange();
    _initializeSocketConnection();
  }

  void _initializeSocketConnection() {
    if (!socketService.isConnectedValue) {
      socketService.connect();
    }

    _initializeSocketListeners();
    fetchConversations();
  }

  void _initializeSocketListeners() {
    if (socketService.isConnectedValue) {
      setupSocketListeners();
      _listenersSetup = true;
    } else {
      ever(socketService.isConnected, (connected) {
        if (connected && !_listenersSetup) {
          setupSocketListeners();
          _listenersSetup = true;
        }
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (socketService.isConnectedValue && !_listenersSetup) {
          setupSocketListeners();
          _listenersSetup = true;
        }
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (!socketService.isConnectedValue) {
      socketService.connect();
    }
  }

  void scrollChange() {
    scrollController.addListener(() {
      scrollValue.value = scrollController.offset;
    });
  }

  Future<void> fetchConversations() async {
    var userId = homeController.currentUser.value?.id;
    isLoading.value = true;
    try {
      final response = await apiService.get("${ApiUrls.getConversation}/$userId");

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          final List conversations = response.data['data'] ??
              response.data['conversations'] ??
              response.data['results'] ?? [];

          _conversations.assignAll(
              conversations.map((c) => Conversation.fromJson(c)).toList()
          );
        } else {
          if (response.data is List) {
            _conversations.assignAll(
                response.data.map((c) => Conversation.fromJson(c)).toList()
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching conversations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMessages(String conversationId) async {
    isLoadingMessages.value = true;
    try {
      final response = await apiService.get('${ApiUrls.getMessages}$conversationId');

      if (response.statusCode == 200) {
        dynamic responseData = response.data;

        List<dynamic> messagesList = [];

        if (responseData is Map<String, dynamic>) {
          messagesList = responseData['messages'] ??
              responseData['data'] ??
              responseData['results'] ??
              [];
        } else if (responseData is List) {
          messagesList = responseData;
        }

        _messages.assignAll(
            messagesList.map((m) {
              try {
                return ChatMessage.fromJson(m);
              } catch (e) {
                print('Error parsing message: $e');
                return null;
              }
            }).whereType<ChatMessage>().toList()
        );
      }
    } catch (e) {
      print('Error fetching messages: $e');
      Get.snackbar(
        'Error',
        'Failed to load messages',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMessages.value = false;
    }
  }

  void selectConversation(Conversation conversation) {
    selectedConversation.value = conversation;
    fetchMessages(conversation.id);

    if (!socketService.isConnectedValue) {
      socketService.connect();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  String formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : hour;
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate.isAtSameMomentAs(today)) {
      return 'Today, ${_getMonthName(date.month)} ${date.day}, ${date.year}';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (messageDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday, ${_getMonthName(date.month)} ${date.day}, ${date.year}';
    }

    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String getLastMessageTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate.isAtSameMomentAs(today)) {
      return formatTime(date);
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (messageDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    }

    return '${date.day} ${_getMonthName(date.month)}';
  }

  @override
  void onClose() {
    scrollController.dispose();
    messageInputController.dispose();
    socketService.disconnect();
    super.onClose();
  }
}
