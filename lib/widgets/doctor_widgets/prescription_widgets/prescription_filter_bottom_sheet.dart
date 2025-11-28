
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_prescription_controller.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

class PrescriptionFilterBottomSheet extends StatelessWidget {
  final String initialStatus;
  final VoidCallback onApply;
  final VoidCallback onReset;

   PrescriptionFilterBottomSheet({
    super.key,
    required this.initialStatus,
    required this.onApply,
    required this.onReset,
  });
DoctorPrescriptionController doctorPrescriptionController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
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
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 16),
CustomDropdown(label: "Status", options: doctorPrescriptionController.statusOptions, currentValue: doctorPrescriptionController.selectedStatus.value, onChanged: (_){}),



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
                  onPressed: onReset,
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  onPressed: onApply,
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}