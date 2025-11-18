import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/order_screens/report_issue_screen.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/order_widgets/order_status_card.dart';
import 'package:patient_app/widgets/order_widgets/track_order_card.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

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
                    "Track Order",
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
                    TrackOrderCard(),
                    12.verticalSpace,
                    Image.asset("assets/demo_images/map_demo.png",width: 1.sw,height: 170.h,fit: BoxFit.fill,),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Get.to(ReportIssueScreen());
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.inACtiveButtonColor,
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10.0,
                            ),
                          ),
                          child:  Text('Report An Issue',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.sp,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_phone_outlined,size: 25.sp,color: Colors.white,),
                              Text('Contact Driver',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                  fontFamily: AppFonts.jakartaMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    CustomButton(borderRadius: 15, text: "Contact Pharmacy", onTap: (){},icon: Icons.local_phone_outlined,fontColor: Colors.black,bgColor: AppColors.inACtiveButtonColor,),
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
