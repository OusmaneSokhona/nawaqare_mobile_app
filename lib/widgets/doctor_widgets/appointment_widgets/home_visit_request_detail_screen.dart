import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';

class HomeVisitRequestDetailScreen extends StatelessWidget {
  const HomeVisitRequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.homeVisitRequestDetail.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(AppStrings.patientName.tr, AppStrings.demoPatientName.tr),
              const Divider(height: 32),
              _buildInfoRow(AppStrings.address.tr, AppStrings.demoAddress.tr),
              const Divider(height: 32),
              _buildInfoRow(AppStrings.requestedTimeslot.tr, AppStrings.demoTimeslot.tr),
              const SizedBox(height: 24),
               Text(
                AppStrings.patientNote.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppFonts.jakartaMedium,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
               Text(
                AppStrings.demoNoteValue.tr,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: AppFonts.jakartaMedium,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaMedium,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFamily: AppFonts.jakartaMedium,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}