import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/payment_controller.dart';
import 'package:patient_app/screens/patient_screens/main_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/patient_widgets/search_widgets/home_visit_status_dialog.dart';
import 'package:patient_app/models/card_model.dart';
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
                        child: const ProgressStepper(
                            currentStep: 3, totalSteps: 3),
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
                      30.verticalSpace,
                      _buildSavedCardsSection(),
                      20.verticalSpace,
                      _buildPaymentOptionsSection(),
                      30.verticalSpace,
                      _buildPaymentErrorAndProcessing(),
                      20.verticalSpace,
                      _buildActionButtons(),
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

  Widget _buildSavedCardsSection() {
    return Obx(() {
      if (paymentController.savedCards.isEmpty) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                Icons.credit_card_off_outlined,
                size: 48.sp,
                color: Colors.grey,
              ),
              10.verticalSpace,
              Text(
                'No saved cards',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: AppFonts.jakartaMedium,
                  color: Colors.grey,
                ),
              ),
              5.verticalSpace,
              Text(
                'Add a new card to make payments faster',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: AppFonts.jakartaRegular,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved Cards',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: AppFonts.jakartaBold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => AddNewCardScreen());
                },
                child: Text(
                  'Add New',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ),
            ],
          ),
          15.verticalSpace,
          Container(
            height: 160.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: paymentController.savedCards.length,
              itemBuilder: (context, index) {
                CardModel card = paymentController.savedCards[index];
                return Container(
                  width: 300.w,
                  margin: EdgeInsets.only(right: 15.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getCardGradientColors(card.cardBrand),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        paymentController.selectCard(card);
                      },
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getCardIcon(card.cardBrand),
                                  color: Colors.white,
                                  size: 32.sp,
                                ),
                                const Spacer(),
                                if (card.isDefault)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      'Default',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.black,
                                        fontFamily: AppFonts.jakartaBold,
                                      ),
                                    ),
                                  ),
                                10.horizontalSpace,
                                Obx(() {
                                  bool isSelected = paymentController.selectedCard.value?.id == card.id;
                                  return Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? Colors.white : Colors.white70,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 16.sp,
                                    )
                                        : null,
                                  );
                                }),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.maskedCardNumber,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    letterSpacing: 2,
                                    fontFamily: AppFonts.jakartaBold,
                                  ),
                                ),
                                10.verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'CARD HOLDER',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 8.sp,
                                              fontFamily: AppFonts.jakartaMedium,
                                            ),
                                          ),
                                          Text(
                                            card.cardHolderName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontFamily: AppFonts.jakartaBold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'EXPIRES',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 8.sp,
                                            fontFamily: AppFonts.jakartaMedium,
                                          ),
                                        ),
                                        Text(
                                          card.expiryDate,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontFamily: AppFonts.jakartaBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPaymentOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.paymentOption.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: AppFonts.jakartaBold,
            fontWeight: FontWeight.w600,
          ),
        ),
        10.verticalSpace,
        Obx(() {
          if (paymentController.selectedPayment.value == "Credit/Debit Card" &&
              paymentController.savedCards.isNotEmpty) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      'Payment will be made using your selected card',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
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
                    if (paymentController.bookAppointmentController
                        .appointmentType.value ==
                        "homeVisit") {
                      paymentController.selectedPayment.value =
                      paymentController.payments[index];
                      paymentController.selectedCard.value = null;
                    } else {
                      Get.snackbar(
                          AppStrings.warning.tr,
                          AppStrings.onlyHomeVisit.tr,
                          colorText: Colors.white,
                          backgroundColor: AppColors.red.withOpacity(0.6),
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  } else {
                    paymentController.selectedPayment.value =
                    paymentController.payments[index];
                    if (paymentController.payments[index] != "Credit/Debit Card") {
                      paymentController.selectedCard.value = null;
                    }
                  }
                },
                child: Obx(
                      () => Container(
                    height: paymentController.selectedPayment.value ==
                        paymentController.payments[index]?100.h:70.h,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: paymentController.selectedPayment.value ==
                            paymentController.payments[index]
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                paymentController.payments[index].tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  fontFamily: AppFonts.jakartaMedium,
                                ),
                              ),
                              if (paymentController.payments[index] == "Credit/Debit Card" &&
                                  paymentController.selectedPayment.value == "Credit/Debit Card" &&
                                  paymentController.savedCards.isEmpty)
                                Text(
                                  'No cards saved. Tap "Add New Card" below',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.red,
                                    fontFamily: AppFonts.jakartaMedium,
                                  ),
                                ),
                              if (paymentController.payments[index] == "Credit/Debit Card" &&
                                  paymentController.selectedPayment.value == "Credit/Debit Card" &&
                                  paymentController.selectedCard.value != null)
                                Text(
                                  'Using: ${paymentController.selectedCard.value!.maskedCardNumber}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.primaryColor,
                                    fontFamily: AppFonts.jakartaMedium,
                                  ),
                                ),
                            ],
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
                              color: paymentController.selectedPayment.value ==
                                  paymentController.payments[index]
                                  ? AppColors.primaryColor
                                  : AppColors.lightGrey,
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.all(3.sp),
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: paymentController.selectedPayment.value ==
                                  paymentController.payments[index]
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
          },
        ),
      ],
    );
  }

  Widget _buildPaymentErrorAndProcessing() {
    return Column(
      children: [
        Obx(() => paymentController.paymentError.value.isNotEmpty
            ? Container(
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: AppColors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.red.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.red,
                size: 20.sp,
              ),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  paymentController.paymentError.value,
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 14.sp,
                    fontFamily: AppFonts.jakartaMedium,
                  ),
                ),
              ),
            ],
          ),
        )
            : const SizedBox.shrink()),
        Obx(() => paymentController.isProcessingPayment.value
            ? Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.w,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor),
                ),
              ),
              10.horizontalSpace,
              Text(
                "Processing payment...",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontFamily: AppFonts.jakartaMedium,
                ),
              ),
            ],
          ),
        )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomButton(
          borderRadius: 15,
          text: AppStrings.confirmAndPay.tr,
          onTap: () async {
            if (paymentController.selectedPayment.value.isEmpty) {
              Get.snackbar(
                "Payment Method Required",
                "Please select a payment method",
                colorText: Colors.white,
                backgroundColor: AppColors.red.withOpacity(0.6),
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            if (paymentController.selectedPayment.value == "Credit/Debit Card") {
              if (paymentController.savedCards.isEmpty) {
                Get.snackbar(
                  "No Card Found",
                  "Please add a card first",
                  colorText: Colors.white,
                  backgroundColor: AppColors.red.withOpacity(0.6),
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              if (paymentController.selectedCard.value == null) {
                Get.snackbar(
                  "Card Not Selected",
                  "Please select a card",
                  colorText: Colors.white,
                  backgroundColor: AppColors.red.withOpacity(0.6),
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
            }

            bool paymentSuccess = await paymentController.processPayment();

            if (paymentSuccess) {
              Get.dialog(
                barrierDismissible: false,
                AppointmentConfirmationDialog(
                  doctorName: "Dr Daniel",
                  date: "12/02/26",
                  time: "10:30",
                  onDone: () {
                    paymentController.resetPaymentState();
                    Get.offAll(() =>  MainScreen());
                  },
                  onViewDetails: () {},
                ),
              );
            }
          },
        ),
        15.verticalSpace,
        CustomButton(
          borderRadius: 15,
          text: AppStrings.addNewCard.tr,
          bgColor: AppColors.inACtiveButtonColor,
          fontColor: Colors.black,
          onTap: () {
            Get.to(() => AddNewCardScreen());
          },
        ),
      ],
    );
  }

  List<Color> _getCardGradientColors(String brand) {
    switch (brand) {
      case 'Visa':
        return [const Color(0xFF1a1f71), const Color(0xFF0e1a4b)];
      case 'Mastercard':
        return [const Color(0xFFeb001b), const Color(0xFFb00020)];
      case 'American Express':
        return [const Color(0xFF2e77bc), const Color(0xFF1e5799)];
      default:
        return [const Color(0xFF5f5f5f), const Color(0xFF404040)];
    }
  }

  IconData _getCardIcon(String brand) {
    switch (brand) {
      case 'Visa':
        return Icons.credit_card;
      case 'Mastercard':
        return Icons.credit_card;
      case 'American Express':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }

  Future<void> showHomeVisitStatusDialog() async {
    if (paymentController.bookAppointmentController.appointmentType.value ==
        "homeVisit") {
      await Future.delayed(const Duration(seconds: 3), () {
        Get.dialog(const HomeVisitStatusDialog(
          status: false,
        ));
      });
    }
  }
}