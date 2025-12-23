import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/appointment_model.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart'; // Added import
import '../../../widgets/patient_widgets/search_widgets/doctor_detail_widget.dart';
import '../../../widgets/patient_widgets/search_widgets/rating_widget.dart';
import 'book_appointment_screen.dart';

class SearchDoctorDetailScreen extends StatelessWidget {
  final AppointmentModel model;

  const SearchDoctorDetailScreen({super.key, required this.model});

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
                    AppStrings.doctorDetails.tr, // Localized
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
                      10.verticalSpace,
                      Container(
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
                          AppStrings.showNumber.tr, // Localized
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
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
                            labelText: AppStrings.patients.tr, // Localized
                          ),
                          RatingWidget(
                            icon: Icons.ac_unit,
                            iconCircleColor: AppColors.green,
                            metricText: "10+",
                            labelText: AppStrings.experience.tr, // Localized
                          ),
                          RatingWidget(
                            icon: Icons.star_border,
                            iconCircleColor: AppColors.orange,
                            metricText: "5",
                            labelText: AppStrings.rating.tr, // Localized
                          ),
                          RatingWidget(
                            icon: Icons.mark_chat_unread_outlined,
                            iconCircleColor: AppColors.primaryColor.withOpacity(0.9),
                            metricText: "1872",
                            labelText: AppStrings.reviews.tr, // Localized
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      const DoctorDetailWidget(), // Ensure this widget uses .tr for bio headers
                      15.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.bookAppointment.tr, // Localized
                        onTap: () {
                          Get.to(BookAppointmentScreen(model: model));
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