import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_radio_tile.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class CalenderSyncronizationScreen extends StatelessWidget {
  CalenderSyncronizationScreen({super.key});

  RxBool oneWay = true.obs;
  RxBool twoWay = false.obs;
  RxBool switchValue = true.obs;

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/back_icon.png",
                      height: 22.h,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "Calendar synchronization",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Keep your Nawa Care schedule aligned with Google, Outlook, or iCal.",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGrey,
                          fontFamily: AppFonts.jakartaMedium,
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Integration Options",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      _buildCalendarConnectCard(
                        Image.asset(
                          "assets/images/google_icon.png",
                          height: 27.sp,
                        ),
                        "Google Calendar",
                        () {},
                      ),
                      5.verticalSpace,
                      _buildCalendarConnectCard(
                        Image.asset(
                          "assets/images/outlook_icon.png",
                          height: 27.sp,
                        ),
                        "Outlook Calendar",
                        () {},
                      ),
                      5.verticalSpace,
                      _buildCalendarConnectCard(
                        Image.asset(
                          "assets/images/apple_icon.png",
                          height: 27.sp,
                        ),
                        "Apple iCal",
                        () {},
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sync Settings",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Automatic sync every 6 hours",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Obx(
                            ()=> Switch(
                              value: switchValue.value,
                              onChanged: (val) {
                                switchValue.value=val;
                              },
                              activeColor: Colors.white,
                              activeTrackColor: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 2.h,
                        color: AppColors.lightGrey,
                        thickness: 0.4,
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sync Direction Mode",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      5.verticalSpace,
                      Obx(
                        () => _buildSyncDirectionMOde(
                          oneWay,
                          "One-way (read-only)",
                          "Updates Are Imported From External Calendar Only.",
                        ),
                      ),
                      5.verticalSpace,
                      Obx(
                        () => _buildSyncDirectionMOde(
                          twoWay,
                          "Two-way sync",
                          "Changes In Nawa Care Are Mirrored In External Calendar.",
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        height: 35.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.sp),
                          color: AppColors.green.withOpacity(0.2),
                        ),
                        padding: EdgeInsets.only(left:20.w),
                        alignment: Alignment.centerLeft,
                        child: Text("Last synced successfully at 09:45 AM.",style: TextStyle(color: AppColors.green),),
                      ),
                      20.verticalSpace,
CustomButton(borderRadius: 15, text: "Force manual synchronization", onTap: (){}),
                      20.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarConnectCard(
    Widget icon,
    String title,
    VoidCallback onConnect,
  ) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncDirectionMOde(RxBool value, String title, String subtitle) {
    return InkWell(
      onTap: () {
        value.value = !value.value;
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          child: Column(
            children: [
              CustomRadioTile(
                text: title,
                isSelected: value.value,
                onTap: () {
                  value.value = !value.value;
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: Text(subtitle, style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
