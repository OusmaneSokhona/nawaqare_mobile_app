import 'package:get/get.dart';

import '../controllers/patient_controllers/home_controller.dart';

class Conversation {
  final String id;
  final List<Participant> participants;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LastMessage? lastMessage;

  Conversation({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'],
      participants: (json['participants'] as List)
          .map((p) => Participant.fromJson(p))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'])
          : null,
    );
  }

  Participant? getDoctor() {
    try {
      return participants.firstWhere((p) => p.role == 'doctor');
    } catch (e) {
      return null;
    }
  }

  Participant? getPatient() {
    try {
      return participants.firstWhere((p) => p.role == 'patient');
    } catch (e) {
      return null;
    }
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
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      profileImage: json['profileImage'] ?? '',
      role: json['role'] ?? '',
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
      id: json['_id'],
      conversationId: json['conversationId'],
      sender: json['sender'],
      receiver: json['receiver'],
      message: json['message'],
      status: json['status'],
      messageType: json['messageType'],
      createdAt: DateTime.parse(json['createdAt']),
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
  final String? status;
  final String? messageType;
  final DateTime createdAt;
  final Participant? senderDetails;
  final Participant? receiverDetails;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.receiver,
    required this.message,
    this.status,
    this.messageType,
    required this.createdAt,
    this.senderDetails,
    this.receiverDetails,
  });

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

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    String senderId = json['sender'] ?? '';
    String receiverId = json['receiver'] ?? '';

    Participant? senderDetails;
    if (json['senderDetails'] != null) {
      try {
        senderDetails = Participant.fromJson({
          '_id': senderId,
          'fullName': json['senderDetails']['fullName'] ?? '',
          'profileImage': json['senderDetails']['profileImage'] ?? '',
          'role': json['senderDetails']['role'] ?? '',
        });
      } catch (e) {
        print('Error creating senderDetails: $e');
      }
    }

    Participant? receiverDetails;
    if (json['receiverDetails'] != null) {
      try {
        receiverDetails = Participant.fromJson({
          '_id': receiverId,
          'fullName': json['receiverDetails']['fullName'] ?? '',
          'profileImage': json['receiverDetails']['profileImage'] ?? '',
          'role': json['receiverDetails']['role'] ?? '',
        });
      } catch (e) {
        print('Error creating receiverDetails: $e');
      }
    }

    return ChatMessage(
      id: json['_id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      sender: senderId,
      receiver: receiverId,
      message: json['message'] ?? '',
      status: json['status'] ?? 'unseen',
      messageType: json['messageType'] ?? 'text',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      senderDetails: senderDetails,
      receiverDetails: receiverDetails,
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

  bool get isSeen => status == 'seen';
}