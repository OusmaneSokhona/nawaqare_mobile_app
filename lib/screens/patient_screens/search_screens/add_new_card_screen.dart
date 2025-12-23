import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/payment_controller.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart'; // Added import
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/search_widgets/card_date_cvv_widget.dart';

class AddNewCardScreen extends StatelessWidget {
  AddNewCardScreen({super.key});

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
                    AppStrings.addNewCard.tr, // Localized
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
                      CustomTextField(
                        labelText: AppStrings.cardHolderName.tr, // Localized
                        prefixIcon: Icons.person_outline_outlined,
                        hintText: AppStrings.enterName.tr, // Localized
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.cardNumber.tr, // Localized
                        prefixIcon: Icons.credit_card_outlined,
                        hintText: "XXXX-XXXX-XXXX",
                        keyboardType: TextInputType.number,
                      ),
                      10.verticalSpace,
                      CardDateCvvWidget(), // Ensure this widget also uses .tr internally
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.saveDetail.tr, // Localized
                        onTap: () {
                          Get.back();
                        },
                      ),
                      15.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.cancel.tr, // Localized
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                        onTap: () {
                          Get.back();
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
}