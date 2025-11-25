import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class ReportIssueScreen extends StatelessWidget {
  const ReportIssueScreen({super.key});

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
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),child: Column(children: [
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
                "Report Issue",
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
          CustomTextField(labelText: "Issue",hintText: "Parcel Cancellation",),
          20.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: TextField(
              maxLines: 5,
              onTapOutside: (_){
                FocusManager.instance.primaryFocus!.unfocus();
              },
              decoration: InputDecoration(
                hintText: 'My parcel is cancle without my permission',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),
          ),
          60.verticalSpace,
          CustomButton(borderRadius: 15, text: "Send", onTap: (){
          }),
          20.verticalSpace,
          CustomButton(borderRadius: 15, text: "Cancel", onTap: (){
            Get.back();
          },bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
        ],),),
      ),
    );
  }
}
