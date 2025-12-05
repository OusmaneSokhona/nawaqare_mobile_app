import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/service_and_pricing_controller.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/screens/auth_screens/sign_in_screen.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/shared_prefrence.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

class EditServiceDialog extends StatelessWidget {
  const EditServiceDialog({super.key});

  @override
  Widget build(BuildContext context) {
ServiceAndPricingController controller=Get.find();
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
            Text("General Consultation",style: TextStyle(fontSize: 22.sp,fontWeight:FontWeight.w700,fontFamily: AppFonts.jakartaBold),),
            5.verticalSpace,
            CustomTextField(labelText: "Location",hintText: "Clinic Room 2",),
            10.verticalSpace,
            CustomDropdown(label: "Days", options: controller.daysList, currentValue: controller.selectedDay.value, onChanged: (_){}),
            10.verticalSpace,
            CustomDropdown(label: "Mode", options: controller.modeList, currentValue: controller.selectedMode.value, onChanged: (_){}),
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