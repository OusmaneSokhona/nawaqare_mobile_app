import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/order_screens/report_issue_screen.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/order_widgets/order_status_card.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

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
                    "Order Status",
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
                  child: Column(children: [
                    20.verticalSpace,
                    OrderStatusCard(),
                    12.verticalSpace,
                    Image.asset("assets/demo_images/map_demo.png",width: 1.sw,height: 170.h,fit: BoxFit.fill,),
                    15.verticalSpace,
                    CustomButton(borderRadius: 15, text: "Contact Pharmacy", onTap: (){},icon: Icons.local_phone_outlined,),
                    10.verticalSpace,
                    CustomButton(borderRadius: 15, text: "Report an issue", onTap: (){
                      Get.to(ReportIssueScreen());
                    },bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
                    30.verticalSpace,
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
