import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/appointment_model.dart';
import 'package:patient_app/widgets/progress_stepper.dart';
import '../../../controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/search_widgets/my_appointment_doctor_card.dart';
import '../../../widgets/patient_widgets/search_widgets/summary_card.dart';
import '../appointment_screens/payment_screen.dart';

class MyAppointmentScreens extends StatelessWidget {
  final AppointmentModel model;

  MyAppointmentScreens({super.key, required this.model});

  final BookAppointmentController controller = Get.put(BookAppointmentController());

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
                    AppStrings.myAppointment.tr,
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
                        padding: EdgeInsets.only(right: 13.sp),
                        child: const ProgressStepper(currentStep: 2, totalSteps: 3),
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.section.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                          ),
                          100.horizontalSpace,
                          Text(
                            AppStrings.details.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            AppStrings.confirmation.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                      MyAppointmentDoctorCard(
                        doctorName: model.name,
                        specialization: model.specialty,
                        consultationDuration: AppStrings.consultationDuration.tr,
                        imageUrl: model.imageUrl,
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.appointmentSummary.tr,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      AppointmentSummaryCard(
                        appointmentType: model.consultationType ?? 'Follow Up',
                        date: model.date ?? DateTime.now().toIso8601String(),
                        time: model.time ?? '3:00 PM',
                        consultationFee: model.fee ?? 0.0,
                        totalFee: (model.fee ?? 0.0) + 2.0, // Adding $2 service fee
                      ),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.next.tr,
                        onTap: () {
                          Get.to(() => PaymentScreen(
                          ));
                        },
                      ),
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