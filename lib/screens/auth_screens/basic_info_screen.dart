import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/auth_screens/pharmacy_professional_screen.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/display_field.dart';
import '../../widgets/profile_picture_widget.dart';
import '../../widgets/progress_stepper.dart';
import 'medical_vitals.dart';

class BasicInfoScreen extends StatelessWidget {
  BasicInfoScreen({super.key});

  SignUpController signUpController = Get.find();

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
              80.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/back_icon.png",
                      height: 32.h,
                      width: 32.w,
                    ),
                  ),
                  7.horizontalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.basicInfo.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.verticalSpace,
                      ProgressStepper(currentStep: 2, totalSteps: 5),
                      15.verticalSpace,
                      ProfilePictureWidget(
                        onTap: signUpController.showImageSourceOptions,
                        pickedImage: signUpController.pickedImage,
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: AppStrings.fullName.tr,
                        value: signUpController.nameController.text,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        controller: signUpController.registrationIdController,
                        labelText: AppStrings.registrationId.tr,
                        hintText: "#123RT56",
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: AppStrings.phoneNumber.tr,
                        value: signUpController.phoneNumberController.text,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        controller: signUpController.pharmacyAddressController,
                        labelText: AppStrings.pharmacyAddress.tr,
                        prefixIcon: Icons.location_on_outlined,
                        hintText: "32 Examaple St",
                      ),
                      CustomTextField(
                        labelText: AppStrings.city.tr,
                        prefixIcon: Icons.location_on,
                        hintText: "32 Examaple St",
                        controller: signUpController.cityController,
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.areaLocality.tr,
                        prefixIcon: Icons.location_on,
                        hintText: "32 Examaple St",
                        controller: signUpController.areaLocalityController,
                      ),
                    ],
                  ),
                ),
              ),

              20.verticalSpace,
              CustomButton(
                borderRadius: 15,
                text: AppStrings.continueText.tr,
                onTap: () {
                  if(signUpController.registrationIdController.text.isEmpty||
                      signUpController.pharmacyAddressController.text.isEmpty||
                      signUpController.cityController.text.isEmpty||
                      signUpController.areaLocalityController.text.isEmpty){
                    Get.snackbar(
                      AppStrings.warning.tr,
                      AppStrings.pleaseFillAllFields.tr,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  Get.to(PharmacyProfessionalScreen());
                },
              ),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}