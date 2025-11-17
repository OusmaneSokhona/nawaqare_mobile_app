class Doctor {
  final String name;
  final String specialty;
  final String imageUrl;
  final String lastMessageTime;
  final int unreadCount;

  Doctor({
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });
}

class Message {
  final String text;
  final DateTime time;
  final bool isMe;
  final bool isSeen;

  Message({
    required this.text,
    required this.time,
    required this.isMe,
    required this.isSeen,
  });
}