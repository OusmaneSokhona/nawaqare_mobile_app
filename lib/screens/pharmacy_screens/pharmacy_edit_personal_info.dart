import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controllers/sign_up_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/display_field.dart';
import '../../../widgets/profile_picture_widget.dart';

class PharmacyEditPersonalInfo extends GetView<SignUpController> {
  const PharmacyEditPersonalInfo({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              70.verticalSpace,
              Row(
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
                  Text(
                    AppStrings.editPersonalInfo.tr,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      15.verticalSpace,
                      ProfilePictureWidget(
                        onTap: controller.showImageSourceOptions,
                        pickedImage: controller.pickedImage,
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: AppStrings.fullName.tr,
                        value: "Alex Martin Pharmacy",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.registrationId.tr,
                        hintText: "#123RT56",
                      ),
                      10.verticalSpace,
                      DisplayFieldContainer(
                        label: AppStrings.phoneNumber.tr,
                        value: "+33 3 6 12 34 56 78",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.pharmacyAddress.tr,
                        prefixIcon: Icons.location_on_outlined,
                        hintText: "32 Example St",
                      ),
                      CustomTextField(
                        labelText: AppStrings.city.tr,
                        prefixIcon: Icons.location_on,
                        hintText: "Paris",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.areaLocality.tr,
                        prefixIcon: Icons.location_on,
                        hintText: "District 5",
                      ),
                      10.verticalSpace,
                      CustomTextField(
                        labelText: AppStrings.operatingHours.tr,
                        hintText: "5pm-10am",
                      ),
                      30.verticalSpace,
                      CustomButton(
                          borderRadius: 15,
                          text: AppStrings.update.tr,
                          onTap: () {}
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.cancel.tr,
                        onTap: () => Get.back(),
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                      ),
                      40.verticalSpace,
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