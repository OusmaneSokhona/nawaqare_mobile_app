import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/service_pricing_controller.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class ServicePricingScreen extends StatelessWidget {
  ServicePricingScreen({super.key});
ServicePricingController controller = Get.put(ServicePricingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.onboardingBackground,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              60.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 28.h,
                      fit: BoxFit.fill,
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
              10.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.verticalSpace,
                      _buildFeeField(
                        labelText: "Remote Consultation Fee",
                        hintText: "Enter fee amount",
                        serviceController: controller,
                        controller: controller.remoteFeeController,
                        icon: Icons.videocam,
                      ),
                      10.verticalSpace,
                      _buildFeeField(
                        labelText: "In-Person Consultation Fee",
                        hintText: "Enter fee amount",
                          serviceController: controller,
                        controller: controller.inPersonFeeController,
                        icon: Icons.person,
                      ),
                      10.verticalSpace,
                      _buildFeeField(
                        labelText: "Home Visit Consultation Fee",
                        hintText: "Enter fee amount",
                          serviceController: controller,
                        controller: controller.homeVisitFeeController,
                        icon: Icons.home,
                      ),
                      10.verticalSpace,
                      _buildCurrencyField(),
                      20.verticalSpace,
                      Obx(
                            () => controller.isLoading.value
                            ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                            : Column(
                          children: [
                            CustomButton(
                              borderRadius: 15,
                              text: "Update Fees",
                              onTap: () {
                                if (_validateFields()) {
                                  controller.updateFees();
                                }
                              },
                            ),
                            10.verticalSpace,
                            CustomButton(
                              text: "Cancel",
                              onTap: () {
                                Get.back();
                              },
                              borderRadius: 15,
                              bgColor: AppColors.inACtiveButtonColor,
                              fontColor: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeeField({
    required String labelText,
    required String hintText,
    required ServicePricingController serviceController,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
            child: Row(
              children: [
                Icon(icon, size: 18.sp, color: Colors.blue),
                8.horizontalSpace,
                Text(
                  labelText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Obx(
                        () => Text(
                      serviceController.selectedCurrency.value,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 10.0),
            child: Row(
              children: [
                Icon(Icons.currency_exchange, size: 18.sp, color: Colors.blue),
                8.horizontalSpace,
                Text(
                  "Currency",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Obx(
                () => DropdownButtonFormField<String>(
              value: controller.selectedCurrency.value,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.darkGrey),
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              items: controller.currencyList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: controller.updateSelectedCurrency,
            ),
          ),
        ],
      ),
    );
  }

  bool _validateFields() {
    if (controller.remoteFeeController.text.isNotEmpty &&
        controller.inPersonFeeController.text.isNotEmpty &&
        controller.homeVisitFeeController.text.isNotEmpty) {
      return true;
    }

    Get.snackbar(
      "Validation Error",
      "Please fill all fields",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return false;
  }
}