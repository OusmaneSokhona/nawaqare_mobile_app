import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/payment_detail_screen.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/app_images.dart';
import '../widgets/custom_button.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                70.verticalSpace,
                Row(
                  children: [
                    InkWell(
                      onTap: (){
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
                      "Summary",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23.sp,
                        fontWeight: FontWeight.w800,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                _buildFeeSummaryCard(),
                15.verticalSpace,
                _buildEstimatedDelivery(),
                15.verticalSpace,
                _buildPharmacyDetails(),
                15.verticalSpace,
                _buildCertificationNote(),
                30.verticalSpace,
                CustomButton(borderRadius: 15, text: "Confirm order", onTap: (){
                  Get.to(PaymentDetailScreen());
                }),
                20.verticalSpace,
                CustomButton(borderRadius: 15, text: "Cancel", onTap: (){
                  Get.back();
                },bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeeSummaryCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFeeItem('Amoxicillin 500mg', 'Price for 10mg',156),
            const Divider(height: 20, thickness: 1, color: Color(0xFFE0E0E0)),
            _buildFeeItem('Panadol 500mg', 'Price for 5mg', 120),
            const Divider(height: 20, thickness: 1, color: Color(0xFFE0E0E0)),
            _buildFeeItem('Delivery Charges', 'if home delivery', 2.0, isDelivery: true),
            const Divider(height: 20, thickness: 1, color: Color(0xFFE0E0E0)),
           _buildTotalFee('Total Fee', 330.0),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeItem(String title, String subtitle, double amount, {bool isDelivery = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDelivery ? Colors.black54 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        Text(
          '\$${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalFee(String title, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildEstimatedDelivery() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Delivery Time',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Expected within 2–3 business days',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildPharmacyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pharmacy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pharmacie Centrale',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationNote() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Licensed Pharmacy — Certified by CNPD & Ministry of Health',
        style: TextStyle(
          fontSize: 14,
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}