import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/reception_controller.dart';
import 'package:patient_app/screens/doctor_screens/reception_screens/calender_screen.dart';
import 'package:patient_app/widgets/doctor_widgets/reception_widgets/feautre_card_widget.dart';
import 'package:patient_app/widgets/patient_widgets/appointment_widgets/past_appointment_widgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../patient_screens/notifications_screens/notifications_screen.dart';
import '../../patient_screens/video_call_screens/help_center_screen.dart';

class ReceptionScreen extends StatelessWidget {
   ReceptionScreen({super.key});
ReceptionController controller=Get.put(ReceptionController());
  @override
  Widget build(BuildContext context) {
    controller.scrollChange();
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
                  controller.scrollValue.value >= 280;

              final double targetHeight = isScrolledPastThreshold ? 100.0 : 0.0;

              final Color targetColor =
              isScrolledPastThreshold
                  ? AppColors.primaryColor
                  : Colors.transparent;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                height: targetHeight,
                width: 1.sw,
                color: targetColor,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 20.h,
                      backgroundColor: Colors.white,
                      foregroundImage: AssetImage(
                        "assets/demo_images/doctor_1.png",
                      ),
                    ),
                    20.horizontalSpace,
                    Text(
                      "Dr Alex",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.h,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(HelpCenterScreen());
                      },
                      child: Image.asset(
                        "assets/images/help_center_icon.png",
                        height: 25.h,
                      ),
                    ),
                    10.horizontalSpace,
                    InkWell(
                      onTap: () {
                        Get.to(NotificationScreen());
                      },
                      child: Image.asset(
                        "assets/images/bell_icon.png",
                        height: 25.h,
                      ),
                    ),
                  ],
                ),
              );
            }),
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.sp),
                  child: Column(
                    children: [
                      60.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35.h,
                            backgroundColor: Colors.white,
                            foregroundImage: AssetImage(
                              "assets/demo_images/doctor_1.png",
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.to(HelpCenterScreen());
                            },
                            child: Image.asset(
                              "assets/images/help_center_icon.png",
                              height: 25.h,
                            ),
                          ),
                          10.horizontalSpace,
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
                          "Reception",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Manage your schedules, services, and absences from this space",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.jakartaBold,
                            fontSize: 14.sp,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        height: 40.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.sp),
                          border: Border.all(
                            color: AppColors.lightGrey.withOpacity(0.5),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/calender_icon.png",
                              height: 20.h,
                              color: AppColors.primaryColor,
                              fit: BoxFit.fill,
                            ),
                            10.horizontalSpace,
                            Text(
                              "Last syn: 12/Sep/2025",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.jakartaMedium,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      CardHeader(title: "Weekly Summary"),
                      10.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: _buildCard(
                              Icons.check_circle,
                              'Available',
                              '15h',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCard(
                              Icons.calendar_today,
                              'Slots Booked',
                              '20',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _buildCard(
                          Icons.bookmark,
                          'Planned Absences',
                          '2',
                        ),
                      ),
                      15.verticalSpace,
                      CardHeader(title: "Quick Access"),
                      10.verticalSpace,
                      FeatureCard(onTap: (){
                        Get.to(CalenderScreen());
                      },icon: Icons.calendar_today, title: "Calendar", subtitle: "View & manage appointment", hasButton:true),
                      FeatureCard(onTap: (){},icon: Icons.monetization_on_outlined, title: "Services & Pricing", subtitle: "Edit your services,duration& fees", hasButton:false),
                      FeatureCard(onTap: (){},icon: Icons.do_not_disturb_on_outlined, title: "Absences & exceptions", subtitle: "Declare an absence or mark unavailable", hasButton:false),

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
   Widget _buildCard(IconData icon, String title, String value) {
     return Container(
       decoration: BoxDecoration(
         color: Colors.white,
         border: Border.all(color: AppColors.lightGrey.withOpacity(0.3)),
         borderRadius: BorderRadius.circular(18.sp)
       ),
       child: Padding(
         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             Icon(icon, color:  Color(0xFF1E88E5), size: 24.sp),
             const SizedBox(height: 10),
             Text(
               title,
               style: TextStyle(
                 fontSize: 12.sp,
                 fontWeight: FontWeight.w600,
                 color:Colors.black,
               ),
               textAlign: TextAlign.center,
             ),
             const SizedBox(height: 5),
             Text(
               value,
               style: TextStyle(
                 fontSize: 14.sp,
                 fontWeight: FontWeight.w400,
                 color: AppColors.lightGrey,
               ),
               textAlign: TextAlign.center,
             ),
           ],
         ),
       ),
     );
   }
}
