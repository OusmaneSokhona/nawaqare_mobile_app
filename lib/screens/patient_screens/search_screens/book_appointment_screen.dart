import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/appointment_model.dart';
import 'package:patient_app/widgets/progress_stepper.dart';import '../../../controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/search_widgets/book_appointment_widgets.dart';
import 'my_appointment_screens.dart';

class BookAppointmentScreen extends StatelessWidget {
  final AppointmentModel model;
   BookAppointmentScreen({super.key,required this.model});
BookAppointmentController controller =Get.put(BookAppointmentController());
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
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "Book Appointment",
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      30.verticalSpace,
                      Padding(
                        padding:  EdgeInsets.only(right: 13.sp),
                        child: ProgressStepper(currentStep: 1, totalSteps: 3),
                      ),
                      5.verticalSpace,
                      Row(mainAxisAlignment:MainAxisAlignment.start,children: [
                        Text("Section",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13.sp,),),
                        100.horizontalSpace,
                        Text("Details",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13.sp,),),
                        Spacer(),
                        Text("Confirmation",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13.sp,),),
                      ],),
                      10.verticalSpace,
                      CircleAvatar(
                        radius: 50.r,
                        backgroundImage: AssetImage(model.imageUrl),
                      ),
                      10.verticalSpace,
                      Text(
                        model.name,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        model.specialty,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jakartaBold,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        model.consultationType,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.jakartaBold,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      15.verticalSpace,
                      Container(
                        height: 55.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.sp),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                                  () => InkWell(
                                onTap: () {
                                  controller.appointmentType.value =
                                  "inPerson";
                                },
                                child: Container(
                                  height: 55.h,
                                  width: 0.405.sw,
                                  decoration: BoxDecoration(
                                    color:
                                    controller.appointmentType.value ==
                                        "inPerson"
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "In Person",
                                    style: TextStyle(
                                      color:
                                      controller.appointmentType.value ==
                                          "inPerson"
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.jakartaMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                                  () => InkWell(
                                onTap: () {
                                  controller.appointmentType.value = "remote";
                                },
                                child: Container(
                                  height: 55.h,
                                  width: 0.405.sw,
                                  decoration: BoxDecoration(
                                    color:
                                    controller.appointmentType.value ==
                                        "remote"
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(14.sp),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Remote",
                                    style: TextStyle(
                                      color:
                                      controller.appointmentType.value ==
                                          "remote"
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.jakartaMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      ConsultationDetailsCard(controller: controller),
                      10.verticalSpace,
                       Align(
                         alignment: Alignment.centerLeft,
                         child: Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                                               ),
                       ),
                      10.verticalSpace,
                      CalendarWidget(controller: controller),
                     10.verticalSpace,
                       Align(
                         alignment: Alignment.centerLeft,
                         child: Text(
                          'Available Times',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                                               ),
                       ),
                     5.verticalSpace,
                      TimeSlotsGrid(controller: controller),
                      30.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Confirm Appointment", onTap: (){
                        Get.to(MyAppointmentScreens(model: model));
                      }),
                      30.verticalSpace,
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
}
