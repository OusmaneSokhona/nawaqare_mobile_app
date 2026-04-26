import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/chat_controller.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/models/chat_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/utils/app_strings.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find();
    final doctor = controller.otherParticipant;
controller.fetchMessages(controller.selectedConversation.value!.id);
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: isWeb ? 10.h : 60.h),
              buildAppBar(context, controller, doctor),
              Expanded(
                child: Obx(
                      () => controller.isLoadingMessages.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.messages.isEmpty
                      ? const Center(
                    child: Text('No messages yet'),
                  )
                      : ListView.builder(
                    key: const PageStorageKey<String>('chat_messages_list'),
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];

                      final bool showDateSeparator = index == controller.messages.length - 1 ||
                          !_isSameDay(
                            message.createdAt,
                            controller.messages[index + 1].createdAt,
                          );

                      return Column(
                        children: [
                          MessageBubble(
                            message: message,
                            doctorImageUrl: doctor?.profileImage ?? '',
                          ),
                          if (showDateSeparator)
                            DateSeparator(date: message.createdAt),
                        ],
                      );
                    },
                  ),
                ),
              ),
              ChatInputField(controller: controller),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget buildAppBar(BuildContext context, ChatController controller, Participant? doctor) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            controller.messageInputController.clear();
            Get.back();
          },
          child: Image.asset(
            AppImages.backIcon,
            height: 33.h,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(width: 10.h),
        ClipOval(
          child: Image.network(
            doctor?.profileImage ?? '',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/demo_images/doctor_1.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor?.fullName ?? 'Doctor',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(() => Text(
              controller.socketService.isConnected.value ? 'Online' : 'Offline',
              style: TextStyle(
                color: controller.socketService.isConnected.value ? Colors.green : AppColors.lightGrey,
                fontSize: 12,
              ),
            )),
          ],
        ),
        const Spacer(),
        Icon(Icons.more_vert, color: AppColors.primaryColor),
        SizedBox(width: 10.h),
      ],
    );
  }
}

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              chatController.formatDate(date),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const Expanded(child: Divider(color: Colors.grey)),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String doctorImageUrl;

  const MessageBubble({
    super.key,
    required this.message,
    required this.doctorImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find();
    final bool isMe = message.isMe;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ClipOval(
                child: Image.network(
                  doctorImageUrl,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/demo_images/doctor_1.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue.shade600 : Colors.white,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        chatController.formatTime(message.createdAt),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      if (message.isMe) ...[
                        if (message.status == 'sending')
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          )
                        else if (message.status == 'failed')
                          GestureDetector(
                            onTap: () => chatController.retryFailedMessage(message),
                            child: const Icon(
                              Icons.error,
                              size: 14,
                              color: Colors.red,
                            ),
                          )
                        else
                          Icon(
                            message.isSeen ? Icons.done_all : Icons.done,
                            size: 14,
                            color: message.isSeen ? Colors.blue : Colors.grey,
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  final ChatController controller;

  const ChatInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextField(
                controller: controller.messageInputController,
                decoration: InputDecoration(
                  hintText: AppStrings.typeAMessage.tr,
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
          Obx(() => IconButton(
            icon: Icon(
              Icons.send,
              color: controller.socketService.isConnected.value ? Colors.blue : Colors.grey,
            ),
            onPressed: controller.socketService.isConnected.value ? controller.sendMessage : null,
          )),
        ],
      ),
    );
  }
}