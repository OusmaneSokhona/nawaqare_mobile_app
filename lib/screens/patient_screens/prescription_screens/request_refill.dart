import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/prescription_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/patient_widgets/prescription_widgets/refill_indicator.dart';

class RequestRefill extends StatelessWidget {
  RequestRefill({super.key});
  final PrescriptionController prescriptionController = Get.find();

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      prescriptionController.noteController.clear();
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
                    AppStrings.requestRefill.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.prescriptions.tr,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Amoxicillin 500mg',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '1 tablet, twice daily after meals',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Dr. Camille Dupont',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const RefillIndicator(
                      progress: 0.6,
                      label: 'Refill 2',
                    ),
                    10.horizontalSpace,
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                AppStrings.refillCycles.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Obx(
                      () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: prescriptionController.selectedCycle.value,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                      isExpanded: true,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      onChanged: prescriptionController.setCycle,
                      items: prescriptionController.refillCycles
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                AppStrings.noteLabel.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: TextField(
                  maxLines: 5,
                  controller: prescriptionController.noteController,
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: AppStrings.writeNoteHint.tr,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                ),
              ),
              20.verticalSpace,
              CustomButton(
                  borderRadius: 15,
                  text: AppStrings.sendRequest.tr,
                  onTap: () {
                    prescriptionController.sendRequest();
                  }),
              20.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: AppStrings.cancel.tr,
                onTap: () {
                  prescriptionController.noteController.clear();
                  Get.back();
                },
                bgColor: AppColors.inACtiveButtonColor,
                fontColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}