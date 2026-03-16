import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/chat_controller.dart';
import 'package:patient_app/controllers/patient_controllers/home_controller.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../models/chat_model.dart';
import '../notifications_screens/notifications_screen.dart';
import '../video_call_screens/help_center_screen.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  final bool showBackIcon;

  const ChatScreen({
    super.key,
    this.showBackIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find();
    final HomeController homeController = Get.find();
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Obx(
            () {
          final user = homeController.currentUser.value;
          final userName = user?.fullName ?? 'User';
          final userImage = user?.patientData?.profileImage;

          return Container(
            height: 1.sh,
            width: 1.sw,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.01),
                  AppColors.primaryColor.withOpacity(0.01),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                buildAnimatedAppBar(
                  context,
                  isDesktop,
                  chatController,
                  userName,
                  userImage,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: chatController.scrollController,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Column(
                        children: [
                          SizedBox(height: 60.h),
                          buildHeader(
                            context,
                            showBackIcon,
                            userImage,
                            userName,
                            isDesktop,
                          ),
                          SizedBox(height: 10.h),
                          buildGreeting(context, userName),
                          SizedBox(height: 15.h),
                          buildSearchField(chatController, context),
                          SizedBox(height: 10.h),
                          buildConversationsList(chatController),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildAnimatedAppBar(
      BuildContext context,
      bool isDesktop,
      ChatController chatController,
      String userName,
      String? userImage,
      ) {
    return Obx(
          () {
        final bool isScrolledPastThreshold = isWeb
            ? chatController.scrollValue.value >= 120
            : chatController.scrollValue.value >= 280;

        final double targetHeight = isScrolledPastThreshold ? 120.0 : 0.0;
        final Color targetColor = isScrolledPastThreshold
            ? AppColors.primaryColor
            : Colors.transparent;

        return isScrolledPastThreshold
            ? AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          height: targetHeight,
          width: 1.sw,
          color: targetColor,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 8.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isDesktop)
                CircleAvatar(
                  radius: 25.h,
                  backgroundColor: Colors.white,
                  backgroundImage: userImage != null && userImage.isNotEmpty
                      ? NetworkImage(userImage)
                      : const AssetImage('assets/demo_images/home_demo_image.png')
                  as ImageProvider,
                ),
              if (isDesktop) SizedBox(width: 5.h),
              if (isDesktop)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.h,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 18.w : 8.w),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: TextField(
                      onTapOutside: (_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: chatController.updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: AppStrings.search.tr,
                        border: InputBorder.none,
                        icon: const Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5.h),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: InkWell(
                  onTap: () {
                    Get.to(() =>  HelpCenterScreen());
                  },
                  child: Image.asset(
                    'assets/images/help_center_icon.png',
                    height: 25.h,
                  ),
                ),
              ),
              if (!isDesktop) SizedBox(width: 5.h),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: InkWell(
                  onTap: () {
                    Get.to(() =>  NotificationScreen());
                  },
                  child: Image.asset(
                    'assets/images/bell_icon.png',
                    height: 25.h,
                  ),
                ),
              ),
            ],
          ),
        )
            : const SizedBox.shrink();
      },
    );
  }

  Widget buildHeader(
      BuildContext context,
      bool showBackIcon,
      String? userImage,
      String userName,
      bool isDesktop,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBackIcon)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset(
                'assets/images/back_icon.png',
                color: Colors.white,
                height: 33.h,
              ),
            ),
          ),
        if (showBackIcon) SizedBox(width: 5.h),
        CircleAvatar(
          radius: 35.h,
          backgroundColor: Colors.white,
          backgroundImage: userImage != null && userImage.isNotEmpty
              ? NetworkImage(userImage)
              : const AssetImage('assets/demo_images/home_demo_image.png')
          as ImageProvider,
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Get.to(() =>  HelpCenterScreen());
          },
          child: Image.asset(
            'assets/images/help_center_icon.png',
            height: 25.h,
          ),
        ),
        SizedBox(width: isDesktop ? 2.h : 5.h),
        InkWell(
          onTap: () {
            Get.to(() =>  NotificationScreen());
          },
          child: Image.asset(
            'assets/images/bell_icon.png',
            height: 30.h,
          ),
        ),
      ],
    );
  }

  Widget buildGreeting(BuildContext context, String userName) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${AppStrings.hello.tr}\n$userName',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: isWeb ? 13.sp : 32.sp,
              fontWeight: FontWeight.w800,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.chatDescription.tr,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.jakartaMedium,
              fontSize: isWeb ? 6.sp : 16.sp,
              color: AppColors.darkGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSearchField(ChatController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: AppStrings.search.tr,
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  Widget buildConversationsList(ChatController controller) {
    return Obx(
          () {
        if (controller.filteredConversations.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.h),
              child: Text(
                AppStrings.noDataFound.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
              ),
            ],
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 8),
            itemCount: controller.filteredConversations.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 80,
            ),
            itemBuilder: (context, index) {
              final conversation = controller.filteredConversations[index];
              final lastMessage = conversation.lastMessage;
              final currentUser = controller.homeController.currentUser.value;

              if (currentUser == null) return const SizedBox.shrink();

              final otherParticipant = controller.getOtherParticipant(conversation);

              if (otherParticipant == null || otherParticipant.id.isEmpty) {
                return const SizedBox.shrink();
              }

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: ClipOval(
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Image.network(
                      otherParticipant.profileImage.isNotEmpty
                          ? otherParticipant.profileImage
                          : 'assets/demo_images/home_demo_image.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/demo_images/home_demo_image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  otherParticipant.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  lastMessage?.message ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: SizedBox(
                  width: 70,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (lastMessage != null)
                        Flexible(
                          child: Text(
                            controller.getLastMessageTime(lastMessage.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: lastMessage.status == 'unseen' &&
                                  lastMessage.sender != currentUser.id
                                  ? Colors.blue.shade600
                                  : Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (lastMessage != null &&
                          lastMessage.status == 'unseen' &&
                          lastMessage.sender != currentUser.id)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: const Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                onTap: () {
                  controller.selectConversation(conversation);
                  Get.to(
                        () => ChatDetailScreen(),
                    binding: AppBinding(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}