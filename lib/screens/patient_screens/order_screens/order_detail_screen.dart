import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/patient_widgets/order_widgets/order_detail_card.dart';


class OrderDetailScreen extends StatelessWidget {
  final String status;
  const OrderDetailScreen({super.key,required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
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
          child: Column(children: [
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
                  "Order Details",
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
            OrderDetailCard(status: status,),
          ]),
        ),
      ),
    );
  }
}
