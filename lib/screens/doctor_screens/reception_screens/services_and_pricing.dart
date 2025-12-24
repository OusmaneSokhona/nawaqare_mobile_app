import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/service_and_pricing_controller.dart';
import 'package:patient_app/screens/doctor_screens/reception_screens/add_service_reception.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_radio_tile.dart';
import 'package:patient_app/widgets/doctor_widgets/reception_widgets/edit_price_dialogs.dart';
import 'package:patient_app/widgets/doctor_widgets/reception_widgets/edit_service_dialog.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class ServicesAndPricing extends StatelessWidget {
  ServicesAndPricing({super.key});

  final ServiceAndPricingController controller = Get.put(
    ServiceAndPricingController(),
  );

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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      "assets/images/back_icon.png",
                      height: 22.h,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.servicesPricing.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              5.verticalSpace,
              Text(
                AppStrings.servicesPricingPreview.tr,
                style: TextStyle(
                  fontSize: 14.sp, // Adjusted slightly for long translations
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
              10.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      profileType(AppStrings.availabilityPerService.tr, 130.w),
                      9.horizontalSpace,
                      profileType(AppStrings.durationPricing.tr, 100.w),
                      9.horizontalSpace,
                      profileType(AppStrings.globalPolicies.tr, 85.w),
                    ],
                  ),
                ),
              ),
              10.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(
                        () => _buildSelectedTabContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    // Note: Comparing against translated string can be risky if keys change.
    // Ideally use an enum or the original AppStrings key.
    if (controller.type.value == AppStrings.availabilityPerService.tr) {
      return Column(
        children: [
          buildConsultationCard(
            title: AppStrings.generalConsultation.tr,
            typeIcon: Icons.apartment_outlined,
            typeDescription: AppStrings.inPersonConsultation.tr,
            location: AppStrings.locationHint.tr,
            schedule: 'Mon-Friday',
            onEditPressed: () => Get.dialog(EditServiceDialog()),
          ),
          10.verticalSpace,
          buildConsultationCard(
            title: AppStrings.teleconsultation.tr,
            typeIcon: Icons.call_outlined,
            typeDescription: AppStrings.remoteConsultation.tr,
            location: AppStrings.virtualRoom.tr,
            schedule: 'Tue-Sat',
            onEditPressed: () => Get.dialog(EditServiceDialog()),
          ),
          30.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: AppStrings.addService.tr,
            onTap: () => Get.to(AddServiceReception()),
          ),
        ],
      );
    } else if (controller.type.value == AppStrings.durationPricing.tr) {
      return Column(
        children: [
          buildDurationAndPricingCard(
            title: AppStrings.generalConsultation.tr,
            time: '30min',
            price: "\$45",
            onEditPressed: () => Get.dialog(EditPriceDialogs()),
          ),
          10.verticalSpace,
          buildDurationAndPricingCard(
            title: AppStrings.teleconsultation.tr,
            price: "\$45",
            time: "45min",
            onEditPressed: () => Get.dialog(EditPriceDialogs()),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          CustomDropdown(
            label: AppStrings.minBookingNotice.tr,
            options: const ["2 hours", "4 hours", "6 hours", "8 hours"],
            currentValue: controller.selectedTime.value,
            onChanged: (val) => controller.selectedTime.value = val!,
          ),
          10.verticalSpace,
          CustomDropdown(
            label: AppStrings.bufferTime.tr,
            options: const ["5 mint", "10 mint", "20 mint"],
            currentValue: controller.selectedBufferTime.value,
            onChanged: (val) => controller.selectedBufferTime.value = val!,
          ),
          10.verticalSpace,
          Obx(() => CustomRadioTile(
            text: AppStrings.cancellationPolicyText.tr,
            isSelected: controller.selectPolicy.value,
            onTap: () => controller.selectPolicy.value = !controller.selectPolicy.value,
            isCircle: false,
            fontSize: 11.sp,
          )),
          20.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: AppStrings.save.tr,
            onTap: () {},
          ),
          10.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: AppStrings.cancel.tr,
            onTap: () => Get.back(),
            bgColor: AppColors.inACtiveButtonColor,
            fontColor: Colors.black,
          )
        ],
      );
    }
  }

  Widget profileType(String title, double width) {
    return Obx(
          () => InkWell(
        onTap: () => controller.type.value = title,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: controller.type.value == title ? AppColors.primaryColor : AppColors.lightGrey,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            2.verticalSpace,
            controller.type.value == title
                ? Container(
              width: width,
              height: 3.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(7.sp),
              ),
            )
                : const SizedBox(height: 3),
          ],
        ),
      ),
    );
  }

  // Card builders stay mostly same, but use AppStrings.location.tr and AppStrings.priceLabel.tr
  Widget buildConsultationCard({
    required String title,
    required IconData typeIcon,
    required String typeDescription,
    required String location,
    required String schedule,
    VoidCallback? onEditPressed,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                IconButton(
                  icon: ImageIcon(const AssetImage("assets/images/edit_icon.png"),
                      size: 23.sp, color: AppColors.primaryColor),
                  onPressed: onEditPressed,
                ),
              ],
            ),
            Row(
              children: [
                Icon(typeIcon, size: 18.sp, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text(typeDescription, style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(text: '${AppStrings.location.tr}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: location, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 19.sp, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text(schedule, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDurationAndPricingCard({
    required String title,
    required String price,
    required String time,
    VoidCallback? onEditPressed,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                IconButton(
                  icon: ImageIcon(const AssetImage("assets/images/edit_icon.png"),
                      size: 23.sp, color: AppColors.primaryColor),
                  onPressed: onEditPressed,
                ),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(text: '${AppStrings.priceLabel.tr}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: price, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.watch_later_outlined, size: 19.sp, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text(time, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}