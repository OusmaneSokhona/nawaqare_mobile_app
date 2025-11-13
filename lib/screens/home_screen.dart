import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/home_controller.dart';
import 'package:patient_app/screens/appointment_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/appointment_card.dart';
import 'package:patient_app/widgets/category_button.dart';
import 'package:patient_app/widgets/next_action_row.dart';
import 'package:patient_app/widgets/order_tracking_card.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});
HomeController homeController=Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    homeController.scrollChange();
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.primaryColor.withOpacity(0.01),AppColors.primaryColor.withOpacity(0.01)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Obx(
                  () {
                final bool isScrolledPastThreshold = homeController.scrollValue.value >= 280;

                final double targetHeight = isScrolledPastThreshold ? 100.0 : 0.0;

                final Color targetColor = isScrolledPastThreshold
                    ? AppColors.primaryColor
                    : Colors.transparent;

                return AnimatedContainer(duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  height: targetHeight,
                  width: 1.sw,
                  color: targetColor,
                );
              },
            ),            Expanded(
              child: SingleChildScrollView(
                controller: homeController.scrollController,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 18.sp),
                  child: Column(
                    children: [
                      60.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(radius: 35.h,backgroundColor: Colors.white,foregroundImage: AssetImage("assets/demo_images/home_demo_image.png"),),
                          Image.asset("assets/images/bell_icon.png",height: 30.h,),
                        ],
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Hello,\nMr. Alex",textAlign:TextAlign.start,style: TextStyle(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: AppFonts.jakartaBold,
                        ),),
                      ),
                      Align(alignment:Alignment.centerLeft,child: Text("Tomorrow at 10:30 AM",style: TextStyle(fontWeight: FontWeight.w800,fontFamily: AppFonts.jakartaBold,fontSize: 20.sp,color: AppColors.darkGrey),)),
                      5.verticalSpace,
                      Align(alignment:Alignment.centerLeft,child: Text("Dr Dupuis",style: TextStyle(fontWeight: FontWeight.w800,fontFamily: AppFonts.jakartaBold,fontSize: 20.sp,color: AppColors.lightGrey),)),
                      15.verticalSpace,
                      AppointmentCard(title: "Ongoing  Appointment",imagePath: "assets/demo_images/doctor_2.png",name:"Dr. Maria Waston",type: 'Heart Surgeon',),
                      15.verticalSpace,
                      AppointmentCard(title: "Upcoming Appointment",imagePath: "assets/demo_images/doctor_1.png",name:"Dr. Daniel Lee",type: 'Gastroenterologist',),
                      15.verticalSpace,
                      OrderTrackingCard(currentStep: 2),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryButton(onTap: (){
                            Get.to(AppointmentScreen());
                          },title:"Appointments", icon:"assets/images/calender_icon.png", color:AppColors.primaryColor),
                          CategoryButton(title:"Prescription", icon:"assets/images/prescription_icon.png", color:AppColors.green),
                          CategoryButton(title:"Orders", icon:"assets/images/box_icon.png", color:AppColors.orange),
                        ],
                      ),
                      15.verticalSpace,
                  NextActionsRow(),
                      10.verticalSpace,
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
}
