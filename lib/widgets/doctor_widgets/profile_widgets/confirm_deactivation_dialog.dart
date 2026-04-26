import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/utils/app_colors.dart';

class ConfirmDeactivationDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  final String? title;
  final String? message;
  final bool isActivation;

  const ConfirmDeactivationDialog({
    super.key,
    this.onConfirm,
    this.title,
    this.message,
    this.isActivation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "assets/images/deactivation_dialog_icon.png",
              height: 110.h,
              errorBuilder: (context, error, stackTrace) {
                // Fallback icon if image not found
                return Icon(
                  isActivation ? Icons.check_circle_outline : Icons.warning_amber_outlined,
                  size: 80.sp,
                  color: isActivation ? AppColors.green : AppColors.primaryColor,
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              title ?? (isActivation ? AppStrings.confirmActivation.tr : AppStrings.confirmDeactivation.tr),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? (isActivation
                  ? AppStrings.activationWarning.tr
                  : AppStrings.deactivationWarning.tr),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
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
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      if (onConfirm != null) {
                        onConfirm!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActivation ? AppColors.green : AppColors.primaryColor,
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