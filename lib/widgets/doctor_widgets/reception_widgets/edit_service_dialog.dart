import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/service_and_pricing_controller.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

class EditServiceDialog extends StatelessWidget {
  const EditServiceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ServiceAndPricingController controller = Get.find();
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              AppStrings.generalConsultation.tr,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
            5.verticalSpace,
            CustomTextField(
              labelText: AppStrings.location.tr,
              hintText: "Clinic Room 2",
            ),
            10.verticalSpace,
            Obx(
                  () => CustomDropdown(
                label: AppStrings.days.tr,
                options: controller.daysList.map((e) => e.tr).toList(),
                currentValue: controller.selectedDay.value.tr,
                onChanged: (val) {
                  // Logic to update controller
                },
              ),
            ),
            10.verticalSpace,
            Obx(
                  () => CustomDropdown(
                label: AppStrings.mode.tr,
                options: controller.modeList.map((e) => e.tr).toList(),
                currentValue: controller.selectedMode.value.tr,
                onChanged: (val) {
                  // Logic to update controller
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      AppStrings.cancel.tr,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.confirm.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}