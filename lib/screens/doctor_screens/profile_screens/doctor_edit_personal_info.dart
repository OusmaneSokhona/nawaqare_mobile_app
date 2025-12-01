import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
      body:  Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.onboardingBackground, Colors.white,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal:20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: (){
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
                    "Edit Personal Info",
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
                      15.verticalSpace,
                      ProfilePictureWidget(
                        onTap: controller.showImageSourceOptions,
                        pickedImage: controller.pickedImage,
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: "Full Name",
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
                                "Date of Birth",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  // Medium boldness
                                  color:
                                  Colors
                                      .black87, // Darker text for the label
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
                                      // Display the formatted date
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                        controller.selectedDate ==
                                            null
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
                        label: "Email",
                        value: controller.emailController.text,
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: "Phone Number",
                        value: controller.phoneNumberController.text,
                      ),
                      10.verticalSpace,
                      buildDropdownField(
                        title: 'Gender',
                        items: controller.genderList,
                        selectedValue: controller.selectedGender,
                        onChanged: controller.updateSelectedGender,
                      ),
                      buildDropdownField(
                        title: 'Country of Residence',
                        items: controller.countryList,
                        selectedValue: controller.selectedCountry,
                        onChanged: controller.updateSelectedCountry,
                      ),
                      buildDropdownField(
                        title: 'Religion',
                        items: controller.religionList,
                        selectedValue: controller.selectedReligion,
                        onChanged: controller.updateSelectedReligion,
                      ),
                      CustomTextField(
                        labelText: "ID Number",
                        prefixIcon: Icons.badge_outlined,
                        hintText: "31101-5678-9876",
                      ),
                      CustomTextField(
                        labelText: "Clinic Address",
                        prefixIcon: Icons.location_on,
                        hintText: "32 Examaple St",
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'About Me',
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
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: TextField(
                          maxLines: 5,
                          onTapOutside: (_){
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'Write something about you',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              CustomButton(
                text: "Update",
                onTap: (){
                  Get.back();
                },
                borderRadius: 15,
              ),
              10.verticalSpace,
              CustomButton(
                text: "Cancel",
                onTap: (){
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
    final List<DateTime?>? dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: Colors.blue,
        centerAlignModePicker: true,
      ),
      dialogSize: const Size(325, 400),
      value: [controller.selectedDate],
      // Current date value
      borderRadius: BorderRadius.circular(15),
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
