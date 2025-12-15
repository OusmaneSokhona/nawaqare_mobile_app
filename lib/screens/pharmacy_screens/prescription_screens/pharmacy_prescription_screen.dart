import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_prescription_card.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_prescription_filter_bottom_sheet.dart';
import '../../../controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';


class PharmacyPrescriptionScreen extends StatelessWidget {
  PharmacyPrescriptionScreen({super.key});

  final PharmacyPrescriptionController pharmacyPrescriptionController = Get.put(
    PharmacyPrescriptionController(),
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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Prescriptions",
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Manage Active Prescriptions And Archive.",
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.jakartaMedium,
                  ),
                ),
              ),
              10.verticalSpace,
              _buildTabSection(),
              15.verticalSpace,
              _buildSearchAndFilter(),
              10.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(
                            () => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "My Prescriptions (${pharmacyPrescriptionController.activePrescriptions.length})",
                            style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      _buildPrescriptionList(),
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

  Widget _buildTabSection() {
    return Container(
      height: 55.h,
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.sp),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
                () => InkWell(
              onTap: () {
                pharmacyPrescriptionController.type.value = "myPrescription";
              },
              child: Container(
                height: 55.h,
                width: 0.455.sw,
                decoration: BoxDecoration(
                  color:
                  pharmacyPrescriptionController.type.value ==
                      "myPrescription"
                      ? AppColors.primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14.sp),
                ),
                alignment: Alignment.center,
                child: Text(
                  "My Prescriptions(${pharmacyPrescriptionController.activePrescriptions.length})",
                  style: TextStyle(
                    color:
                    pharmacyPrescriptionController.type.value ==
                        "myPrescription"
                        ? Colors.white
                        : Colors.black,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ),
            ),
          ),
          Obx(
                () => InkWell(
              onTap: () {
                pharmacyPrescriptionController.type.value = "archive";
              },
              child: Container(
                height: 55.h,
                width: 0.455.sw,
                decoration: BoxDecoration(
                  color:
                  pharmacyPrescriptionController.type.value ==
                      "archive"
                      ? AppColors.primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14.sp),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Archive",
                  style: TextStyle(
                    color:
                    pharmacyPrescriptionController.type.value ==
                        "archive"
                        ? Colors.white
                        : Colors.black,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return CustomTextField(
      hintText: "Search Prescription / Patient ID",
      prefixIcon: Icons.search,
      suffixIcon: Icons.filter_list,
      suffixIconColor: AppColors.primaryColor,
      prefixIconColor: AppColors.darkGrey,
      onSuffixIconTap: () {
        _showFilterSheet(Get.context!);
      },
    );
  }

  Widget _buildPrescriptionList() {
    return Obx(
          () => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: 20.h,
        ),
        itemCount:
        pharmacyPrescriptionController.currentList.length,
        itemBuilder: (context, index) {
          return PharmacyPrescriptionCard(
            onTap: () {
            },
            prescription:
            pharmacyPrescriptionController.currentList[index],
          );
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return PharmacyPrescriptionFilterBottomSheet(
          onApply: () {
            Get.back();
          },
          onReset: () {
            Get.back();
          },
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final Color suffixIconColor;
  final Color prefixIconColor;
  final VoidCallback? onSuffixIconTap;

  const CustomTextField({
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.suffixIconColor = Colors.blue,
    this.prefixIconColor = Colors.grey,
    this.onSuffixIconTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.sp),
        border: Border.all(color: AppColors.onboardingBackground),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.lightGrey, fontSize: 14.sp),
          prefixIcon: Icon(prefixIcon, color: prefixIconColor, size: 20.sp),
          suffixIcon: suffixIcon != null
              ? InkWell(
            onTap: onSuffixIconTap,
            child: Icon(suffixIcon, color: suffixIconColor, size: 22.sp),
          )
              : null,
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    required this.text,
    required this.onTap,
    this.borderRadius = 10,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.sp),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
      ),
    );
  }
}