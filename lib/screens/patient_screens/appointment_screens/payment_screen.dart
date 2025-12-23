import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/payment_controller.dart';
import 'package:patient_app/screens/patient_screens/main_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/patient_widgets/search_widgets/home_visit_status_dialog.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/search_widgets/appointment_confimation_dialog.dart';
import '../../../widgets/progress_stepper.dart';
import '../search_screens/add_new_card_screen.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  final PaymentController paymentController = Get.put(PaymentController());

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
                    AppStrings.payment.tr,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      30.verticalSpace,
                      Padding(
                        padding: EdgeInsets.only(right: 13.sp),
                        child: const ProgressStepper(currentStep: 3, totalSteps: 3),
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.section.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                          ),
                          100.horizontalSpace,
                          Text(
                            AppStrings.details.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            AppStrings.confirmation.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.paymentOption.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontFamily: AppFonts.jakartaBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: paymentController.payments.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: InkWell(
                                onTap: () {
                                  if (paymentController.payments[index] == "Cash") {
                                    if (paymentController.bookAppointmentController.appointmentType.value == "homeVisit") {
                                      paymentController.selectedPayment.value = paymentController.payments[index];
                                    } else {
                                      Get.snackbar(
                                          AppStrings.warning.tr,
                                          AppStrings.onlyHomeVisit.tr,
                                          colorText: Colors.white,
                                          backgroundColor: AppColors.red.withOpacity(0.6),
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  } else {
                                    paymentController.selectedPayment.value = paymentController.payments[index];
                                  }
                                },
                                child: Obx(
                                      () => Container(
                                    height: 70.h,
                                    width: 1.sw,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: paymentController.selectedPayment.value == paymentController.payments[index]
                                            ? AppColors.primaryColor
                                            : AppColors.lightGrey.withOpacity(0.5),
                                      ),
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 55.h,
                                          width: 55.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGrey.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(10.r),
                                          child: Image.asset(
                                            paymentController.paymentIcons[index],
                                          ),
                                        ),
                                        20.horizontalSpace,
                                        Text(
                                          paymentController.payments[index].tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                            fontFamily: AppFonts.jakartaMedium,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 20.h,
                                          width: 20.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color: paymentController.selectedPayment.value == paymentController.payments[index]
                                                  ? AppColors.primaryColor
                                                  : AppColors.lightGrey,
                                              width: 2,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(3.sp),
                                          alignment: Alignment.center,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: paymentController.selectedPayment.value == paymentController.payments[index]
                                                  ? AppColors.primaryColor
                                                  : Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.confirmAndPay.tr,
                        onTap: () {
                          Get.dialog(
                              barrierDismissible: false,
                              AppointmentConfirmationDialog(
                                  doctorName: "Dr Daniel",
                                  date: "12/02/26",
                                  time: "10:30",
                                  onDone: () {
                                    Get.offAll( MainScreen());
                                  },
                                  onViewDetails: () {}));
                        },
                      ),
                      15.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.addNewCard.tr,
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                        onTap: () {
                          Get.to( AddNewCardScreen());
                        },
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

  Future<void> showHomeVisitStatusDialog() async {
    if (paymentController.bookAppointmentController.appointmentType.value == "homeVisit") {
      await Future.delayed(const Duration(seconds: 3), () {
        Get.dialog(const HomeVisitStatusDialog(
          status: false,
        ));
      });
    }
  }
}