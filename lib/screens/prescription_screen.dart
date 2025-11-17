import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/prescription_controller.dart';
import 'package:patient_app/widgets/prescription_card.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/app_images.dart';

class PrescriptionScreen extends StatelessWidget {
  PrescriptionScreen({super.key});
PrescriptionController prescriptionController =Get.put(PrescriptionController());
  @override
  Widget build(BuildContext context) {
    print(prescriptionController.prescriptionType.value);
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
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
                    "Prescription",
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
                          prescriptionController.prescriptionType.value =
                          "activePrescription";
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color:
                            prescriptionController.prescriptionType.value ==
                                "activePrescription"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Active Prescriptions",
                            style: TextStyle(
                              color:
                              prescriptionController.prescriptionType.value ==
                                  "activePrescription"
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
                    Obx(
                          () => InkWell(
                        onTap: () {
                          prescriptionController.prescriptionType.value = "pastPrescription";
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color:
                            prescriptionController.prescriptionType.value==
                                "pastPrescription"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Past Prescriptions",
                            style: TextStyle(
                              color:
                              prescriptionController.prescriptionType.value ==
                                  "pastPrescription"
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
              Obx(
                    ()=> prescriptionController.prescriptionType.value=="activePrescription"?
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 20.h,bottom: 20.h),
                    itemCount: prescriptionController.prescriptions.length,
                    itemBuilder: (context, index) {
                      return PrescriptionCard(
                        onTap: (){
                          prescriptionController.viewDetail(prescriptionController.prescriptions[index]);
                        },
                        isActive: true,
                        prescription: prescriptionController.prescriptions[index],
                      );
                    },
                  ),
                ): Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 20.h,bottom: 20.h),
                    itemCount: prescriptionController.postPrescriptions.length,
                    itemBuilder: (context, index) {
                      return PrescriptionCard(
                        onTap: (){
                          prescriptionController.viewDetail(prescriptionController.postPrescriptions[index]);
                        },
                        isActive: false,
                        prescription: prescriptionController.postPrescriptions[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
