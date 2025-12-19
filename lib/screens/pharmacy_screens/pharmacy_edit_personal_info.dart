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

class PharmacyEditPersonalInfo extends GetView<SignUpController> {
  PharmacyEditPersonalInfo({super.key});
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
                        value: "Alex Martin Pharmacy",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Registration ID",
                        hintText: "#123RT56",
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: "Phone Number",
                        value: "+33 3 6 12 34 56 78",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Pharmacy  Address",
                        prefixIcon: Icons.location_on_outlined,
                        hintText: "32 Examaple St",
                      ),
                      CustomTextField(
                        labelText: "City",
                        prefixIcon: Icons.location_on,
                        hintText: "32 Examaple St",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Area / Locality",
                        prefixIcon: Icons.location_on,
                        hintText: "32 Examaple St",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Operating Hours",
                        hintText: "5pm-10am",
                      ),
                      30.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Update", onTap: (){}),
                      10.verticalSpace,
                      CustomButton(borderRadius: 15, text: "Cancel", onTap: (){Get.back();},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
                      40.verticalSpace,
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
