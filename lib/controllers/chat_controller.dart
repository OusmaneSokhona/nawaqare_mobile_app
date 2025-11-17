import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat_model.dart';

class ChatController extends GetxController{
  ScrollController scrollController=ScrollController();
  RxDouble scrollValue=0.0.obs;
  void scrollChange(){
    scrollController.addListener((){
      scrollValue.value=scrollController.offset;
      print(scrollValue);
    });
  }
  final RxList<Doctor> _doctors = <Doctor>[].obs;
  final RxList<Message> _messages = <Message>[].obs;
  final RxString _searchQuery = ''.obs;
  final TextEditingController messageInputController = TextEditingController();

  List<Doctor> get filteredDoctors => _doctors.where((doc) => doc.name.toLowerCase().contains(_searchQuery.value.toLowerCase())).toList().obs;
  List<Message> get messages => _messages;
  Doctor get selectedDoctor => _doctors.firstWhere((doc) => doc.name == 'Dr. Maria Waston');

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }
  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} AM';
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate.isAtSameMomentAs(today)) {
      return 'Today, Oct 24, 2025';
    }
    return '${date.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]} ${date.year}';
  }
  void _loadMockData() {
    final mockDoctor = Doctor(name: 'Dr. Maria Waston', specialty: 'Heart Surgeon', imageUrl: 'assets/demo_images/doctor_1.png', lastMessageTime: '14:20', unreadCount: 2);
    final mockDoctors = [
      mockDoctor,
      Doctor(name: 'Dr. John Doe', specialty: 'Pediatrician', imageUrl: 'assets/demo_images/doctor_1.png', lastMessageTime: '13:10', unreadCount: 0),
      Doctor(name: 'Dr. Jane Smith', specialty: 'Dermatologist', imageUrl: 'assets/demo_images/doctor_3.png', lastMessageTime: 'Yesterday', unreadCount: 5),
      Doctor(name: 'Dr. Alex Brown', specialty: 'Neurologist', imageUrl: 'assets/demo_images/doctor_2.png', lastMessageTime: '10:05', unreadCount: 0),
      Doctor(name: 'Dr. Emily Davis', specialty: 'Oncologist', imageUrl: 'assets/demo_images/doctor_1.png', lastMessageTime: '09:30', unreadCount: 0),
      mockDoctor,
      mockDoctor,
    ];
    _doctors.assignAll(mockDoctors);

    final mockMessages = [
      Message(text: 'Encrypted Messaging – GDPR/HDS Compliant', time: DateTime(2025, 10, 24, 8, 16), isMe: false, isSeen: false),
      Message(text: 'Chat in real time with your doctor. Ask questions, share reports, and get quick medical advice — all in one secure place.', time: DateTime(2025, 10, 24, 8, 16), isMe: false, isSeen: true),
      Message(text: 'Yes, we\'ll be covering the latest ESC 2025 guidelines', time: DateTime(2025, 10, 24, 8, 16), isMe: true, isSeen: true),
      Message(text: 'Chat in real time with your doctor. Ask questions, share reports, and get quick medical advice — all in one secure place.', time: DateTime(2025, 10, 24, 8, 16), isMe: false, isSeen: true),
      Message(text: 'Yes, we\'ll be covering the latest ESC 2025 guidelines', time: DateTime(2025, 10, 24, 8, 16), isMe: true, isSeen: true),
      Message(text: '....', time: DateTime(2025, 10, 24, 8, 16), isMe: false, isSeen: false),
    ];
    _messages.assignAll(mockMessages);
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void sendMessage() {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;
    _messages.add(Message(text: text, time: DateTime.now(), isMe: true, isSeen: false));
    messageInputController.clear();
    _messages.refresh();
  }
}