import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/payment_controller.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/search_widgets/card_date_cvv_widget.dart';

class PharmacyBankAccountDetailsScreen extends StatelessWidget {
  PharmacyBankAccountDetailsScreen({super.key});

  PaymentController paymentController = Get.put(PaymentController());

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
                    "Bank Account Details",
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
                        labelText: "Bank Name",
                        hintText: "Hbl Bank",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Account Holder Name",
                        prefixIcon: Icons.person_outline_outlined,
                        hintText: "Saira Tahir",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Account Number",
                        prefixImageIcon: "assets/images/logos_mastercard.png",
                        hintText: "XXXX-XXXX-XXXX",
                      ),
                      30.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "Save Detail",
                        onTap: () {
                          Get.back();
                        },
                      ),
                      15.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "Cancel",
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
