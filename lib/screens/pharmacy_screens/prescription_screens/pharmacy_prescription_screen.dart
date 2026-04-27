import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/pharmacy_screens/pharmacy_prescription_detail_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/prescription_screens/pharmacy_dispensing_screen.dart';
import 'package:patient_app/screens/pharmacy_screens/prescription_screens/pharmacy_prescription_record.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_prescription_card.dart';
import 'package:patient_app/widgets/pharmacy_widgets/pharmacy_prescription_filter_bottom_sheet.dart';
import '../../../controllers/pharmacy_controllers/pharmacy_prescription_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_text_field.dart';

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
                    AppStrings.prescriptions.tr,
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
                  AppStrings.manageActivePrescriptions.tr,
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
                          child:
                          pharmacyPrescriptionController.type.value ==
                              "myPrescription"
                              ? Text(
                            "${AppStrings.myPrescriptions.tr} (${pharmacyPrescriptionController.prescriptions.length})",
                            style: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          )
                              : Text(
                            "${AppStrings.archivesLabel.tr} (${pharmacyPrescriptionController.demoData.length})",
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
                      Obx(
                            () =>
                        pharmacyPrescriptionController.type ==
                            "myPrescription"
                            ? _buildPrescriptionList()
                            : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                          pharmacyPrescriptionController
                              .demoData
                              .length,
                          itemBuilder: (context, index) {
                            final item =
                            pharmacyPrescriptionController
                                .demoData[index];
                            return _buildPrescriptionCard(
                              id: item['id'],
                              status: item['status'],
                              statusColor: item['statusColor'],
                            );
                          },
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
                  "${AppStrings.myPrescriptions.tr}(${pharmacyPrescriptionController.prescriptions.length})",
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
                  pharmacyPrescriptionController.type.value == "archive"
                      ? AppColors.primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14.sp),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.archive.tr,
                  style: TextStyle(
                    color:
                    pharmacyPrescriptionController.type.value == "archive"
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
      hintText: AppStrings.searchPrescriptionHint.tr,
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
        padding: EdgeInsets.only(bottom: 20.h),
        itemCount: pharmacyPrescriptionController.prescriptions.length,
        itemBuilder: (context, index) {
          final prescription = pharmacyPrescriptionController.prescriptions[index];
          return PharmacyPrescriptionCard(
            onTap: () {
              // Navigate to the full dispensing screen with the prescription ID
              Get.to(() => PharmacyDispensingScreen(prescriptionId: prescription.id));
            },
            prescription: prescription,
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

  Widget _buildPrescriptionCard({
    required String id,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
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
              Text(
                id,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Oct 25, 2025  |  PKR 1,250",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "${AppStrings.pharmacistId.tr}: PH-021",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  AppStrings.exportPdfCsv.tr,
                  const Color(0xFFF0F2F5),
                  Colors.black87,
                      (){

                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildButton(
                    AppStrings.view.tr,
                    const Color(0xFF4A80E1),
                    Colors.white,
                        (){
                      Get.to(PharmacyPrescriptionRecord());
                    }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor,Function onTap) {
    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: () {
          onTap();
        },
        style: TextButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}