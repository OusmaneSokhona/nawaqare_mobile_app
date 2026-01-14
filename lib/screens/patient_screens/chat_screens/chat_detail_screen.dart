import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../../controllers/patient_controllers/chat_controller.dart';
import '../../../models/chat_model.dart';

class ChatDetailScreen extends StatelessWidget {
  ChatDetailScreen({super.key});
  final controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final doctor = controller.selectedDoctor;

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
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
              isWeb?10.verticalSpace:60.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Image.asset(
                    doctor.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppStrings.online.tr,
                        style: TextStyle(
                          color: AppColors.lightGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.more_vert, color: AppColors.primaryColor),
                  10.horizontalSpace,
                ],
              ),
              Expanded(
                child: Obx(
                      () => ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final reversedMessages =
                      controller.messages.reversed.toList();
                      final message = reversedMessages[index];

                      final showDateSeparator =
                          index == reversedMessages.length - 1 ||
                              message.time.day !=
                                  reversedMessages[index + 1].time.day;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                reversedMessages.last.text,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (showDateSeparator)
                            DateSeparator(date: message.time),
                          MessageBubble(
                              message: message,
                              doctorImageUrl: doctor.imageUrl),
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
}

class DateSeparator extends StatelessWidget {
  final ChatController chatController = Get.find();
  final DateTime date;

  DateSeparator({required this.date, super.key});

  @override
  Widget build(BuildContext context) {
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
  final Message message;
  final String doctorImageUrl;

  MessageBubble({
    required this.message,
    required this.doctorImageUrl,
    super.key,
  });

  final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (message.text.contains('Encrypted Messaging') ||
        message.text.contains('....')) {
      return Container();
    }

    final alignment =
    message.isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = message.isMe ? Colors.blue.shade600 : Colors.white;
    final textColor = message.isMe ? Colors.white : Colors.black;
    final radius = message.isMe
        ? const BorderRadius.only(
      topLeft: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    )
        : const BorderRadius.only(
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );

    final bubble = Flexible(
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(color: textColor),
        ),
      ),
    );

    final seenIndicator = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          chatController.formatTime(message.time),
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        if (message.isMe)
          Icon(
            message.isSeen ? Icons.done_all : Icons.done,
            size: 14,
            color: message.isSeen ? Colors.blue : Colors.grey,
          ),
      ],
    );

    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
        message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isMe)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ClipOval(
                    child: Image.asset(
                      doctorImageUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              bubble,
              if (message.isMe) const SizedBox(width: 8),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: message.isMe ? 0 : 40.0,
              right: message.isMe ? 8.0 : 0,
              bottom: 8.0,
            ),
            child: seenIndicator,
          ),
        ],
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  final ChatController controller;

  const ChatInputField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.grey),
            onPressed: () {},
          ),
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
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.sentiment_satisfied_alt_outlined,
                            color: Colors.grey),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.mic_none, color: Colors.grey),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined,
                            color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: controller.sendMessage,
          ),
        ],
      ),
    );
  }
}