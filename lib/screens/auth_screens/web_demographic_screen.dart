import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/screens/auth_screens/web_professional_info_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/web_profile_picture_widget.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/progress_stepper.dart';

class WebDemographicScreen extends StatelessWidget {
  WebDemographicScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.webBgColor,
      body: Center(
        child: Container(
          margin: isDesktop ? EdgeInsets.all(20.r) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              if (isDesktop)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                    ),
                    image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/web_sign_in_image.png"),
                    ),
                  ),
                  height: 1.sh,
                  width: 0.45.sw,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 75.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to Nawacare",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          "Your central workspace to manage patients, appointments, and care.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 6.sp, color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          "Efficient Care, Simplified",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          "Manage consultations, prescriptions, and follow-ups with ease.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 6.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 25.w : 20.w,
                    vertical: 35.h,
                  ),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.demographicInfo.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppFonts.jakartaBold,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          10.verticalSpace,
                          const ProgressStepper(currentStep: 2, totalSteps: 5),
                          15.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              WebProfilePictureWidget(
                                onTap: signUpController.webshowImageSourceOptions,
                                pickedImageBytes: signUpController.pickedImageBytes,
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: AppStrings.fullName.tr,
                                  hintText: "Saira Tahir",
                                  controller: signUpController.nameController,
                                ),
                              ),
                              15.horizontalSpace,
                              Expanded(
                                child: _buildDatePickerField(context),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: AppStrings.phoneNumber.tr,
                                  hintText: "+33 3 6 12 34 56 78",
                                  controller: signUpController.phoneNumberController,
                                ),
                              ),
                              15.horizontalSpace,
                              Expanded(
                                child: buildDropdownField(
                                  title: AppStrings.gender.tr,
                                  items: signUpController.genderList,
                                  selectedValue: signUpController.selectedGender,
                                  onChanged: signUpController.updateSelectedGender,
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: buildDropdownField(
                                  title: "Nationality",
                                  items: signUpController.countryList,
                                  selectedValue: signUpController.selectedCountry,
                                  onChanged: signUpController.updateSelectedCountry,
                                ),
                              ),
                              15.horizontalSpace,
                              Expanded(
                                child: CustomTextField(
                                  labelText: AppStrings.idNumber.tr,
                                  hintText: "31101-5678-9876",
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          CustomTextField(
                            labelText: AppStrings.clinicAddress.tr,
                            hintText: "32 Examaple St",
                          ),
                          15.verticalSpace,
                          Text(
                            AppStrings.aboutMe.tr,
                            style: TextStyle(
                              fontSize: 5.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          5.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: TextField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: AppStrings.aboutMeHint.tr,
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 6.sp),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12.r),
                              ),
                            ),
                          ),
                          30.verticalSpace,
                          Center(
                            child: CustomButton(
                              borderRadius: 10,
                              fontSize: 8,
                              text: AppStrings.continueText.tr,
                              onTap: () {
                                Get.to(WebProfessionalInfoScreen());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dob.tr,
          style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        5.verticalSpace,
        Obx(() => InkWell(
          onTap: () => _showDatePicker(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  signUpController.formattedDate,
                  style: TextStyle(
                    fontSize: 6.sp,
                    color: signUpController.selectedDate == null ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  void _showDatePicker(BuildContext context) async {
    await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: Colors.blue,
      ),
      dialogSize: const Size(325, 400),
      value: [signUpController.selectedDate],
      borderRadius: BorderRadius.circular(15),
    );
  }

  static Widget buildDropdownField({
    required String title,
    required List<String> items,
    required Rx<String?> selectedValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        5.verticalSpace,
        Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue.value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w500)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        )),
      ],
    );
  }
}