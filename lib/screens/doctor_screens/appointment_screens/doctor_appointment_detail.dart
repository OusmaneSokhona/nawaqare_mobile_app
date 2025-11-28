import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/confirmation_dialog.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_appoinment_detail_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_past_appoinment_widget.dart';
import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../patient_screens/video_call_screens/preview_screen.dart';

class DoctorAppointmentDetail extends StatelessWidget {
  bool isCompleted;

  DoctorAppointmentDetail({
    super.key,
    required this.appointmentModel,
    this.isCompleted = false,
  });

  final AppointmentModel appointmentModel;

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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.dialog(ConfirmationDialog());
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "Appointment Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              30.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DoctorAppoinmentDetailWidget(
                        appointmentModel: appointmentModel,
                      ),
                      if (isCompleted) ...{
                        DoctorPastAppoinmentWidget(),
                      } else ...{
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            "Status",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            Container(
                              height: 30.h,
                              width: 30.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: Icon(Icons.check, color: Colors.white),
                            ),
                            10.horizontalSpace,
                            Text(
                              "Confirmed",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.jakartaMedium,
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            "Symptoms History",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          height: 170.h,
                          width: 1.sw,
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patient Symptoms",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFonts.jakartaBold,
                                ),
                              ),
                              10.verticalSpace,
                              Text(
                                "Patient reports persistent headaches, mild nausea, and dizziness. Symptoms occur mostly in the morning. No prior medication taken",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,  ),
                              ),
                            ],
                          ),
                        ),
                        MedicalReportCard(title: "Blood Test Report", date: "200/Sep/2025"),

                        30.verticalSpace,
                        CustomButton(
                          borderRadius: 15,
                          text: "Join Consultation",
                          onTap: () {
                            Get.to(
                              PreviewScreen(appointmentModel: appointmentModel),
                            );
                          },
                        ),
                        10.verticalSpace,
                        CustomButton(
                          borderRadius: 15,
                          text: "Reschedule",
                          onTap: () {},
                          bgColor: AppColors.inACtiveButtonColor,
                          fontColor: Colors.black,
                        ),
                      },
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
