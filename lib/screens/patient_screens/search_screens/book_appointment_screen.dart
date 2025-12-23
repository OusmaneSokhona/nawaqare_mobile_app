import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/appointment_model.dart';
import 'package:patient_app/widgets/progress_stepper.dart';
import '../../../controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart'; // Added import
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/search_widgets/book_appointment_widgets.dart';
import 'my_appointment_screens.dart';

class BookAppointmentScreen extends StatelessWidget {
  final AppointmentModel model;
  BookAppointmentScreen({super.key, required this.model});

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
                    onTap: () => Get.back(),
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.bookAppointment.tr,
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
                        child: const ProgressStepper(currentStep: 1, totalSteps: 3),
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(AppStrings.section.tr, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp)),
                          100.horizontalSpace,
                          Text(AppStrings.details.tr, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp)),
                          const Spacer(),
                          Text(AppStrings.confirmation.tr, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp)),
                        ],
                      ),
                      10.verticalSpace,
                      CircleAvatar(
                        radius: 50.r,
                        backgroundImage: AssetImage(model.imageUrl),
                      ),
                      10.verticalSpace,
                      Text(
                        model.name,
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, fontFamily: AppFonts.jakartaBold),
                      ),
                      2.verticalSpace,
                      Text(
                        model.specialty,
                        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, fontFamily: AppFonts.jakartaBold, color: AppColors.darkGrey),
                      ),
                      Text(
                        model.consultationType,
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, fontFamily: AppFonts.jakartaBold, color: AppColors.lightGrey),
                      ),
                      15.verticalSpace,
                      _buildTypeToggle(),
                      10.verticalSpace,
                      ConsultationDetailsCard(controller: controller),
                      10.verticalSpace,
                      _buildSectionLabel(AppStrings.selectDate.tr),
                      10.verticalSpace,
                      CalendarWidget(controller: controller),
                      10.verticalSpace,
                      _buildSectionLabel(AppStrings.availableTimes.tr),
                      5.verticalSpace,
                      TimeSlotsGrid(controller: controller),
                      15.verticalSpace,
                      Obx(() => controller.appointmentType.value == "homeVisit" ? _buildAlertBox() : const SizedBox()),
                      15.verticalSpace,
                      Obx(
                            () => CustomButton(
                          borderRadius: 15,
                          text: controller.appointmentType.value != "homeVisit"
                              ? AppStrings.confirmAppointment.tr
                              : AppStrings.submitRequest.tr,
                          onTap: () => Get.to(MyAppointmentScreens(model: model)),
                        ),
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

  Widget _buildTypeToggle() {
    return Container(
      height: 55.h,
      width: 1.sw,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.sp), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _toggleItem("inPerson", AppStrings.inPerson.tr),
          _toggleItem("remote", AppStrings.remote.tr),
          _toggleItem("homeVisit", AppStrings.homeVisit.tr),
        ],
      ),
    );
  }

  Widget _toggleItem(String type, String label) {
    return Obx(() => InkWell(
      onTap: () => controller.appointmentType.value = type,
      child: Container(
        height: 55.h,
        width: 0.280.sw,
        decoration: BoxDecoration(
          color: controller.appointmentType.value == type ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(14.sp),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: controller.appointmentType.value == type ? Colors.white : Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaMedium,
          ),
        ),
      ),
    ));
  }

  Widget _buildSectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
      ),
    );
  }

  Widget _buildAlertBox() {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.sp),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/alert_icon.png", height: 25.sp),
          5.horizontalSpace,
          Expanded(
            child: Text(
              AppStrings.homeVisitAlert.tr,
              style: TextStyle(fontSize: 12.sp, color: AppColors.lightGrey, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}