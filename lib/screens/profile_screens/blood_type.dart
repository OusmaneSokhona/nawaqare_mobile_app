import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/profile_controller.dart';
import 'package:patient_app/screens/profile_screens/edit_blood_type.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';
import '../../widgets/custom_button.dart';

class BloodType extends StatelessWidget {
  BloodType({super.key});

  ProfileController controller = Get.find();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              70.verticalSpace,
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
                  Text(
                    "Blood Type",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 250.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.sp),
                          border: Border.all(
                            color: AppColors.lightGrey.withOpacity(0.3),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Current Blood Type",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.jakartaMedium,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            Image.asset("assets/images/blood_icon.png",height: 80.h,fit: BoxFit.fill,),
                            5.verticalSpace,
                            Obx(()=> Text(controller.selectedBloodType.value,style: TextStyle(fontSize: 29.sp,fontWeight: FontWeight.w800,fontFamily: AppFonts.jakartaBold),)),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Text("Last confirmed",style: TextStyle(fontSize: 13.sp,fontFamily:AppFonts.jakartaMedium,color: Colors.black,fontWeight: FontWeight.w500),),
                             20.horizontalSpace,
                             Text("Source",style: TextStyle(fontSize: 13.sp,fontFamily:AppFonts.jakartaMedium,color: Colors.black,fontWeight: FontWeight.w500),),
                             Spacer(),
                             Text("Verification status",style: TextStyle(fontSize: 13.sp,fontFamily:AppFonts.jakartaMedium,color: Colors.black,fontWeight: FontWeight.w500),),
                           ],
                         ),
                         10.verticalSpace,
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Text("Jan 2024",style: TextStyle(fontSize: 10.sp,fontFamily:AppFonts.jakartaMedium,color: Colors.black,fontWeight: FontWeight.w400),),
                             50.horizontalSpace,
                             Text("Medical Test Report",style: TextStyle(fontSize: 10.sp,fontFamily:AppFonts.jakartaMedium,color: Colors.black,fontWeight: FontWeight.w400),),
                             Spacer(),
                             Text("✅ Verified",style: TextStyle(fontSize: 10.sp,fontFamily:AppFonts.jakartaMedium,color: Colors.black,fontWeight: FontWeight.w400),),
                            50.horizontalSpace,
                           ],
                         ),
                          ],
                        ),
                      ),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "Update Blood Type",
                        onTap: () {
                          Get.to(EditBloodType());
                        },
                      ),
                      15.verticalSpace,
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

  void _showDatePicker(BuildContext context) async {
    final List<DateTime?>? dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: Colors.blue,
        centerAlignModePicker: true,
      ),
      dialogSize: const Size(325, 400),
      value: [controller.selectedDate],
      // Current date value
      borderRadius: BorderRadius.circular(15),
    );
  }
}
