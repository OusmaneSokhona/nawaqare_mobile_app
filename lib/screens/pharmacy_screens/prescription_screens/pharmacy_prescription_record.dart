import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';

class PharmacyPrescriptionRecord extends StatelessWidget {
  PharmacyPrescriptionRecord({super.key});
  PharmacyPrescriptionController controller = Get.put(PharmacyPrescriptionController());
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
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.prescriptionRecord.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      20.verticalSpace,
                      _buildHeaderCard(),
                      24.verticalSpace,
                      Text(
                        AppStrings.prescriptionDetails.tr,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      12.verticalSpace,
                      _buildDetailsCard(),
                      24.verticalSpace,
                      Text(
                        AppStrings.pricingSummary.tr,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      12.verticalSpace,
                      _buildPricingCard(),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.exportPdf.tr,
                        onTap: () {
                        },
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.exportCsv.tr,
                        onTap: () {
                        },
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                      ),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHeaderCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${AppStrings.archiveId.tr}: RX-20391",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF64B5F6),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  AppStrings.validated.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 20.h, thickness: 1, color: const Color(0xFFF1F1F1)),
          _infoRow("${AppStrings.patient.tr}: PT-45X2"),
          4.verticalSpace,
          _infoRow("${AppStrings.pharmacistId.tr}: PH-021"),
          4.verticalSpace,
          _infoRow("Dr. A. Rehman"),
          4.verticalSpace,
          _infoRow("Oct 25, 2025"),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _medicineItem("Amoxicillin 500mg", "10", "1 tab BID", "\$20"),
          Divider(height: 32.h, thickness: 1, color: const Color(0xFFF1F1F1)),
          _medicineItem("Amoxicillin 500mg", "10", "1 tab BID", "\$20"),
        ],
      ),
    );
  }

  Widget _medicineItem(String name, String qty, String dosage, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        8.verticalSpace,
        Text(
          "${AppStrings.quantity.tr}: $qty",
          style: TextStyle(fontSize: 15.sp, color: Colors.black87),
        ),
        8.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${AppStrings.dosage.tr}: $dosage",
              style: TextStyle(fontSize: 15.sp, color: Colors.black87),
            ),
            Text(
              "${AppStrings.fee.tr}: $price",
              style: TextStyle(fontSize: 15.sp, color: Colors.black87),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _priceRow(AppStrings.subtotal.tr, "\$156", isBold: true),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.deliveryCharges.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    AppStrings.ifHomeDelivery.tr,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                  ),
                ],
              ),
              Text(
                "\$2.00",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A80E1),
                ),
              ),
            ],
          ),
          Divider(height: 32.h, thickness: 1, color: const Color(0xFFF1F1F1)),
          _priceRow(AppStrings.totalFee.tr, "\$158", isBold: true, larger: true),
        ],
      ),
    );
  }

  Widget _infoRow(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.black87,
        height: 1.4,
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {bool isBold = false, bool larger = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: larger ? 18.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: larger ? 20.sp : 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4A80E1),
          ),
        ),
      ],
    );
  }
}