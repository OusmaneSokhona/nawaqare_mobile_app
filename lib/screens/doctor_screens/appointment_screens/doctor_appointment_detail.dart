import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/doctor_appointment_model.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/confirmation_dialog.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_appoinment_detail_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_home_visit_status_dialog.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_past_appoinment_widget.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/home_visit_request_detail_screen.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class DoctorAppointmentDetail extends StatelessWidget {
  final bool isCompleted;
  final DoctorAppointment appointmentModel;
  final RxBool statusSetedHomeVisit = false.obs;

  DoctorAppointmentDetail({
    super.key,
    required this.appointmentModel,
    this.isCompleted = false,
  });

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
                    AppStrings.appointmentDetails.tr,
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
                            AppStrings.status.tr,
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
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: const Icon(Icons.check, color: Colors.white),
                            ),
                            10.horizontalSpace,
                            Text(
                              AppStrings.confirmed.tr,
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
                            AppStrings.symptomsHistory.tr,
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
                                AppStrings.patientSymptoms.tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFonts.jakartaBold,
                                ),
                              ),
                              10.verticalSpace,
                              Text(
                                AppStrings.symptomsDescription.tr,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        HomeVisitRequestDetailScreen(),
                        10.verticalSpace,
                        MedicalReportCard(
                            title: AppStrings.bloodTestReport.tr,
                            date: "200/Sep/2025",onlyView: true,
                        ),

                        30.verticalSpace,
                        Obx(() => statusSetedHomeVisit.value
                            ? CustomButton(
                          borderRadius: 15,
                          text: AppStrings.joinConsultation.tr,
                          onTap: () {
                            // Get.to(
                            //   // PreviewScreen(appointment: appointmentModel),
                            // );
                          },
                        )
                            : CustomButton(
                          borderRadius: 15,
                          text: AppStrings.accept.tr,
                          onTap: () {
                            Get.dialog(DoctorHomeVisitStatusDialog(status: true));
                            statusSetedHomeVisit.value = true;
                          },
                        )),
                        10.verticalSpace,
                        Obx(() => statusSetedHomeVisit.value
                            ? CustomButton(
                          borderRadius: 15,
                          text: AppStrings.reschedule.tr,
                          onTap: () {},
                          bgColor: AppColors.inACtiveButtonColor,
                          fontColor: Colors.black,
                        )
                            : CustomButton(
                          borderRadius: 15,
                          text: AppStrings.decline.tr,
                          onTap: () {
                            Get.dialog(DoctorHomeVisitStatusDialog(status: false));
                            statusSetedHomeVisit.value = true;
                          },
                          bgColor: AppColors.inACtiveButtonColor,
                          fontColor: Colors.black,
                        )),
                        30.verticalSpace,
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