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
import '../../../widgets/display_field.dart';
import '../../../widgets/profile_picture_widget.dart';

class DoctorEditPersonalInfo extends GetView<SignUpController> {
  DoctorEditPersonalInfo({super.key});

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
                    AppStrings.editPersonalInfo.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Text(
                AppStrings.updatePersonalInfoSub.tr,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: AppFonts.jakartaMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              20.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      15.verticalSpace,
                      ProfilePictureWidget(
                        onTap: controller.showImageSourceOptions,
                        pickedImage: controller.pickedImage,
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: AppStrings.fullName.tr,
                        value: controller.nameController.text,
                      ),
                      10.verticalSpace,
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                AppStrings.dateOfBirth.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.formattedDate,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            controller.selectedDate == null
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
                      DisplayFieldContainer(
                        label: AppStrings.email.tr,
                        value: controller.emailController.text,
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: AppStrings.phoneNumber.tr,
                        value: controller.phoneNumberController.text,
                      ),
                      10.verticalSpace,
                      buildDropdownField(
                        title: AppStrings.gender.tr,
                        items: controller.genderList,
                        selectedValue: controller.selectedGender,
                        onChanged: controller.updateSelectedGender,
                      ),
                      buildDropdownField(
                        title: AppStrings.countryOfResidence.tr,
                        items: controller.countryList,
                        selectedValue: controller.selectedCountry,
                        onChanged: controller.updateSelectedCountry,
                      ),
                      CustomTextField(
                        labelText: AppStrings.idNumber.tr,
                        prefixIcon: Icons.badge_outlined,
                        hintText: "31101-5678-9876",
                        controller: controller.idNumberController,
                      ),
                      CustomTextField(
                        labelText: AppStrings.clinicAddress.tr,
                        prefixIcon: Icons.location_on,
                        hintText: "32 Examaple St",
                        controller: controller.clinicAddressController,
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.aboutMe.tr,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      3.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          maxLines: 5,
                          controller: controller.aboutMeController,
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: AppStrings.aboutMeHint.tr,
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              Obx(
                () =>
                    controller.isLoading.value
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                        : CustomButton(
                          borderRadius: 15,
                          text: AppStrings.update.tr,
                          onTap: () {
                            controller.editPersonalInfoDoctor();
                          },
                        ),
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
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime maxDate = DateTime(now.year - 18, now.month, now.day);
    final DateTime minDate = DateTime(
      now.year - 120,
      now.month,
      now.day,
    ); // Optional: set a reasonable minimum age

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
      builder:
          (context) => AlertDialog(
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
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Obx(
            () => DropdownButtonFormField<String>(
              value: selectedValue.value,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
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
              items:
                  items.map<DropdownMenuItem<String>>((String value) {
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
