import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/auth_controllers/sign_up_controller.dart';
import 'package:patient_app/screens/auth_screens/web_supporting_document_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/progress_stepper.dart';

class WebProfessionalInfoScreen extends StatelessWidget {
  WebProfessionalInfoScreen({super.key});

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
                            "Professional Info",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppFonts.jakartaBold,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          15.verticalSpace,
                          const ProgressStepper(currentStep: 3, totalSteps: 5),
                          25.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: "Identity",
                                  hintText: "MA-PK-451271",
                                ),
                              ),
                              15.horizontalSpace,
                              Expanded(
                                child: buildDropdownField(
                                  title: "Medical Specialty",
                                  items: ["Cardiology", "Neurology", "General"],
                                  selectedValue: "".obs,
                                  onChanged: (val) {},
                                ),
                              ),
                            ],
                          ),
                          15.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: "Experience (in years)",
                                  hintText: "7",
                                ),
                              ),
                              15.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildDropdownField(
                                      title: "Fee",
                                      items: ["\$25/ 30 mint45"],
                                      selectedValue: "".obs,
                                      onChanged: (val) {},
                                    ),
                                    5.verticalSpace,
                                    Text(
                                      "Standard consultation rate, editable later",
                                      style: TextStyle(fontSize: 4.sp, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          15.verticalSpace,
                          _buildDatePickerField(context, "Date of Registration"),
                          15.verticalSpace,
                          buildDropdownField(
                            title: "Place of Practice (Separate with comma)",
                            items: ["Allied Hospital, Faisalabad"],
                            selectedValue: "".obs,
                            onChanged: (val) {},
                          ),
                          15.verticalSpace,
                          buildDropdownField(
                            title: "Year",
                            items: ["2008", "2009", "2010"],
                            selectedValue: "".obs,
                            onChanged: (val) {},
                          ),
                          15.verticalSpace,
                          buildDropdownField(
                            title: "Country",
                            items: ["Faisalabad", "Lahore", "Karachi"],
                            selectedValue: "".obs,
                            onChanged: (val) {},
                          ),
                          30.verticalSpace,
                          Center(
                            child: CustomButton(
                              borderRadius: 10,
                              fontSize: 8,
                              text: AppStrings.continueText.tr,
                              onTap: () {
                                Get.to(WebSupportingDocumentsScreen());
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

  Widget _buildDatePickerField(BuildContext context, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        5.verticalSpace,
        InkWell(
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
                  "15 March 2018",
                  style: TextStyle(fontSize: 6.sp, color: Colors.black),
                ),
                Icon(Icons.calendar_today_outlined, size: 8.sp, color: Colors.blue),
              ],
            ),
          ),
        ),
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
    required RxString selectedValue,
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              hint: Text(items.first, style: TextStyle(fontSize: 5.sp)),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 5.sp)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}