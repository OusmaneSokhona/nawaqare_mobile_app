import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/doctor_model.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/patient_widgets/search_widgets/doctor_detail_widget.dart';
import '../../../widgets/patient_widgets/search_widgets/rating_widget.dart';
import 'book_appointment_screen.dart';

class SearchDoctorDetailScreen extends StatelessWidget {
  final DoctorModel doctor;

  const SearchDoctorDetailScreen({super.key, required this.doctor});

  String _getConsultationTypeText() {
    if (doctor.fee?.videoConsultation != null && doctor.fee?.inPersonConsultation != null) {
      return 'Both Remote & In-Person';
    } else if (doctor.fee?.videoConsultation != null) {
      return 'Remote Consultation';
    } else if (doctor.fee?.inPersonConsultation != null) {
      return 'In-Person Consultation';
    }
    return 'Consultation Available';
  }

  int _getExperienceYears() {
    return doctor.experience ?? 0;
  }

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
                    onTap: () => Get.back(),
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.doctorDetails.tr,
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
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.white,
                        child: doctor.displayImage.startsWith('http')
                            ? ClipOval(
                          child: Image.network(
                            doctor.displayImage,
                            width: 100.r,
                            height: 100.r,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/demo_images/doctor_1.png',
                                width: 100.r,
                                height: 100.r,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        )
                            : Image.asset(
                          doctor.displayImage,
                          width: 100.r,
                          height: 100.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        doctor.fullName,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        doctor.medicalSpecialty ?? 'General Practitioner',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.jakartaBold,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        _getConsultationTypeText(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.jakartaBold,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      10.verticalSpace,
                      InkWell(
                        onTap: () {
                          _showPhoneNumberDialog(context);
                         },
                        child: Container(
                          height: 50.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            border: Border.all(
                              color: AppColors.lightGrey.withOpacity(0.3),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.showNumber.tr,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingWidget(
                            icon: Icons.person_outline_outlined,
                            iconCircleColor: AppColors.primaryColor,
                            metricText: "2000+",
                            labelText: AppStrings.patients.tr,
                          ),
                          RatingWidget(
                            icon: Icons.ac_unit,
                            iconCircleColor: AppColors.green,
                            metricText: "${_getExperienceYears()}+",
                            labelText: AppStrings.experience.tr,
                          ),
                          RatingWidget(
                            icon: Icons.star_border,
                            iconCircleColor: AppColors.orange,
                            metricText: doctor.ratingValue.toStringAsFixed(1),
                            labelText: AppStrings.rating.tr,
                          ),
                          RatingWidget(
                            icon: Icons.mark_chat_unread_outlined,
                            iconCircleColor: AppColors.primaryColor.withOpacity(0.9),
                            metricText: "1872",
                            labelText: AppStrings.reviews.tr,
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      DoctorDetailWidget(doctor: doctor),
                      15.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.bookAppointment.tr,
                        onTap: () {
                          Get.to(BookAppointmentScreen( doctor: doctor,));
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
  void _showPhoneNumberDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.phone,
              size: 50.sp,
              color: AppColors.primaryColor,
            ),
            15.verticalSpace,
            Text(
              "Doctors Phone Number",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
            10.verticalSpace,
            Container(
              padding: EdgeInsets.all(15.sp),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    doctor.phoneNumber,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                  10.horizontalSpace,
                  IconButton(
                    onPressed: () async {
                      await FlutterClipboard.copy(doctor.phoneNumber);
                      Get.back();
                      Get.snackbar(
                        "Copied",
                        "Doctor's phone number copied to clipboard.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primaryColor,
                        colorText: Colors.white,
                        duration: Duration(seconds: 2),
                      );
                    },
                    icon: Icon(
                      Icons.content_copy,
                      color: AppColors.primaryColor,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
            15.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: BorderSide(color: AppColors.primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Text(
                      "cancel",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}