import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';

import '../../utils/app_fonts.dart';

class ShareForDeliveryDialog extends StatelessWidget {
  ShareForDeliveryDialog({super.key});

  final PharmacyPrescriptionController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0.r),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeader(),
              20.verticalSpace,
              Obx(() => CustomDropdown(
                label: AppStrings.deliveryCompany.tr,
                options: const ["DHL", "FedEx", "Aramex", "Local Express"],
                currentValue: controller.slectedCompany.value,
                onChanged: (val) {
                  if (val != null) controller.slectedCompany.value = val;
                },
              )),
              10.verticalSpace,
              CustomTextField(
                hintText: "+33 3 6 12 34 56 78",
                labelText: AppStrings.phoneNumber.tr,
              ),
              5.verticalSpace,
              Text(
                AppStrings.deliveryAutoFillNote.tr,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
              20.verticalSpace,
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      AppStrings.shareForDelivery.tr,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        fontFamily: AppFonts.jakartaBold,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              side: BorderSide.none,
            ),
            child: Text(
              AppStrings.cancel.tr,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        15.horizontalSpace,
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Add confirmation logic here
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              AppStrings.confirmSending.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}