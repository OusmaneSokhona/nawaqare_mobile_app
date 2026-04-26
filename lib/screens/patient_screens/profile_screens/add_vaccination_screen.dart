// import 'package:calendar_date_picker2/calendar_date_picker2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:patient_app/controllers/patient_controllers/medical_history_controller.dart';
// import 'package:patient_app/widgets/custom_button.dart';
// import 'package:patient_app/widgets/custom_text_field.dart';
// import '../../../utils/app_colors.dart';
// import '../../../utils/app_fonts.dart';
// import '../../../utils/app_images.dart';
// import '../../../utils/app_strings.dart';
//
// class AddVaccinationScreen extends StatelessWidget {
//   AddVaccinationScreen({super.key});
//   MedicalHistoryController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 1.sh,
//         width: 1.sw,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.onboardingBackground, Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               70.verticalSpace,
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Image.asset(
//                       AppImages.backIcon,
//                       height: 33.h,
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   10.horizontalSpace,
//                   Text(
//                     AppStrings.addVaccination.tr,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 23.sp,
//                       fontWeight: FontWeight.w800,
//                       fontFamily: AppFonts.jakartaBold,
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       30.verticalSpace,
//                       CustomTextField(
//                         controller: controller.vaccineNameController,
//                         labelText: AppStrings.vaccinationName.tr,
//                         hintText: AppStrings.influenza.tr,
//                       ),
//                       10.verticalSpace,
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           AppStrings.date.tr,
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: AppFonts.jakartaMedium,
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () => _showDatePicker(context),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 18,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 controller.formattedDate,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: controller.selectedDate == null
//                                       ? Colors.grey
//                                       : Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const Icon(
//                                 Icons.calendar_today,
//                                 color: Colors.blue,
//                                 size: 24,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       10.verticalSpace,
//                       buildDropdownField(
//                         title: AppStrings.status.tr,
//                         items: controller.vacinationStatusList,
//                         selectedValue: controller.vaccinationStatus,
//                         onChanged: (value) {
//                           if (value != null) {
//                             controller.vaccinationStatus.value = value;
//                           }
//                         },
//                       ),
//                       10.verticalSpace,
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           AppStrings.uploadCertificate.tr,
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: AppFonts.jakartaMedium,
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: controller.pickFile,
//                         borderRadius: BorderRadius.circular(12),
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.05),
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Obx(
//                                 () => Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.cloud_upload_outlined,
//                                   size: 40,
//                                   color: Colors.blue.shade700,
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   _getUploadText(controller.selectedFileName.value!),
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 if (controller.selectedFileName.value != 'No file selected' && controller.selectedFileName.value != 'File selection cancelled')
//                                   Text(
//                                     AppStrings.tapToSelectNewFile.tr,
//                                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       20.verticalSpace,
//                       Obx(
//                             () => CustomButton(
//                           borderRadius: 15,
//                           text: AppStrings.addAndSave.tr,
//                           onTap: controller.isLoading.value ? (){} : controller.addVaccination,
//                           isLoading: controller.isLoading.value,
//                         ),
//                       ),
//                       10.verticalSpace,
//                       CustomButton(
//                         borderRadius: 15,
//                         text: AppStrings.cancel.tr,
//                         onTap: () {
//                           controller.clearVaccinationForm();
//                           Get.back();
//                         },
//                         bgColor: AppColors.inACtiveButtonColor,
//                         fontColor: Colors.black,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _getUploadText(String value) {
//     if (value == 'No file selected') return AppStrings.uploadLabReportHint.tr;
//     if (value == 'File selection cancelled') return AppStrings.selectionCancelled.tr;
//     return value;
//   }
//
//   void _showDatePicker(BuildContext context) async {
//     final values = await showCalendarDatePicker2Dialog(
//       context: context,
//       config: CalendarDatePicker2WithActionButtonsConfig(
//         calendarType: CalendarDatePicker2Type.single,
//         selectedDayHighlightColor: Colors.blue,
//         centerAlignModePicker: true,
//       ),
//       dialogSize: const Size(325, 400),
//       value: [controller.selectedDate],
//       borderRadius: BorderRadius.circular(15),
//     );
//
//     if (values != null && values.isNotEmpty) {
//       controller.updateDate(values.first);
//     }
//   }
//
//   Widget buildDropdownField({
//     required String title,
//     required List<String> items,
//     required Rx<String?> selectedValue,
//     required Function(String?) onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 2.0, left: 10.0),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           Obx(
//                 () => DropdownButtonFormField<String>(
//               value: selectedValue.value,
//               decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16.0,
//                   vertical: 14.0,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//               isExpanded: true,
//               icon: Icon(Icons.keyboard_arrow_down, color: AppColors.darkGrey),
//               style: TextStyle(fontSize: 16.sp, color: Colors.black),
//               items: items.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: onChanged,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }