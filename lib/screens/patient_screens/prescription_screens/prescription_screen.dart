import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/prescription_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/patient_widgets/prescription_widgets/prescription_card.dart';

class PrescriptionScreen extends StatelessWidget {
  PrescriptionScreen({super.key});
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());

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
                    AppStrings.prescription.tr,
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
              Container(
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
                          prescriptionController.prescriptionType.value = "activePrescription";
                          prescriptionController.currentPage.value = 1;
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color: prescriptionController.prescriptionType.value == "activePrescription"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${AppStrings.activePrescriptions.tr}(${prescriptionController.prescriptions.length})",
                            style: TextStyle(
                              color: prescriptionController.prescriptionType.value == "activePrescription"
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                          () => InkWell(
                        onTap: () {
                          prescriptionController.prescriptionType.value = "pastPrescription";
                          prescriptionController.currentPage.value = 1;
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color: prescriptionController.prescriptionType.value == "pastPrescription"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${AppStrings.pastPrescriptions.tr}(${prescriptionController.postPrescriptions.length})",
                            style: TextStyle(
                              color: prescriptionController.prescriptionType.value == "pastPrescription"
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              Expanded(
                child: Obx(() {
                  if (prescriptionController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  var list = prescriptionController.paginatedList;
                  bool isActive = prescriptionController.prescriptionType.value == "activePrescription";

                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Icon(
                          isActive ? Icons.medical_services_outlined : Icons.history,
                          size: 100.w,
                          color: Colors.grey,
                        ),
                          20.verticalSpace,
                          Text(
                            isActive ? "No active prescriptions found" : "No past prescriptions found",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => prescriptionController.fetchAllPrescriptions(),
                    color: AppColors.primaryColor,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return PrescriptionCard(
                          onTap: () {
                            prescriptionController.viewDetail(list[index]);
                          },
                          isActive: isActive,
                          prescription: list[index],
                        );
                      },
                    ),
                  );
                }),
              ),
              10.verticalSpace,
              Obx(() {
                if (prescriptionController.paginatedList.isEmpty) {
                  return SizedBox.shrink();
                }
                return _buildPagination();
              }),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paginationArrow(Icons.arrow_back, () {
            if (prescriptionController.currentPage.value > 1) {
              prescriptionController.currentPage.value--;
            }
          }),
          15.horizontalSpace,
          ...List.generate(prescriptionController.totalPages, (index) {
            int page = index + 1;
            return GestureDetector(
              onTap: () => prescriptionController.currentPage.value = page,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: prescriptionController.currentPage.value == page
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "$page",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.jakartaMedium,
                    fontWeight: FontWeight.w600,
                    color: prescriptionController.currentPage.value == page
                        ? AppColors.primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }),
          15.horizontalSpace,
          _paginationArrow(Icons.arrow_forward, () {
            if (prescriptionController.currentPage.value < prescriptionController.totalPages) {
              prescriptionController.currentPage.value++;
            }
          }),
        ],
      ),
    );
  }

  Widget _paginationArrow(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 17.h,
          color: prescriptionController.currentPage.value == 1 && icon == Icons.arrow_back
              ? Colors.grey
              : prescriptionController.currentPage.value == prescriptionController.totalPages && icon == Icons.arrow_forward
              ? Colors.grey
              : Colors.black,
        ),
      ),
    );
  }
}