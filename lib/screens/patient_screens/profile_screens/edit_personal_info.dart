import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/patient_controllers/auth_controllers/sign_up_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/display_field.dart';
import '../../../widgets/profile_picture_widget.dart';

class EditPersonalInfo extends GetView<SignUpController> {
   EditPersonalInfo({super.key});
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
                20.verticalSpace,
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
                            fontWeight: FontWeight.w500, // Medium boldness
                            color: Colors.black87, // Darker text for the label
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
                                controller.formattedDate,
                                // Display the formatted date
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
                DisplayFieldContainer(label: "Email", value: controller.emailController.text),
                10.verticalSpace,
                DisplayFieldContainer(label: "Phone Number", value: controller.phoneNumberController.text),
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
                buildDropdownField(
                  title: 'Department',
                  items: controller.departmentList,
                  selectedValue: controller.selectedDepartment,
                  onChanged: controller.updateSelectedDepartment,
                ),
                CustomTextField(labelText: "Address",hintText: "32 Examaple St",),
                30.verticalSpace,
                CustomButton(borderRadius: 15, text: "Update", onTap: (){}),
                10.verticalSpace,
                CustomButton(borderRadius: 15, text: "Cancel", onTap: (){},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
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
