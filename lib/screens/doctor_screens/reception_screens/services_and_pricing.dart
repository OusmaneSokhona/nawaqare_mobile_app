import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/service_and_pricing_controller.dart';
import 'package:patient_app/screens/doctor_screens/reception_screens/add_service_reception.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_radio_tile.dart';
import 'package:patient_app/widgets/doctor_widgets/reception_widgets/edit_price_dialogs.dart';
import 'package:patient_app/widgets/doctor_widgets/reception_widgets/edit_service_dialog.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/setting%20widgets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class ServicesAndPricing extends StatelessWidget {
  ServicesAndPricing({super.key});

  ServiceAndPricingController controller = Get.put(
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
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/back_icon.png",
                      height: 22.h,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "Services & pricing",
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
                "This Is A Preview Of The Patient’s Booking View",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
              10.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    profileType("Availability per Service", 130.w),
                    9.horizontalSpace,
                    profileType("Duration & Pricing", 100.w),
                    9.horizontalSpace,
                    profileType("Global Policies", 85.w),
                  ],
                ),
              ),
              10.verticalSpace,
              Obx(
                () =>
                    controller.type.value == "Availability per Service"
                        ? Column(
                          children: [
                            buildConsultationCard(
                              title: 'General Consultation',
                              typeIcon: Icons.apartment_outlined,
                              typeDescription: 'In person Consultation',
                              location: 'Clinic Room 2',
                              schedule: 'Mon-Friday',
                              onEditPressed: () {
                                Get.dialog(EditServiceDialog());
                              },
                            ),
                            10.verticalSpace,
                            buildConsultationCard(
                              title: 'Teleconsultation',
                              typeIcon: Icons.call_outlined,
                              typeDescription: 'Remote Consultation',
                              location: 'Virtual Room',
                              schedule: 'Tue-Sat',
                              onEditPressed: () {
                                Get.dialog(EditServiceDialog());
                              },
                            ),
                            30.verticalSpace,
                            CustomButton(
                              borderRadius: 15,
                              text: "Add Service",
                              onTap: () {
                                Get.to(AddServiceReception());
                              },
                            ),
                          ],
                        )
                        :  controller.type.value == "Duration & Pricing"?Column(
                          children: [
                            buildDurationAndPricingCard(
                              title: 'General Consultation',
                              time: '30min',
                              price:
                                  ""
                                  "\$45",
                              onEditPressed: () {
                                Get.dialog(EditPriceDialogs());
                              },
                            ),
                            10.verticalSpace,
                            buildDurationAndPricingCard(
                              title: "Teleconsultation",
                              price: "\$45",
                              time: "45",
                              onEditPressed: () {
                                Get.dialog(EditPriceDialogs());
                              },
                            ),
                          ],
                        ):Column(
                      children: [
                        CustomDropdown(label: "Minimum booking notice", options: ["2 hours","4 hours","6 hours","8 hours"], currentValue: controller.selectedTime.value, onChanged: (_){}),
                        10.verticalSpace,
                        CustomDropdown(label: "buffer time", options: ["10 mint","20 mint","5 mint"], currentValue: controller.selectedBufferTime.value, onChanged: (_){}),
                        10.verticalSpace,
                        Obx(()=> CustomRadioTile(text: "Cancellation policy Free until 24h before appointment ", isSelected: controller.selectPolicy.value, onTap: (){
                          controller.selectPolicy.value=!controller.selectPolicy.value;
                        },isCircle: false,fontSize: 11,)),
                        20.verticalSpace,
                        CustomButton(borderRadius: 15, text: "Save", onTap: (){}),
                        10.verticalSpace,
                        CustomButton(borderRadius: 15, text: "Cancel", onTap: (){},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,)
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileType(String title, double width) {
    return Obx(
      () => InkWell(
        onTap: () {
          controller.type.value = title;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color:
                    controller.type.value == title
                        ? AppColors.primaryColor
                        : AppColors.lightGrey,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            2.verticalSpace,
            controller.type.value == title
                ? Container(
                  width: width.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(7.sp),
                  ),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

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
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: ImageIcon(
                    AssetImage("assets/images/edit_icon.png"),
                    size: 23.sp,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: onEditPressed,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            Row(
              children: [
                Icon(typeIcon, size: 18.sp, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text(
                  typeDescription,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Location: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 19.sp,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  schedule,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
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
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: ImageIcon(
                    AssetImage("assets/images/edit_icon.png"),
                    size: 23.sp,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: onEditPressed,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Price: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.watch_later_outlined,
                  size: 19.sp,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
