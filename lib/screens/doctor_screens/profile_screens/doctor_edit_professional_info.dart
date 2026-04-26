import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/auth_controllers/sign_up_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class DoctorEditProfessionalInfo extends GetView<SignUpController> {
  DoctorEditProfessionalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.onboardingBackground,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    AppStrings.editProfessionalInfo.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.nationalIdentityDocument.tr,
                        hintText: "MA-PK-451271",
                        controller: controller.idNumberController,
                      ),
                      10.verticalSpace,
                      buildDropdownField(
                        title: AppStrings.medicalSpeciality.tr,
                        items: controller.medicalSpecialityList,
                        selectedValue: controller.selectedSpecialist,
                        onChanged: controller.updateSpecialization,
                      ),
                      CustomTextField(
                        labelText: AppStrings.experienceInYears.tr,
                        hintText: "7",
                        keyboardType: TextInputType.number,
                        controller: controller.experienceController,
                      ),
                      _buildFeeField(
                        labelText: "Remote Consultation Fee",
                        hintText: "e.g., 50",
                        controller: controller.remoteConsultationFeeController,
                      ),
                      _buildFeeField(
                        labelText: "In-Person Consultation Fee",
                        hintText: "e.g., 100",
                        controller: controller.inPersonConsultationFeeController,
                      ),
                      _buildFeeField(
                        labelText: "Home Visit Consultation Fee",
                        hintText: "e.g., 150",
                        controller: controller.homeVisitConsultationFeeController,
                      ),
                      Obx(
                            () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, left: 12.0),
                              child: Row(
                                children: [
                                  Text(
                                    AppStrings.dateOfRegistration.tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => _showDatePicker(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.formattedDate,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: controller.selectedDate == null
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.placeOfPractice.tr,
                        hintText: "Allied Hospital, Faisalabad",
                        controller: controller.placeOfPracticeController,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.year.tr,
                        hintText: "2008",
                        keyboardType: TextInputType.number,
                        controller: controller.yearOfWorkController,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Country",
                        hintText: "e.g., Pakistan",
                        controller: controller.selectedCountry.value != null
                            ? TextEditingController(text: controller.selectedCountry.value)
                            : TextEditingController(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateSelectedCountry(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              Obx(
                    () => controller.isLoading.value
                    ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
                    : Column(
                  children: [
                    CustomButton(
                      borderRadius: 15,
                      text: AppStrings.update.tr,
                      onTap: () {
                        if (_validateFields()) {
                          controller.editProfessionalInfoDoctor();
                        }
                      },
                    ),
                    10.verticalSpace,
                    CustomButton(
                      text: AppStrings.cancel.tr,
                      onTap: () {
                        Get.back();
                      },
                      borderRadius: 15,
                      bgColor: AppColors.inACtiveButtonColor,
                      fontColor: Colors.black,
                    ),
                  ],
                ),
              ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeeField({
    required String labelText,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
            child: Row(
              children: [
                Text(
                  labelText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    '\$ ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _validateFields() {
    if (controller.experienceController.text.isNotEmpty ||
        controller.remoteConsultationFeeController.text.isNotEmpty ||
        controller.inPersonConsultationFeeController.text.isNotEmpty ||
        controller.homeVisitConsultationFeeController.text.isNotEmpty ||
        controller.placeOfPracticeController.text.isNotEmpty ||
        controller.yearOfWorkController.text.isNotEmpty ) {
      return true;
    }

    Get.snackbar(
      "Validation Error",
      "Please fill at least one field",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return false;
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime maxDate = DateTime(now.year - 18, now.month, now.day);
    final DateTime minDate = DateTime(
      now.year - 120,
      now.month,
      now.day,
    );

    final List<DateTime?>? dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: Colors.blue,
        centerAlignModePicker: true,
        firstDate: minDate,
        lastDate: maxDate,
      ),
      dialogSize: const Size(325, 400),
      value: [controller.selectedDate],
      borderRadius: BorderRadius.circular(15),
    );

    if (dates != null && dates.isNotEmpty && dates[0] != null) {
      final selectedDate = dates[0]!;
      if (_isAtLeast18YearsOld(selectedDate)) {
        controller.updateDate(selectedDate);
      } else {
        _showAgeErrorDialog(context);
      }
    }
  }

  bool _isAtLeast18YearsOld(DateTime birthDate) {
    final DateTime now = DateTime.now();
    final DateTime eighteenYearsAgo = DateTime(
      now.year - 18,
      now.month,
      now.day,
    );
    return birthDate.isBefore(eighteenYearsAgo) ||
        (birthDate.year == eighteenYearsAgo.year &&
            birthDate.month == eighteenYearsAgo.month &&
            birthDate.day == eighteenYearsAgo.day);
  }

  void _showAgeErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Age Restriction',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You must be at least 18 years old to register.',
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildDropdownField({
    required String title,
    required List<String> items,
    required Rx<String?> selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 10.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Obx(
                () => DropdownButtonFormField<String>(
              value: selectedValue.value,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.darkGrey),
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}