import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/chat_controller.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../notifications_screens/notifications_screen.dart';
import '../video_call_screens/help_center_screen.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  final bool showBackIcon;
  ChatScreen({super.key, this.showBackIcon = false});

  final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    chatController.scrollChange();
    return Scaffold(
      body: Container(
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
            Obx(() {
              final bool isScrolledPastThreshold =
                  chatController.scrollValue.value >= 330;

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
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
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
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          onChanged: chatController.updateSearchQuery,
                          decoration: InputDecoration(
                            hintText: AppStrings.search.tr,
                            border: InputBorder.none,
                            icon: const Icon(Icons.search,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: InkWell(
                        onTap: () {
                          Get.to(HelpCenterScreen());
                        },
                        child: Image.asset(
                          "assets/images/help_center_icon.png",
                          height: 25.h,
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: InkWell(
                        onTap: () {
                          Get.to(NotificationScreen());
                        },
                        child: Image.asset(
                          "assets/images/bell_icon.png",
                          height: 25.h,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox();
            }),
            Expanded(
              child: SingleChildScrollView(
                controller: chatController.scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.sp),
                  child: Column(
                    children: [
                      60.verticalSpace,
                      Row(
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
                                    "assets/images/back_icon.png",
                                    color: Colors.white,
                                    height: 33.sp,
                                  )),
                            )
                          else
                            const SizedBox(),
                          showBackIcon
                              ? 5.horizontalSpace
                              : const SizedBox(),
                          CircleAvatar(
                            radius: 35.h,
                            backgroundColor: Colors.white,
                            foregroundImage: const AssetImage(
                              "assets/demo_images/home_demo_image.png",
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Get.to(HelpCenterScreen());
                            },
                            child: Image.asset(
                              "assets/images/help_center_icon.png",
                              height: 25.h,
                            ),
                          ),
                          5.horizontalSpace,
                          InkWell(
                            onTap: () {
                              Get.to(NotificationScreen());
                            },
                            child: Image.asset(
                              "assets/images/bell_icon.png",
                              height: 30.h,
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.chat.tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 32.sp,
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
                            fontSize: 16.sp,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      Container(
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
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          onChanged: chatController.updateSearchQuery,
                          decoration: InputDecoration(
                            hintText: AppStrings.search.tr,
                            border: InputBorder.none,
                            icon: const Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                            () => chatController.filteredDoctors.isNotEmpty
                            ? Container(
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
                            itemCount:
                            chatController.filteredDoctors.length,
                            separatorBuilder: (context, index) =>
                            const Divider(
                              height: 1,
                              indent: 80,
                            ),
                            itemBuilder: (context, index) {
                              final doctor =
                              chatController.filteredDoctors[index];
                              return ListTile(
                                leading: ClipOval(
                                  child: Image.asset(
                                    doctor.imageUrl,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  doctor.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(doctor.specialty),
                                trailing: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      doctor.lastMessageTime,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: doctor.unreadCount > 0
                                            ? Colors.blue.shade600
                                            : Colors.grey,
                                      ),
                                    ),
                                    if (doctor.unreadCount > 0)
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 4,
                                        ),
                                        padding: const EdgeInsets.all(
                                          4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade600,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          doctor.unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  Get.to(() => ChatDetailScreen(),
                                      binding: AppBinding());
                                },
                              );
                            },
                          ),
                        )
                            : Text(
                          AppStrings.noDataFound.tr,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}