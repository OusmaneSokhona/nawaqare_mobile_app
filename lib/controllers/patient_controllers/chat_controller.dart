import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/chat_model.dart';
import 'package:patient_app/models/user_model.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/services/socket_service.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/utils/api_urls.dart';

class ChatController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final ApiService apiService = ApiService();
  final SocketService socketService = Get.put(SocketService());
  final HomeController homeController = Get.find<HomeController>();

  final TextEditingController messageInputController = TextEditingController();

  final RxDouble scrollValue = 0.0.obs;
  final RxList<Conversation> conversations = <Conversation>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<Conversation?> selectedConversation = Rx<Conversation?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMessages = false.obs;
  final RxString errorMessage = ''.obs;

  String? currentRoomId;
  final Map<String, Timer> _messageTimers = {};

  late StreamSubscription<Map<String, dynamic>> _messageSubscription;
  late StreamSubscription<Map<String, dynamic>> _messageSentSubscription;
  late StreamSubscription<Map<String, dynamic>> _errorSubscription;
  late StreamSubscription<bool> _connectionSubscription;
  late StreamSubscription<Map<String, dynamic>> _roomJoinedSubscription;

  List<Conversation> get filteredConversations {
    final currentUserRole = homeController.currentUser.value?.role;
    final currentUserId = homeController.currentUser.value?.userId;

    if (searchQuery.value.isEmpty) {
      return conversations;
    }

    return conversations.where((conv) {
      // First apply role-based filtering
      if (currentUserRole?.value == 'doctor') {
        if (!(conv.participants?.any((p) => p.role == 'patient') ?? false)) {
          return false;
        }
      } else if (currentUserRole?.value == 'patient') {
        if (!(conv.participants?.any((p) => p.role == 'doctor') ?? false)) {
          return false;
        }
      }

      // Then apply search filter
      final other = getOtherParticipant(conv);
      if (other == null || other.id.isEmpty) return false;

      return other.fullName.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  Participant? getOtherParticipant(Conversation conversation) {
    final currentUserId = homeController.currentUser.value?.userId;
    if (currentUserId == null) return null;

    return conversation.participants?.firstWhere(
          (p) => p.id != currentUserId,
      orElse: () => Participant(id: '', fullName: '', profileImage: '', role: ''),
    );
  }

  Participant? get otherParticipant {
    final currentUserId = homeController.currentUser.value?.userId;
    if (currentUserId == null || selectedConversation.value == null) return null;

    return selectedConversation.value?.participants?.firstWhere(
          (p) => p.id != currentUserId,
      orElse: () => Participant(id: '', fullName: '', profileImage: '', role: ''),
    );
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    _setupStreamSubscriptions();
  }

  void _onScroll() {
    scrollValue.value = scrollController.position.pixels;
  }

  @override
  void onReady() {
    super.onReady();
    initializeSocketConnection();
  }

  void _setupStreamSubscriptions() {
    _messageSubscription = socketService.onMessageReceived.listen((data) {
      _handleIncomingMessage(data);
    });

    _messageSentSubscription = socketService.onMessageSent.listen((data) {
      _handleMessageSent(data);
    });

    _errorSubscription = socketService.onError.listen((error) {
      _handleSocketError(error);
    });

    _connectionSubscription = socketService.onConnectionChanged.listen((connected) {
      if (connected) {
        errorMessage.value = '';
        if (selectedConversation.value != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            joinCurrentRoom();
          });
        }
      }
    });

    _roomJoinedSubscription = socketService.onRoomJoined.listen((data) {
      currentRoomId = data['conversationId']?.toString() ??
          '${data['doctorId']}_${data['patientId']}';
    });
  }

  void _handleSocketError(Map<String, dynamic> error) {
    String errorText = error['error']?.toString() ?? 'Unknown socket error';
    bool showToUser = error['showToUser'] ?? false;

    if (showToUser) {
      errorMessage.value = errorText;
    }

    _handleMessageFailure();
  }

  @override
  void onClose() {
    _messageSubscription.cancel();
    _messageSentSubscription.cancel();
    _errorSubscription.cancel();
    _connectionSubscription.cancel();
    _roomJoinedSubscription.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    messageInputController.dispose();
    for (var timer in _messageTimers.values) {
      timer.cancel();
    }
    _messageTimers.clear();
    super.onClose();
  }

  Future<void> initializeSocketConnection() async {
    final userId = homeController.currentUser.value?.userId;
    try {
      if (!socketService.isConnected.value) {
        await socketService.connect(userId: userId);
      }
      await fetchConversations();
    } catch (error) {
      errorMessage.value = 'Socket connection failed: $error';
      await fetchConversations();
    }
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    try {
      if (data.isEmpty) return;

      final currentConv = selectedConversation.value;
      final currentUserId = homeController.currentUser.value?.userId?.toString();

      final incomingConvId = data['conversationId']?.toString();
      final messageSenderId = data['sender']?.toString() ?? data['senderId']?.toString();
      final messageText = data['message']?.toString() ?? '';

      final messageId = data['_id']?.toString() ??
          data['id']?.toString() ??
          'msg_${DateTime.now().millisecondsSinceEpoch}';

      final createdAt = data['createdAt'] != null
          ? DateTime.parse(data['createdAt']).toLocal()
          : DateTime.now();

      if (currentConv != null && (incomingConvId == currentConv.id || incomingConvId == null)) {
        final participants = currentConv.participants ?? [];

        if (messageSenderId == currentUserId) {
          final pendingIndex = messages.indexWhere((m) =>
          (m.status == 'sending' || m.id.startsWith('temp_')) && m.message == messageText);

          if (pendingIndex != -1) {
            final otherParticipant = getOtherParticipant(currentConv);

            messages[pendingIndex] = ChatMessage(
              id: messageId,
              conversationId: currentConv.id,
              sender: currentUserId!,
              receiver: otherParticipant?.id ?? '',
              message: messageText,
              status: 'sent',
              messageType: data['messageType']?.toString() ?? 'text',
              createdAt: createdAt,
              senderDetails: messages[pendingIndex].senderDetails,
              receiverDetails: messages[pendingIndex].receiverDetails,
            );
            messages.refresh();

            final tempId = messages[pendingIndex].id;
            _messageTimers[tempId]?.cancel();
            _messageTimers.remove(tempId);
            return;
          }
        }

        final isParticipant = participants.any((p) => p.id == messageSenderId);
        if (isParticipant || incomingConvId == currentConv.id) {
          final existingIndex = messages.indexWhere((m) => m.id == messageId);
          if (existingIndex == -1) {
            Participant? senderDetails = participants.firstWhereOrNull((p) => p.id == messageSenderId);
            Participant? receiverDetails = participants.firstWhereOrNull((p) => p.id != messageSenderId);

            final newMessage = ChatMessage(
              id: messageId,
              conversationId: currentConv.id,
              sender: messageSenderId ?? '',
              receiver: receiverDetails?.id ?? '',
              message: messageText,
              status: 'delivered',
              messageType: data['messageType']?.toString() ?? 'text',
              createdAt: createdAt,
              senderDetails: senderDetails,
              receiverDetails: receiverDetails,
            );

            messages.insert(0, newMessage);
            messages.refresh();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollToBottom();
            });

            _updateLastMessageInConversation(currentConv.id, newMessage);
          }
        }
      } else if (incomingConvId != null) {
        fetchConversations();
      }
    } catch (e) {
      errorMessage.value = 'Error processing message: $e';
    }
  }

  void _handleMessageTimeout(String tempId, String originalText) {
    final timer = Timer(const Duration(seconds: 10), () {
      if (!isClosed) {
        final messageIndex = messages.indexWhere((m) => m.id == tempId);
        if (messageIndex != -1 && messages[messageIndex].status == 'sending') {
          final messageExists = messages.any((m) =>
          m.message == originalText &&
              (m.status == 'sent' || m.status == 'delivered'));

          if (!messageExists) {
            final failedMessage = ChatMessage(
              id: messages[messageIndex].id,
              conversationId: messages[messageIndex].conversationId,
              sender: messages[messageIndex].sender,
              receiver: messages[messageIndex].receiver,
              message: messages[messageIndex].message,
              status: 'failed',
              messageType: messages[messageIndex].messageType,
              createdAt: messages[messageIndex].createdAt,
              senderDetails: messages[messageIndex].senderDetails,
              receiverDetails: messages[messageIndex].receiverDetails,
            );
            messages[messageIndex] = failedMessage;
            messages.refresh();

            if (Get.context != null) {
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
                backgroundColor: Colors.red.shade800,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
              );
            }
          }
        }
        _messageTimers.remove(tempId);
      }
    });

    _messageTimers[tempId] = timer;
  }

  void _handleMessageSent(Map<String, dynamic> data) {
    try {
      if (data.isEmpty) return;

      final tempId = data['tempId']?.toString();
      final messageId = data['messageId']?.toString() ?? data['_id']?.toString() ??
          data['id']?.toString();

      if (tempId != null && messageId != null) {
        final index = messages.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          final updatedMessage = ChatMessage(
            id: messageId,
            conversationId: messages[index].conversationId,
            sender: messages[index].sender,
            receiver: messages[index].receiver,
            message: messages[index].message,
            status: 'sent',
            messageType: messages[index].messageType,
            createdAt: messages[index].createdAt,
            senderDetails: messages[index].senderDetails,
            receiverDetails: messages[index].receiverDetails,
          );
          messages[index] = updatedMessage;
          messages.refresh();
        }

        final timer = _messageTimers[tempId];
        if (timer != null) {
          timer.cancel();
          _messageTimers.remove(tempId);
        }
      }
    } catch (e) {
      errorMessage.value = 'Error processing sent message: $e';
    }
  }

  void joinCurrentRoom() {
    final conversation = selectedConversation.value;
    if (conversation == null) return;

    final participants = conversation.participants ?? [];
    final doctor = participants.firstWhere(
          (p) => p.role == 'doctor',
      orElse: () => Participant(id: '', fullName: '', profileImage: '', role: ''),
    );
    final patient = participants.firstWhere(
          (p) => p.role == 'patient',
      orElse: () => Participant(id: '', fullName: '', profileImage: '', role: ''),
    );

    if (doctor.id.isNotEmpty && patient.id.isNotEmpty) {
      currentRoomId = '${doctor.id}_${patient.id}';
      socketService.joinRoom(
        doctorId: doctor.id,
        patientId: patient.id,
      );
    }
  }

  void _updateLastMessageInConversation(String conversationId, ChatMessage message) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final lastMessage = LastMessage(
        id: message.id,
        conversationId: message.conversationId,
        sender: message.sender,
        receiver: message.receiver,
        message: message.message,
        status: message.status,
        messageType: message.messageType,
        createdAt: message.createdAt,
      );

      final existingConv = conversations[index];
      final updatedConversation = Conversation(
        id: existingConv.id,
        participants: existingConv.participants,
        lastMessage: lastMessage,
        createdAt: existingConv.createdAt,
        updatedAt: DateTime.now(),
      );

      conversations[index] = updatedConversation;

      conversations.sort((a, b) {
        final aTime = a.lastMessage?.createdAt ?? a.updatedAt ?? a.createdAt;
        final bTime = b.lastMessage?.createdAt ?? b.updatedAt ?? b.createdAt;
        return bTime.compareTo(aTime);
      });

      conversations.refresh();
    }
  }

  void _handleMessageFailure() {
    final sendingMessages = messages.where((m) => m.status == 'sending').toList();
    for (var message in sendingMessages) {
      final index = messages.indexOf(message);
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
        messages[index] = failedMessage;
      }
    }
    messages.refresh();
  }

  Future<void> fetchConversations() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await apiService.get('${ApiUrls.getConversation}');

      if (response.statusCode == 200) {
        List<dynamic> conversationsData = [];

        if (response.data is Map) {
          conversationsData = response.data['conversations'] ?? [];
        } else if (response.data is List) {
          conversationsData = response.data;
        }

        final String? currentUserId = homeController.currentUser.value?.userId?.toString().trim();

        print("MY LOGGED IN ID: $currentUserId");

        final conversationList = conversationsData
            .map((c) => Conversation.fromJson(c as Map<String, dynamic>))
            .toList();

        // 2. Sorting by Time
        conversationList.sort((a, b) {
          final aTime = a.lastMessage?.createdAt ?? a.updatedAt ?? a.createdAt;
          final bTime = b.lastMessage?.createdAt ?? b.updatedAt ?? b.createdAt;
          return bTime!.compareTo(aTime!);
        });

        // 3. ASAL FIX: Partner dhoondne ka logic
        for (var chat in conversationList) {
          if (chat.participants != null && chat.participants!.length > 1) {

            // Debug: Check karein ke API se IDs kya aa rahi hain
            print("Checking Chat: ${chat.id}");
            for(var p in chat.participants!) {
              print("Participant ID: ${p.id} == My ID: $currentUserId");
            }

            // Partner wo hai jiski ID meri ID se match NAHI karti
            int partnerIndex = chat.participants!.indexWhere(
                    (p) => p.id.toString().trim() != currentUserId
            );

            if (partnerIndex != -1 && partnerIndex != 0) {
              final partner = chat.participants!.removeAt(partnerIndex);
              chat.participants!.insert(0, partner);
            }
          }
        }

        conversations.assignAll(conversationList);

        if (conversations.isNotEmpty) {
          print(":white_check_mark: FIXED Partner Name at index 0: ${conversations.first.participants?.first.fullName}");
        }

      } else {
        errorMessage.value = 'Failed to load conversations';
      }
    } catch (e) {
      print(":x: ERROR: $e");
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchMessages(String conversationId) async {
    isLoadingMessages.value = true;
    errorMessage.value = '';

    try {
      final response = await apiService.get('${ApiUrls.getMessages}$conversationId');

      if (response.statusCode == 200) {
        List<dynamic> messagesData = [];

        if (response.data is Map) {
          messagesData = response.data['messages'] ?? [];
        } else if (response.data is List) {
          messagesData = response.data;
        }

        final messageList = messagesData
            .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .where((m) => m != null)
            .toList();

        messageList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        messages.assignAll(messageList);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });
      } else {
        errorMessage.value = 'Failed to load messages: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching messages: $e';
    } finally {
      isLoadingMessages.value = false;
    }
  }

  void selectConversation(Conversation conversation) {
    if (selectedConversation.value?.id == conversation.id) {
      return;
    }

    selectedConversation.value = conversation;
    errorMessage.value = '';
    messages.clear();
    fetchMessages(conversation.id);

    if (socketService.isConnected.value) {
      joinCurrentRoom();
    } else {
      socketService.connect(userId: homeController.currentUser.value?.userId).then((_) {
        joinCurrentRoom();
      }).catchError((error) {
        errorMessage.value = 'Failed to connect: $error';
      });
    }
  }

  void sendMessage() {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;

    final conversation = selectedConversation.value;
    if (conversation == null) {
      errorMessage.value = 'No conversation selected';
      Get.snackbar('Error', 'No conversation selected', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final currentUser = homeController.currentUser.value;
    if (currentUser?.userId == null) {
      errorMessage.value = 'User not found';
      Get.snackbar('Error', 'User not found', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final participants = conversation.participants ?? [];
    final doctor = participants.firstWhere(
          (p) => p.role == 'doctor',
      orElse: () => Participant(id: '', fullName: '', profileImage: '', role: ''),
    );
    final patient = participants.firstWhere(
          (p) => p.role == 'patient',
      orElse: () => Participant(id: '', fullName: '', profileImage: '', role: ''),
    );

    if (doctor.id.isEmpty || patient.id.isEmpty) {
      errorMessage.value = 'Conversation participants missing';
      Get.snackbar('Error', 'Conversation participants missing', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!socketService.isConnected.value) {
      errorMessage.value = 'Connecting to chat server...';
      Get.snackbar('Connecting', 'Establishing connection...', snackPosition: SnackPosition.BOTTOM);
      socketService.connect(userId: currentUser?.userId).then((_) {
        if (socketService.isConnected.value) {
          errorMessage.value = '';
          Future.delayed(const Duration(milliseconds: 300), () {
            _processMessageSending(conversation, doctor, patient, currentUser!, text);
          });
        }
      }).catchError((error) {
        errorMessage.value = 'Connection failed: $error';
        Get.snackbar('Connection Failed', 'Please check your internet', snackPosition: SnackPosition.BOTTOM);
      });
      return;
    }

    _processMessageSending(conversation, doctor, patient, currentUser!, text);
  }

  void _processMessageSending(
      Conversation conversation,
      Participant doctor,
      Participant patient,
      UserModel currentUser,
      String text,
      ) {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    String profileImage = currentUser.patientData?.profileImage ?? '';

    final isCurrentUserDoctor = currentUser.role == 'doctor';
    final senderDetails = Participant(
      id: currentUser.userId!,
      fullName: currentUser.fullName ?? '',
      profileImage: profileImage,
      role: isCurrentUserDoctor ? 'doctor' : 'patient',
    );

    final receiverDetails = isCurrentUserDoctor ? patient : doctor;

    final tempMessage = ChatMessage(
      id: tempId,
      conversationId: conversation.id,
      sender: currentUser.userId!,
      receiver: isCurrentUserDoctor ? patient.id : doctor.id,
      message: text,
      status: 'sending',
      messageType: 'text',
      createdAt: DateTime.now(),
      senderDetails: senderDetails,
      receiverDetails: receiverDetails,
    );

    messages.insert(0, tempMessage);
    messages.refresh();
    messageInputController.clear();
    scrollToBottom();

    socketService.sendMessage(
      doctorId: doctor.id,
      patientId: patient.id,
      sender: currentUser.userId!,
      message: text,
      tempId: tempId,
    );

    _handleMessageTimeout(tempId, text);
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void retryFailedMessage(ChatMessage message) {
    final conversation = selectedConversation.value;
    if (conversation == null) return;

    final index = messages.indexOf(message);
    if (index != -1) {
      messages.removeAt(index);
      messageInputController.text = message.message;
      sendMessage();
    }
  }

  String formatTime(DateTime time) {
    final localTime = time.toLocal();
    final hour = localTime.hour;
    final minute = localTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String formatDate(DateTime date) {
    final localDate = date.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(localDate.year, localDate.month, localDate.day);

    if (messageDate.isAtSameMomentAs(today)) {
      return 'Today, ${_getMonthName(localDate.month)} ${localDate.day}, ${localDate.year}';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (messageDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday, ${_getMonthName(localDate.month)} ${localDate.day}, ${localDate.year}';
    }

    return '${_getMonthName(localDate.month)} ${localDate.day}, ${localDate.year}';
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String getLastMessageTime(DateTime date) {
    final localDate = date.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(localDate.year, localDate.month, localDate.day);

    if (messageDate.isAtSameMomentAs(today)) {
      return '${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (messageDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    }

    return '${localDate.day}/${localDate.month}';
  }
}