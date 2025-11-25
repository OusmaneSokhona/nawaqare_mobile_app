import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/prescription_widgets/delivery_options_card.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class PaymentDetailScreen extends StatelessWidget {
  const PaymentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 1.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.onboardingBackground, Colors.white,],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),child: Padding(
            padding:  EdgeInsets.symmetric(horizontal:20.w),
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
                  "Prescription Received",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Align(alignment:Alignment.centerLeft,child: Text("Your Prescription Is Available",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: AppColors.darkGrey),)),
            20.verticalSpace,
                      DeliveryOptionsCard(),
                      40.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Confirm Order", onTap: (){}),
                      15.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Modify", onTap: (){},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
                    ],
                  ),
          ),),
    );
  }
}
