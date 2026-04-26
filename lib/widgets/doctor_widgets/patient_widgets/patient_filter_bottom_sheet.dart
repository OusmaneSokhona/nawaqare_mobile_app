import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/patient_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../patient_widgets/video_call_widgets/setting widgets.dart';

class PatientFilterBottomSheet extends StatelessWidget {
  final String initialStatus;
  final Function(String) onApply;
  final VoidCallback onReset;

  PatientFilterBottomSheet({
    super.key,
    required this.initialStatus,
    required this.onApply,
    required this.onReset,
  });

  final PatientController patientController = Get.find();
  final RxString selectedStatus = RxString('');

  @override
  Widget build(BuildContext context) {
    // Initialize with the current value
    selectedStatus.value = initialStatus;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(4),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              label: AppStrings.status.tr,
              options: patientController.statusOptions,
              currentValue: selectedStatus.value,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  selectedStatus.value = newValue;
                }
              },
            ),
            const SizedBox(height: 32),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.inACtiveButtonColor,
                      foregroundColor: Colors.black87,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      onReset();
                      Get.back();
                    },
                    child: Text(
                      AppStrings.reset.tr,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      onApply(selectedStatus.value);

                    },
                    child: Text(
                      AppStrings.apply.tr,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}