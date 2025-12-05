import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';

import '../../../utils/app_fonts.dart';

class AddPrescriptionDrawer extends GetView<VideoCallController> {
  const AddPrescriptionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.9,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: 0.8.sw,
            height: 1.sh,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.onboardingBackground, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 60.h, left: 18.w, right: 10.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Prescription',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    10.verticalSpace,
                    CustomTextField(labelText: "Patient Name",hintText: "Mr John",),
                    10.verticalSpace,
                    CustomTextField(labelText: "Medicines",hintText: "Enter Medicines",),
                    10.verticalSpace,
                    CustomTextField(labelText: "Dosage",hintText: "Enter Dosage",),
                    10.verticalSpace,
                    CustomTextField(labelText: "Refill Date",hintText: "Enter date",),
                    10.verticalSpace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Notes",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.lightGrey.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 10.h,
                        ),
                        child: TextField(
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: "Avoid antibiotics in same family",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: AppFonts.jakartaRegular,
                          ),
                        ),
                      ),
                    ),
                    30.verticalSpace,
                    CustomButton(borderRadius: 15, text: "Save", onTap: (){}),
                    10.verticalSpace,
                    CustomButton(borderRadius: 15, text: "Send to Patient", onTap: (){},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12.w,
            top: 55.h,
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
