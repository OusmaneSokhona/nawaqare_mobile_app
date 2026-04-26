import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import 'package:patient_app/screens/pharmacy_screens/partial_fulfilment_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/prescription_screens/prepartion_and_delivery_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/reject_prescription_screen.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/pharmacy_widgets/share_for_delivery_dialog.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';

class PharmacyPrescriptionDetailScreen extends StatelessWidget {
  PharmacyPrescriptionDetailScreen({super.key});
  final PharmacyPrescriptionController controller = Get.put(PharmacyPrescriptionController());

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
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.prescriptionDetail.tr,
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
                      10.verticalSpace,
                      _buildDoctorInfo(),
                      20.verticalSpace,
                      _buildSectionTitle(AppStrings.medication.tr),
                      10.verticalSpace,
                      _buildMedicationCard('Amoxicillin 500mg', 10, '1 tab BID', true),
                      20.verticalSpace,
                      _buildSectionTitle(AppStrings.pricingSummary.tr),
                      10.verticalSpace,
                      _buildPricingSummary(),
                      20.verticalSpace,
                      _buildSectionTitle(AppStrings.prescriptionQR.tr),
                      10.verticalSpace,
                      _buildQRSection(),
                      20.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.validatePrescription.tr,
                        onTap: () {
                          Get.to( PrepartionAndDeliveryScreen());
                        },
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.proposePartial.tr,
                        onTap: () {
                          Get.to(PartialFulfillmentProposalScreen());
                        },
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                      ),
                      10.verticalSpace,
                      Center(
                        child: InkWell(
                          onTap: () => Get.to(RejectPrescriptionScreen()),
                          child: Text(
                            AppStrings.reject.tr,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.redAccent,
                            ),
                          ),
                        ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Row(
        children: <Widget>[
          Image(
            image: const AssetImage('assets/demo_images/patient_1.png'),
            height: 50.h,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Text(
                'Dr. Sarah Malik',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${AppStrings.prescriptionId.tr}: RX-20410',
                style: TextStyle(fontSize: 14.sp, color: AppColors.lightGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(String name, int quantity, String dosage, bool inStock) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _medicationHeader(name),
          15.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailRow(AppStrings.qty.tr, quantity.toString()),
              Align(alignment: Alignment.centerRight, child: _buildStockStatus(inStock)),
            ],
          ),
          _buildDetailRow(AppStrings.dosage.tr, dosage),
          const SizedBox(height: 10),
          _medicationHeader(name),
          15.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailRow(AppStrings.qty.tr, quantity.toString()),
              Align(alignment: Alignment.centerRight, child: _buildStockStatus(false)),
            ],
          ),
          _buildDetailRow(AppStrings.dosage.tr, dosage),
        ],
      ),
    );
  }

  Widget _medicationHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(name, style: TextStyle(fontSize: 17.sp, color: Colors.black, fontWeight: FontWeight.w600)),
        const Row(
          children: <Widget>[
            Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Icon(Icons.cached, color: Colors.blue, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: <Widget>[
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(fontSize: 14, color: AppColors.lightGrey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStockStatus(bool inStock) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: inStock ? Colors.orange[400] : Colors.red,
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Text(
        inStock ? AppStrings.inStock.tr : AppStrings.outOfStock.tr,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildPricingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
      ),
      child: Column(
        children: <Widget>[
          _buildPriceRow(AppStrings.subtotal.tr, '\$156', AppColors.primaryColor, FontWeight.normal),
          const SizedBox(height: 8),
          _buildPriceRow(AppStrings.deliveryCharges.tr, '\$2.00', AppColors.primaryColor, FontWeight.normal, subtitle: AppStrings.ifHomeDelivery.tr),
          const Divider(height: 20, thickness: 1),
          _buildPriceRow(AppStrings.totalFee.tr, '\$158', Colors.blue, FontWeight.bold, fontSize: 18.0),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, Color amountColor, FontWeight amountWeight, {String? subtitle, double fontSize = 16.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500, color: Colors.black87)),
            if (subtitle != null) Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        Text(amount, style: TextStyle(fontSize: fontSize, fontWeight: amountWeight, color: amountColor)),
      ],
    );
  }

  Widget _buildQRSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset("assets/images/qr_icon.png", height: 120.h),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Prescription', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.dialog(ShareForDeliveryDialog()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(AppStrings.shareForDelivery.tr, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.inACtiveButtonColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(AppStrings.downloadQR.tr, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}