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
      id: json['_id'] ?? '',
      participants: (json['participants'] as List? ?? [])
          .map((p) => Participant.fromJson(p as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
    );
  }

  Conversation copyWith({
    String? id,
    List<Participant>? participants,
    DateTime? createdAt,
    DateTime? updatedAt,
    LastMessage? lastMessage,
  }) {
    return Conversation(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Participant? getDoctor() {
    try {
      return participants.firstWhere((p) => p.role.toLowerCase() == 'doctor');
    } catch (e) {
      return null;
    }
  }

  Participant? getPatient() {
    try {
      return participants.firstWhere((p) => p.role.toLowerCase() == 'patient');
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastMessage': lastMessage?.toJson(),
    };
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
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }

  Participant copyWith({
    String? id,
    String? fullName,
    String? profileImage,
    String? role,
  }) {
    return Participant(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'profileImage': profileImage,
      'role': role,
    };
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
      id: json['_id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      sender: json['sender']?.toString() ?? '',
      receiver: json['receiver']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'unseen',
      messageType: json['messageType']?.toString() ?? 'text',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  LastMessage copyWith({
    String? id,
    String? conversationId,
    String? sender,
    String? receiver,
    String? message,
    String? status,
    String? messageType,
    DateTime? createdAt,
  }) {
    return LastMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      message: message ?? this.message,
      status: status ?? this.status,
      messageType: messageType ?? this.messageType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isUnseen => status.toLowerCase() == 'unseen' || status.toLowerCase() == 'sent';

  bool get isSeen => status.toLowerCase() == 'seen' || status.toLowerCase() == 'read';

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'conversationId': conversationId,
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'status': status,
      'messageType': messageType,
      'createdAt': createdAt.toIso8601String(),
    };
  }
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
    String senderId = json['sender']?.toString() ?? '';
    String receiverId = json['receiver']?.toString() ?? '';

    Participant? senderDetails;
    if (json['senderDetails'] != null) {
      try {
        Map<String, dynamic> senderMap = json['senderDetails'] is Map
            ? Map<String, dynamic>.from(json['senderDetails'])
            : {};
        senderDetails = Participant.fromJson({
          '_id': senderId,
          'fullName': senderMap['fullName']?.toString() ?? '',
          'profileImage': senderMap['profileImage']?.toString() ?? '',
          'role': senderMap['role']?.toString() ?? '',
        });
      } catch (e) {
        print('Error creating senderDetails: $e');
      }
    }

    Participant? receiverDetails;
    if (json['receiverDetails'] != null) {
      try {
        Map<String, dynamic> receiverMap = json['receiverDetails'] is Map
            ? Map<String, dynamic>.from(json['receiverDetails'])
            : {};
        receiverDetails = Participant.fromJson({
          '_id': receiverId,
          'fullName': receiverMap['fullName']?.toString() ?? '',
          'profileImage': receiverMap['profileImage']?.toString() ?? '',
          'role': receiverMap['role']?.toString() ?? '',
        });
      } catch (e) {
        print('Error creating receiverDetails: $e');
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
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      senderDetails: senderDetails,
      receiverDetails: receiverDetails,
    );
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'conversationId': conversationId,
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'status': status,
      'messageType': messageType,
      'createdAt': createdAt.toIso8601String(),
      'senderDetails': senderDetails?.toJson(),
      'receiverDetails': receiverDetails?.toJson(),
    };
  }
}