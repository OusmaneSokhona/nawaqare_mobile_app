import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/screens/auth_screens/sign_in_screen.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/shared_prefrence.dart';

class ConfirmDeactivationDialog extends StatelessWidget {
  const ConfirmDeactivationDialog({super.key});

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
            Image.asset("assets/images/deactivation_dialog_icon.png",height: 110.h,),
            const SizedBox(height: 16),
            const Text(
              'Confirm  Deactivation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This service will no longer be bookable. Confirm?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back(); // Use Get.back instead of Navigator.pop
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Use Get.back instead of Navigator.pop
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
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontWeight: FontWeight.bold),
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