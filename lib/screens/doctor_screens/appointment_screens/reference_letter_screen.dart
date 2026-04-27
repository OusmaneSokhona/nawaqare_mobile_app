import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/doctor_controllers/reference_letter_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class ReferenceLetterScreen extends StatelessWidget {
  final String consultationId;

  ReferenceLetterScreen({super.key, required this.consultationId});

  late final ReferenceLetterController controller =
      Get.put(ReferenceLetterController(consultationId: consultationId));

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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              _buildHeader(),
              20.verticalSpace,
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              if (controller.referenceLetters.isEmpty)
                                _buildEmptyState(),
                              if (controller.referenceLetters.isNotEmpty)
                                _buildLettersList(),
                              30.verticalSpace,
                              CustomButton(
                                borderRadius: 15,
                                text: "Refer Patient to Specialist",
                                onTap: () => _showReferralBottomSheet(),
                              ),
                              30.verticalSpace,
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reference Letters",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              5.verticalSpace,
              Text(
                "Specialist referrals and consultations",
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 12.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail_outlined,
            size: 80.sp,
            color: AppColors.lightGrey,
          ),
          20.verticalSpace,
          Text(
            "No Referrals Yet",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          10.verticalSpace,
          Text(
            "Refer your patient to a specialist when needed",
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 13.sp,
              fontFamily: AppFonts.jakartaRegular,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLettersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Active Referrals",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        15.verticalSpace,
        ...controller.referenceLetters.map((letter) => _buildLetterCard(letter)).toList(),
      ],
    );
  }

  Widget _buildLetterCard(ReferenceLetter letter) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Referral to ${letter.specialty}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      letter.reasonForReferral,
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 12.sp,
                        fontFamily: AppFonts.jakartaRegular,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: controller.getStatusColor(letter.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  controller.getStatusLabel(letter.status),
                  style: TextStyle(
                    color: controller.getStatusColor(letter.status),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ),
            ],
          ),
          15.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: controller.getUrgencyColor(letter.urgency).withOpacity(0.15),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Text(
              _formatUrgency(letter.urgency),
              style: TextStyle(
                color: controller.getUrgencyColor(letter.urgency),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
          if (letter.clinicalSummary.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "Summary: ${letter.clinicalSummary}",
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 11.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (letter.responseContent != null && letter.responseContent!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Container(
                width: 1.sw,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.green.withOpacity(0.3)),
                ),
                child: Text(
                  "Response: ${letter.responseContent}",
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 11.sp,
                    fontFamily: AppFonts.jakartaRegular,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showReferralBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Refer Patient to Specialist",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                20.verticalSpace,
                _buildTextField(
                  label: "Specialty",
                  controller: controller.specialtyController,
                  hint: "e.g., Cardiology, Neurology",
                ),
                15.verticalSpace,
                _buildDropdownField(
                  label: "Urgency",
                  value: controller.urgencyController.value.toString().split('.').last,
                  items: ['ROUTINE', 'URGENT', 'EMERGENCY'],
                  onChanged: (value) {
                    final urgency = ReferralUrgency.values.firstWhere(
                      (e) => e.toString().split('.').last == value,
                      orElse: () => ReferralUrgency.ROUTINE,
                    );
                    controller.urgencyController.value = urgency;
                  },
                ),
                15.verticalSpace,
                _buildTextField(
                  label: "Clinical Summary",
                  controller: controller.clinicalSummaryController,
                  hint: "Patient clinical history and current status",
                  maxLines: 4,
                ),
                15.verticalSpace,
                _buildTextField(
                  label: "Reason for Referral",
                  controller: controller.reasonForReferralController,
                  hint: "Why is this specialist consultation needed?",
                  maxLines: 3,
                ),
                20.verticalSpace,
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                        size: 18.sp,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          "This referral will be added to the patient's medical record",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12.sp,
                            fontFamily: AppFonts.jakartaRegular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                25.verticalSpace,
                Obx(
                  () => CustomButton(
                    borderRadius: 15,
                    text: "Send Referral",
                    isLoading: controller.isSaving.value,
                    onTap: () async {
                      final success = await controller.sendReferralLetter();
                      if (success) {
                        Get.back();
                      }
                    },
                  ),
                ),
                12.verticalSpace,
                CustomButton(
                  borderRadius: 15,
                  text: "Cancel",
                  onTap: () => Get.back(),
                  bgColor: AppColors.inACtiveButtonColor,
                  fontColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.inACtiveButtonColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 13.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaRegular,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.inACtiveButtonColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: items.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    _formatDropdownValue(val),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.jakartaRegular,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatUrgency(String urgency) {
    switch (urgency) {
      case 'ROUTINE':
        return 'Routine';
      case 'URGENT':
        return 'Urgent';
      case 'EMERGENCY':
        return 'Emergency';
      default:
        return urgency;
    }
  }

  String _formatDropdownValue(String value) {
    return value.replaceAll('_', ' ').replaceAllMapped(RegExp(r'(?:^|_)([a-z])'), (match) {
      return match.group(1)?.toUpperCase() ?? '';
    });
  }
}
