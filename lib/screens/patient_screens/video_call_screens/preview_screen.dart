import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/patient_screens/video_call_screens/video_call_screen.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_strings.dart'; // Added import
import '../../../widgets/patient_widgets/appointment_widgets/appintment_detail_widget.dart';
import '../../../widgets/patient_widgets/appointment_widgets/past_appointment_widgets.dart';
import '../../../widgets/patient_widgets/video_call_widgets/consultation_card_widget.dart';

class PreviewScreen extends StatelessWidget {
  final AppointmentModel appointmentModel;
  const PreviewScreen({super.key, required this.appointmentModel});

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
        child: Column(
          children: [
            70.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.preview.tr, // Localized
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      AppStrings.cancel.tr, // Localized
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    20.verticalSpace,
                    Image.asset(
                      "assets/demo_images/demo_video_image.png",
                      height: 300.h,
                      width: 1.sw,
                      fit: BoxFit.fill,
                    ),
                    30.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          CardHeader(title: AppStrings.remoteConsultation.tr), // Localized
                          ConsultationCardWidget(
                            appointmentModel: appointmentModel,
                          ),
                          10.verticalSpace,
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: AppColors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: AppColors.orange.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.orange,
                                  size: 24,
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Text(
                                    AppStrings.encryptedCallNote.tr, // Localized
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          30.verticalSpace,
                          CustomButton(
                            borderRadius: 15,
                            text: AppStrings.launchVideo.tr, // Localized
                            onTap: () {
                              Get.to(VideoCallScreen());
                            },
                          ),
                          30.verticalSpace,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}