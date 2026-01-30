import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/medical_vitals.dart';
import 'package:patient_app/widgets/display_field.dart';
import 'package:patient_app/widgets/profile_picture_widget.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/progress_stepper.dart';
import '../../widgets/validation_check_list.dart';

class CompleteProfile extends StatelessWidget {
  CompleteProfile({super.key});

  SignUpController signUpController = Get.find();

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
              80.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/back_icon.png",
                      height: 32.h,
                      width: 32.w,
                    ),
                  ),
                  7.horizontalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.completeProfile.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.verticalSpace,
                      ProgressStepper(currentStep: 2, totalSteps: 4),
                      15.verticalSpace,
                      ProfilePictureWidget(
                        onTap: signUpController.showImageSourceOptions,
                        pickedImage: signUpController.pickedImage,
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: AppStrings.fullName.tr,
                        value: signUpController.nameController.text,
                      ),
                      10.verticalSpace,
                      Obx(
                            () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                AppStrings.dob.tr,
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
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      signUpController.formattedDate,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                        signUpController.selectedDate == null
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
                      DisplayFieldContainer(label: AppStrings.email.tr, value: signUpController.emailController.text),
                      10.verticalSpace,
                      DisplayFieldContainer(label: AppStrings.phoneNumber.tr, value: signUpController.phoneNumberController.text),
                      10.verticalSpace,
                      buildDropdownField(
                        title: AppStrings.gender.tr,
                        items: signUpController.genderList,
                        selectedValue: signUpController.selectedGender,
                        onChanged: signUpController.updateSelectedGender,
                      ),
                      buildDropdownField(
                        title: AppStrings.countryResidence.tr,
                        items: signUpController.countryList,
                        selectedValue: signUpController.selectedCountry,
                        onChanged: signUpController.updateSelectedCountry,
                      ),
                      buildDropdownField(
                        title: AppStrings.religion.tr,
                        items: signUpController.religionList,
                        selectedValue: signUpController.selectedReligion,
                        onChanged: signUpController.updateSelectedReligion,
                      ),
                      CustomTextField(labelText: AppStrings.address.tr, hintText: "32 Examaple St",controller: signUpController.addressController,)
                    ],
                  ),
                ),
              ),

              20.verticalSpace,
              CustomButton(borderRadius: 15, text: AppStrings.continueText.tr, onTap: () {
                if(signUpController.selectedDate == null||
                    signUpController.selectedGender.value == null||
                    signUpController.selectedCountry.value == null||
                    signUpController.selectedReligion.value==null||
                    signUpController.selectedDepartment.value == null||signUpController.addressController.text.isEmpty
                ){
                  Get.snackbar(AppStrings.warning.tr, AppStrings.pleaseFillAllFields.tr,snackPosition: SnackPosition.BOTTOM,backgroundColor: AppColors.red,colorText: Colors.white);
                }else{
                  Get.to(MedicalVitals());}
              }),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime maxDate = DateTime(now.year - 18, now.month, now.day);
    final DateTime minDate = DateTime(now.year - 120, now.month, now.day); // Optional: set a reasonable minimum age

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
      value: [signUpController.selectedDate],
      borderRadius: BorderRadius.circular(15),
    );

    if (dates != null && dates.isNotEmpty && dates[0] != null) {
      final selectedDate = dates[0]!;

      if (_isAtLeast18YearsOld(selectedDate)) {
        signUpController.updateDate(selectedDate);
      } else {
        _showAgeErrorDialog(context);
      }
    }
  }

  bool _isAtLeast18YearsOld(DateTime birthDate) {
    final DateTime now = DateTime.now();
    final DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
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
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'You must be at least 18 years old to register.',
          style: TextStyle(
            fontSize: 16.sp,
          ),
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
                contentPadding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              isExpanded: true,
              icon:  Icon(Icons.keyboard_arrow_down, color: AppColors.darkGrey),
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