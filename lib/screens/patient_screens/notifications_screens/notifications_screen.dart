import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/notification_controller.dart';
import 'package:patient_app/utils/app_colors.dart';

import '../../../models/notification_model.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class NotificationScreen extends StatelessWidget {
   NotificationScreen({super.key});
NotificationController notificationController=Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "Notifications",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                  Spacer(),
                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.sp),color: AppColors.primaryColor),alignment:Alignment.center,padding:EdgeInsets.all(5.sp),child: Text("1 New",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),)
                ],
              ),
              20.verticalSpace,
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  children: notificationController.mockData.map((group) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupHeader(context, group.day),
                        ...group.items.map((item) => _NotificationTile(item)).toList(),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;

  const _NotificationTile(this.item);

  Color _getBackgroundColor() {
    switch (item.type) {
      case NotificationType.cancelled:
        return Colors.white;
      default:
        return Colors.transparent;
    }
  }

  Color _getIconBackgroundColor() {
    switch (item.type) {
      case NotificationType.cancelled:
        return AppColors.primaryColor;
      default:
        return Colors.white;
    }
  }

  Color _getIconColor() {
    switch (item.type) {
      case NotificationType.cancelled:
        return Colors.white;
      default:
        return Colors.black54;
    }
  }

  IconData _getIconData() {
    switch (item.type) {
      case NotificationType.success:
      case NotificationType.cancelled:
        return Icons.calendar_today_outlined;
      case NotificationType.changed:
        return Icons.edit_calendar_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(10.r)
      ),
      
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              _getIconData(),
              color: _getIconColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.time,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}