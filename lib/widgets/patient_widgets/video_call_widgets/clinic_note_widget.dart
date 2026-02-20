import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/soap_controller.dart';

class ClinicalNoteWidget extends StatelessWidget {
  final String appointmentId;

  const ClinicalNoteWidget({
    Key? key,
    required this.appointmentId,
  }) : super(key: key);

  Widget _buildSoapField(String label, String hint,
      {int maxLines = 4, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
        8.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13.sp,
              ),
              contentPadding: const EdgeInsets.all(12),
              border: InputBorder.none,
            ),
          ),
        ),
        15.verticalSpace,
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoapNoteController>(
      init: SoapNoteController(appointmentId: appointmentId),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F9FF),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Soap Notes",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    20.verticalSpace,
                    _buildSoapField(
                      "Reason",
                      "Hypertention",
                      maxLines: 1,
                      controller: controller.reasonController,
                    ),
                    _buildSoapField(
                      "Subjective",
                      "Enter subjective notes...",
                      controller: controller.subjectiveController,
                    ),
                    _buildSoapField(
                      "Objective",
                      "Enter objective notes...",
                      controller: controller.objectiveController,
                    ),
                    _buildSoapField(
                      "Assessment",
                      "Enter assessment notes...",
                      controller: controller.assessmentController,
                    ),
                    _buildSoapField(
                      "Plan",
                      "Enter plan notes...",
                      controller: controller.planController,
                    ),
                    20.verticalSpace,
                    _buildActionButton(
                      label: "Finalize note",
                      color: const Color(0xFF4A89DC),
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                    12.verticalSpace,
                    _buildActionButton(
                      label: "Save draft",
                      color: const Color(0xFFE0E0E0).withOpacity(0.5),
                      textColor: const Color(0xFF333333),
                      onPressed: () {},
                    ),
                    12.verticalSpace,
                    _buildActionButton(
                      label: "Create Note",
                      color: const Color(0xFFE0E0E0).withOpacity(0.5),
                      textColor: const Color(0xFF333333),
                      onPressed: () {controller.createSoapNote();},
                    ),
                    40.verticalSpace,
                  ],
                ),
              ),
              Obx(() => controller.isLoading.value
                  ? Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              )
                  : const SizedBox.shrink()),
            ],
          ),
        );
      },
    );
  }
}