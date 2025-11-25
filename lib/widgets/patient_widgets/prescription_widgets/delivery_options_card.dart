import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/prescription_controller.dart';
import 'package:patient_app/utils/app_colors.dart';

import '../../../models/delivery_options_model.dart';

class DeliveryOptionsCard extends StatelessWidget {
  const DeliveryOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    PrescriptionController controller = Get.find();

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  'Pharmacie Centrale',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
             Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '12 Rue De La Santé',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.link, size: 16.sp, color: AppColors.primaryColor),
                      SizedBox(width: 4),
                      Text(
                        'Availability:',
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Immediate',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 0.5),
            Text(
              'Delivery Option',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
                  () => Column(
                children: controller.options
                    .map((option) => _buildDeliveryRadioTile(
                  context,
                  controller,
                  option,
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryRadioTile(
      BuildContext context,
      PrescriptionController controller,
      DeliveryOption currentOption,
      ) {
    return RadioListTile<DeliveryOption>(
      value: currentOption,
      groupValue: controller.selectedOption.value,
      onChanged: controller.selectOption,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.primaryColor,
      title: Text(
        currentOption.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      secondary: Text(
        currentOption.priceText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: currentOption.isFree ? Colors.blue : Colors.black87,
        ),
      ),
    );
  }
}