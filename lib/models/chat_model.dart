import 'package:get/get.dart';
import '../controllers/patient_controllers/home_controller.dart';

class Conversation {
  final String id;
  final List<Participant>? participants;
  final LastMessage? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    this.participants,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      participants: (json['participants'] as List?)
          ?.map((p) => Participant.fromJson(p as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

class Participant {
  final String id;
  final String fullName;
  final String profileImage;
  final String role;

  Participant({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.role,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? 'Unknown',
      profileImage: json['profileImage']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}

class LastMessage {
  final String id;
  final String conversationId;
  final String sender;
  final String receiver;
  final String message;
  final String status;
  final String messageType;
  final DateTime createdAt;

  LastMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.status,
    required this.messageType,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      sender: json['sender']?.toString() ?? '',
      receiver: json['receiver']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'sent',
      messageType: json['messageType']?.toString() ?? 'text',
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }

  bool get isUnseen => status == 'unseen';
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String sender;
  final String receiver;
  final String message;
  final String status;
  final String messageType;
  final DateTime createdAt;
  final Participant? senderDetails;
  final Participant? receiverDetails;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.receiver,
    required this.message,
    this.status = 'sending',
    this.messageType = 'text',
    required this.createdAt,
    this.senderDetails,
    this.receiverDetails,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    try {
      String senderId = json['sender']?.toString() ?? '';
      String receiverId = json['receiver']?.toString() ?? '';

      Participant? senderDetails;
      if (json['senderDetails'] != null && json['senderDetails'] is Map) {
        try {
          Map<String, dynamic> senderMap = Map<String, dynamic>.from(json['senderDetails']);
          senderDetails = Participant(
            id: senderId,
            fullName: senderMap['fullName']?.toString() ?? '',
            profileImage: senderMap['profileImage']?.toString() ?? '',
            role: senderMap['role']?.toString() ?? '',
          );
        } catch (e) {
          print('Error parsing senderDetails: $e');
        }
      }

      Participant? receiverDetails;
      if (json['receiverDetails'] != null && json['receiverDetails'] is Map) {
        try {
          Map<String, dynamic> receiverMap = Map<String, dynamic>.from(json['receiverDetails']);
          receiverDetails = Participant(
            id: receiverId,
            fullName: receiverMap['fullName']?.toString() ?? '',
            profileImage: receiverMap['profileImage']?.toString() ?? '',
            role: receiverMap['role']?.toString() ?? '',
          );
        } catch (e) {
          print('Error parsing receiverDetails: $e');
        }
      }

      return ChatMessage(
        id: json['_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: json['conversationId']?.toString() ?? '',
        sender: senderId,
        receiver: receiverId,
        message: json['message']?.toString() ?? '',
        status: json['status']?.toString() ?? 'unseen',
        messageType: json['messageType']?.toString() ?? 'text',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt']).toLocal()
            : DateTime.now(),
        senderDetails: senderDetails,
        receiverDetails: receiverDetails,
      );
    } catch (e) {
      print('Error parsing ChatMessage: $e');
      rethrow;
    }
  }

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? sender,
    String? receiver,
    String? message,
    String? status,
    String? messageType,
    DateTime? createdAt,
    Participant? senderDetails,
    Participant? receiverDetails,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      message: message ?? this.message,
      status: status ?? this.status,
      messageType: messageType ?? this.messageType,
      createdAt: createdAt ?? this.createdAt,
      senderDetails: senderDetails ?? this.senderDetails,
      receiverDetails: receiverDetails ?? this.receiverDetails,
    );
  }

  bool get isMe {
    try {
      final currentUserId = Get.find<HomeController>().currentUser.value?.id;
      return sender == currentUserId;
    } catch (e) {
      return false;
    }
  }

  bool get isSeen => status.toLowerCase() == 'seen' || status.toLowerCase() == 'read';
  bool get isDelivered => status.toLowerCase() == 'delivered';
  bool get isSending => status.toLowerCase() == 'sending';
  bool get isFailed => status.toLowerCase() == 'failed';
}