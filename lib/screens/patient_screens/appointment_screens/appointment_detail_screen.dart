import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/appointment_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/patient_widgets/appointment_widgets/appintment_detail_widget.dart';
import '../../../widgets/patient_widgets/appointment_widgets/past_appointment_widgets.dart';
import '../video_call_screens/preview_screen.dart';

class AppointmentDetailScreen extends StatelessWidget {
  bool isCompleted;

  AppointmentDetailScreen({
    super.key,
    required this.appointmentModel,
    this.isCompleted = false,
  });

  final AppointmentModel appointmentModel;
  AppointmentController appointmentController=Get.find<AppointmentController>();

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
                      AppintmentDetailWidget(
                        appointmentModel: appointmentModel,
                      ),
                      10.verticalSpace,
                      isCompleted
                          ?
                      Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(appointmentController.tabs.length, (index) {
                                bool isSelected = appointmentController.selectedTab.value == appointmentController.tabs[index];
                                return GestureDetector(
                                  onTap: () => appointmentController.selectedTab.value = appointmentController.tabs[index],
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          appointmentController.tabs[index],
                                          style: TextStyle(
                                            color: isSelected
                                                ? const Color(0xFF3B82F6)
                                                : const Color(0xFF94A3B8),
                                            fontSize: 10.sp,
                                            fontFamily: AppFonts.jakartaMedium,
                                            fontWeight:
                                            isSelected ? FontWeight.w700 : FontWeight.w500,
                                          ),
                                        ),
                                        if (isSelected) ...[
                                          4.verticalSpace,
                                          Container(
                                            height: 2.5.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3B82F6),
                                              borderRadius: BorderRadius.circular(2.r),
                                            ),
                                          ),
                                        ] else ...[
                                          6.5.verticalSpace,
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                      ):SizedBox.shrink(),
                      if (isCompleted) ...{
                        PastAppointmentWidgets(),
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
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: Icon(Icons.check, color: Colors.white),
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
                            AppStrings.notes.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          AppStrings.medicalNotesDemo.tr,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.jakartaMedium,
                          ),
                        ),
                        70.verticalSpace,
                        CustomButton(
                          borderRadius: 15,
                          text: AppStrings.joinConsultation.tr,
                          onTap: () {
                            Get.to(
                              PreviewScreen(appointmentModel: appointmentModel),
                            );
                          },
                        ),
                        10.verticalSpace,
                        CustomButton(
                          borderRadius: 15,
                          text: AppStrings.reschedule.tr,
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
